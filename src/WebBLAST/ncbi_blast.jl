
# BLAST API base url
base_url = "http://blast.ncbi.nlm.nih.gov/Blast.cgi"

# generic web api call
function call_api(;args...)
  query_string = ""
  for (k, v) in args
    if typeof(v) == ASCIIString
      v = encodeURI(v)
    end
    k = uppercase(string(k))
    if query_string != ""
      query_string = "$(query_string)&$(k)=$(v)"
    else
      query_string = "?$(k)=$(v)"
    end
  end

  query_string = "$(base_url)$(query_string)"

  return get(query_string)

end


# checks the status of the request to the ncbi server(s)
function ncbi_blast_search_info(rid)

  searching = false

  while true
    sleep(5)
    response = call_api(cmd="Get", format_object="SearchInfo", rid=rid).data
    # check status codes
    if ismatch(r"Status=WAITING", response)

      if searching
        print(".")
      else 
        print("Searching...")
        searching = true
      end
      continue
    end

    if ismatch(r"Status=FAILED", response)
      println("Search $( rid ) failed; please report to blast-help\@ncbi.nlm.nih.gov.\n")
      return false
    end

    if ismatch(r"Status=UNKNOWN", response)
      println("Search $( rid ) expired.\n")
      return false
    end

    if ismatch(r"Status=READY", response)
      return true
    end


    println("Something went wrong...\n")
    return false
  end
end

# gets the results of the search and 
function ncbi_blast_get_results(rid, threshold)
 content = call_api(cmd="Get", rid=rid, format_type="XML").data
#  f = open(string(rid, ".xml"), "w")
#  write(f, content)

#  f = open(string(rid, ".xml"))

# content = readall(f)
xml_doc = parse_string(content)

xroot = root(xml_doc)
hits = blast_hits(xroot)

results = Hit[]

if hits != 0
  for hit in hits
    hit_para = Dict{ASCIIString, Any}

    hitdict = attributes_dict(hit)

    hit_num_content = xml_value(hit, "Hit_num")
    hit_id_content = xml_value(hit, "Hit_id")
    hit_def_content = xml_value(hit, "Hit_def") 
    hit_accession_content = xml_value(hit, "Hit_accession")
    hit_len_content = xml_value(hit, "Hit_len")

    hit_hsps = find_element(hit, "Hit_hsps")
    hit_hsps_children = get_elements_by_tagname(hit_hsps, "Hsp")

        # put hsps into a dict
        hsps = Dict{Any,Any}[]
        for hsp in hit_hsps_children
          hsp_content = Dict()
          for el in child_elements(hsp)
            name_el = name(el)
            content_el = string(first(collect(child_nodes(el)))) 
            hsp_content[name_el] = content_el
          end

          push!(hsps, hsp_content)
        end

        # construct Hsp from dict
        hsps = map(construct_hsp, hsps)

        hit = Hit(int(hit_num_content), hit_id_content, hit_def_content, hit_accession_content, int(hit_len_content), hsps)
        
        

        # check if e-value of this hit is within threshold        
        if threshold > 0.0
          if check_threshold(threshold, hit) 
            push!(results, hit)
          end
        else
          push!(results, hit)
        end
        
      end

      info(string(length(hits), " Hits, ", length(results), " within threshold (", threshold, ")"))
      return results
    end

    return results
  end

# returns the RID of the query
function ncbi_blast_put(query, database="nr", program="blastp", hitlist_size=500)
  response = call_api(cmd="Put", QUERY=query, DATABASE=database, program=program, HITLIST_SZE=hitlist_size)

  m = match(r"RID = (.*)\n", response.data)
  rtoe = match(r"RTOE = (.*)\n", response.data)

  return (m.captures[1],rtoe.captures[1])
end


# extracts relevant hits from xml root
function blast_hits(xroot) 
  hits = 0
  for c in child_nodes(xroot)
    if is_elementnode(c)
     e1 = XMLElement(c)
     if name(e1) == "BlastOutput_iterations"
      e2 = find_element(e1, "Iteration")
      e3 = find_element(e2, "Iteration_hits")

      hits = get_elements_by_tagname(e3, "Hit")

    end
  end
end
return hits
end

#xml attribute value extraction convenience function
function xml_value(xml_node, attribute)
  element = find_element(xml_node, attribute)
  return string(first(collect(child_nodes(element))))
end


# construct Hsp, i'd like this to be an inner constructor in type Hsp,
# but i can't get it to work.

function construct_hsp(hsps)
  hsp_num = int(hsps["Hsp_num"])
  bitScore = float(hsps["Hsp_bit-score"])
  evalue = float(hsps["Hsp_evalue"])
  queryFrom = int(hsps["Hsp_query-from"])
  queryTo = int(hsps["Hsp_query-to"])
  queryFrame = int(hsps["Hsp_query-frame"])
  hitFrame = int(hsps["Hsp_hit-frame"])
  identity = int(hsps["Hsp_identity"])
  positive = int(hsps["Hsp_positive"])
  gaps = int(hsps["Hsp_gaps"])
  alignLen = int(hsps["Hsp_align-len"])
  qseq = aminoacid(hsps["Hsp_qseq"])
  qseq_str = string(hsps["Hsp_qseq"])
  hseq = aminoacid(hsps["Hsp_hseq"])
  midline = aminoacid(hsps["Hsp_midline"])

  return Hsp(hsp_num,
   bitScore,
   evalue,
   queryFrom,
   queryTo,
   queryFrame,
   hitFrame,
   identity,
   positive,
   gaps,
   alignLen,
   qseq,
   qseq_str,
   hseq,
   midline)
end

# BLAST API base url
base_url = "https://blast.ncbi.nlm.nih.gov/Blast.cgi"

function build_query_string(;args...)
  query_string = ""
  for (k, v) in args
    if typeof(v) == AbstractString
      v = encodeURI(v)
    end
    k = uppercase(string(k))
    if query_string != ""
      query_string = "$(query_string)&$(k)=$(v)"
    else
      query_string = "?$(k)=$(v)"
    end
  end
  return query_string
end

# generic web api call
function call_api(;args...)
  query_args = Dict()
  query_string = ""
  for (k, v) in args
    query_args[k] = v
    if typeof(v) == AbstractString
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
 
  response = get(query_string)

  return response

end


# checks the status of the request to the ncbi server(s)
function ncbi_blast_search_info(rid)

  searching = false

  while true
    sleep(5)
    response = readall(call_api(cmd="Get", format_object="SearchInfo", rid=rid))
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
 content = readall(call_api(cmd="Get", rid=rid, format_type="XML"))
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
    hit_para = Dict{AbstractString, Any}

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

        hit = Hit(parse(Int,hit_num_content), hit_id_content, hit_def_content, hit_accession_content, parse(Int,hit_len_content), hsps)
        
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
function ncbi_blast_put(query, database="pdb", program="blastp", hitlist_size=500)
  #response = call_api(cmd="Put", QUERY=query, DATABASE=database, program=program, HITLIST_SZE=hitlist_size)

  response = post(base_url; data=Dict("CMD" => "Put", "QUERY" => query, "DATABASE" => database, "program" => program, "HITLIST_SZE" => hitlist_size))
  response = readall(response)

  m = match(r"RID = (.*)\n", response)
  rtoe = match(r"RTOE = (.*)\n", response)

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
  hsp_num = parse(Int,hsps["Hsp_num"])
  bitScore = float(hsps["Hsp_bit-score"])
  evalue = float(hsps["Hsp_evalue"])
  queryFrom = parse(hsps["Hsp_query-from"])
  queryTo = parse(Int,hsps["Hsp_query-to"])
  queryFrame = parse(Int,hsps["Hsp_query-frame"])
  hitFrame = parse(Int,hsps["Hsp_hit-frame"])
  identity = parse(Int,hsps["Hsp_identity"])
  positive = parse(Int,hsps["Hsp_positive"])
  gaps = parse(Int,hsps["Hsp_gaps"])
  alignLen = parse(Int,hsps["Hsp_align-len"])
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

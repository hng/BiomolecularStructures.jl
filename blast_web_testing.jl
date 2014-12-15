# Base URL: http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=<command>{SPMamp;<name>=<value>}
# Web API Documentation: http://www.ncbi.nlm.nih.gov/blast/Doc/urlapi.html
#require("ArgParse")


using HttpCommon
using Requests
using LightXML
using FastaIO

# BLAST API base url
base_url = "http://blast.ncbi.nlm.nih.gov/Blast.cgi"

function main()
  rid, rtoe = blast_put(ARGS[1])
  println("RID: $(rid)")
  if blast_search_info(rid)
    blast_get_results(rid)
  end
end

function blast_search_info(rid)
  url = "$( base_url )?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=$( rid )"

  searching = false

  while true
    sleep(5)
    response = get(url).data
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

function blast_get_results(rid)
  url = "$( base_url )?CMD=Get&RID=$( rid )&FORMAT_TYPE=XML"
  println(url)
  content = get(url).data
  xml_doc = parse_string(content)

  xroot = root(xml_doc)
  c_nodes = child_nodes(xroot)
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
  
  if hits != 0
      for hit in hits
        hit_id = find_element(hit, "Hit_id")
        hit_id_content = first(collect(child_nodes(hit_id))) 
        println(hit_id_content)
     end
  end
end

# returns the RID of the query
function blast_put(query, database="nr", program="blastp", hitlist_size=500)
  query = encodeURI(query)
  response = get("$( base_url )?CMD=Put&QUERY=$( query )&DATABASE=$( database )&program=$( program )&HITLIST_SZE=$( hitlist_size )")

  m = match(r"RID = (.*)\n", response.data)
  rtoe = match(r"RTOE = (.*)\n", response.data)

  return (m.captures[1],rtoe.captures[1])
end

main()

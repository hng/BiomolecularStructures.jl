# Base URL: http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=<command>{SPMamp;<name>=<value>}
# Web API Documentation: http://www.ncbi.nlm.nih.gov/blast/Doc/urlapi.html
#require("ArgParse")


using HttpCommon
using Requests
using LightXML
using FastaIO

function main()
  println(blast_put(ARGS[1]))
end
base_url = "http://blast.ncbi.nlm.nih.gov/Blast.cgi"


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
        #hit_id = find_element(hit_id, "Hit_id")
        #hit_id_content = content(hit_id) # not working :(
        hit_id = content(hit_id)
        println(hit_id)

        hit_id_content = collect(child_nodes(hit_id))[1] 
        println(hit_id_content)
     end
  end
end

# returns the RID of the query
function blast_put(query, database="nr", program="blastp", hitlist_size=500)
  query = encodeURI(query)
  response = get("$( base_url )?CMD=Put&QUERY=$( query )&DATABASE=$( database )&program=$( program )&HITLIST_SZE=$( hitlist_size )")

  m = match(r"RID = (.*)\n", response.data)

  return m.captures[1]
end

#blast_get_results("8NYCJ5XX014") 

main()

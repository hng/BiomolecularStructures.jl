# Base URL: http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=<command>{SPMamp;<name>=<value>}
# Web API Documentation: http://www.ncbi.nlm.nih.gov/blast/Doc/urlapi.html
#require("ArgParse")


using HttpCommon
using Requests
using LightXML
using FastaIO

function main()
  println(ARGS[1])
  blast_put(ARGS[1])
end
base_url = "http://blast.ncbi.nlm.nih.gov/Blast.cgi"


function blast_get_results(rid)
  url = "$( base_url )?CMD=Get&RID=$( rid )&FORMAT_TYPE=XML"
  println(url)
  content = get(url).data
  println(content)
  xml_doc = parse_string(content)
  println(string(xml_doc))
end

function blast_put(query, database="nr", program="blastp", hitlist_size=500)
  query = encodeURI(query)
  println(query)
  xml_doc = get("$( base_url )?CMD=Put&QUERY=$( query )&DATABASE=$( database )&program=$( program )&HITLIST_SZE=$( hitlist_size )")
  println(xml_doc.headers)
  #println(string(xml_doc))
end

#blast_get_results("8NYCJ5XX014") 

main()
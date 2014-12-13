using FastaIO

for (name, seq) in FastaReader("3UGM.fasta.txt")
  println("$name : $seq")
end

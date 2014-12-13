using FastaIO

for (name, seq) in FastaReader("fasta/3UGM.fasta.txt")
  println("$name : $seq")
end

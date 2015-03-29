# MAFFT Module

This module provides a Julia wrapper for [MAFFT](http://mafft.cbrc.jp/alignment/software/) (Multiple alignment program for amino acid or nucleotide sequences).
Provides functions to call mafft with different pre-configurations (analogues to the provided anliases by mafft, see the mafft manpage) or custom parameters.
For general use of Mafft consult the [Mafft manual](http://mafft.cbrc.jp/alignment/software/manual/manual.html) or manpage.

Tested with MAFFT v7.215 (2014/12/17)

## Dependencies

  * MAFFT has to be installed
  * FastaIO

## Usage

```julia
mafft("examples/fasta/il4.fasta")
```

Runs mafft with the provided fasta file and returns the alignment in FastaIO dataformat. By default mafft is called with the `--auto` option.


```julia
mafft("examples/fasta/il4.fasta", ["--localpair", "--maxiterate", "1000"])
```

Calling mafft with custom arguments. Arguments have to be a array of strings. This call is also equivalent to calling:

```julia
 mafft("examples/fasta/il4.fasta", :linsi)
```

## Exported functions

```julia
mafft(fasta_in::String, preconfiguration=:default)
```

Runs mafft with the provided fasta file and returns the alignment in FastaIO dataformat. By default mafft is called with the `--auto` option.

*fasta_in*: path to FASTA file

*preconfiguration*: optional commandline arguments for MAFFT (array of strings)

```julia
mafft_from_string(fasta_in::String, preconfiguration=:default)
```

Calls MAFFT with the given FASTA string as input and returns aligned FASTA in the FastaIO dataformat. 

*fasta_in*: FASTA string

*preconfiguration*: optional commandline arguments for MAFFT (array of strings) 

```julia
mafft_from_fasta(fasta_in, preconfiguration=:default)
```

Calls MAFFT with the given FASTA in FastaIO format

*fasta_in*: FASTA in FastaIO format

*preconfiguration*: optional commandline arguments for MAFFT (array of strings)

```julia
mafft_profile(group1::String, group2::String)
```
Group-to-group alignments

*group1* and *group2* have to be files with alignments. Returns aligned FASTA in the FastaIO dataformat.

```julia
mafft_profile_from_string(group1::String, group2::String)
```
Group-to-group alignments with input strings in FASTA format.
 
 *group1* and *group2* have to be strings with alignments in FASTA format.
 
```julia
mafft_profile_from_fasta(group1, group2)
```

Group-to-group alignments with input in FastaIO format

*group1* and *group2* have to be in FastaIO format and have to be alignments

### Helper functions for aligned FASTA
This module also includes a few helper functions for the FastaIO dataformat (which is returned by the mafft functions of this module).

```julia
alignment_length(fasta)
```
Returns the length of the alignment.

*fasta*: A FastaIO dataformat object

```julia
to_aminoacids(fasta)
```
Converts a FastaIO-formatted array into an array of BioSeq AminoAcid.

*fasta*: A FastaIO dataformat object

```julia
print_fasta(fasta)
```
Prints a FastaIO object in a nicely formatted way to the screen.

*fasta*: A FastaIO dataformat object


## Supported pre-configurations (strategies)

The following mafft strategies are supported by built-in preconfigurations which can be used by supplying the function calls with the corresponding symbol (in the parentheses). 

  * L-INS-i (``:linsi``)
  * G-INS-i (``:ginsi``)
  * E-INS-i (``:einsi``)
  * FFT-NS-i (``:fftnsi``)
  * FFT-NS-2 (``:fftns``)
  * NW-NS-i (``:nwnsi``)
  * NW-NS-2 (``:nwns``)

## References
<ul>
<li>
Katoh, Standley 2013
(<a href="http://mbe.oxfordjournals.org/content/30/4/772"><i>Molecular Biology and Evolution</i> <b>30</b>:772-780</a>)
<br>
MAFFT multiple sequence alignment software version 7: improvements in performance and usability.
<br>
(outlines version 7)
<li>
Kuraku, Zmasek, Nishimura, Katoh 
(<a href="http://nar.oxfordjournals.org/content/41/W1/W22.abstract"><i>Nucleic Acids Research</i> <b>41</b>:W22-W28</a>)
<br>
aLeaves facilitates on-demand exploration of metazoan gene family trees on MAFFT sequence alignment server with enhanced interactivity.
<br>
(describes an interactive sequence collection/selection service by <a href="http://aleaves.cdb.riken.jp/" target="_blank" onClick="_gaq.push(['_trackEvent', 'aleaves', 'link', 'server']);">aLeaves</a>, <a href="../server/">MAFFT</a> and <a href="../server/gotoaptx.html" target="_blank">Archaeopteryx</a>)
<li>
Katoh, Frith 2012
(<a href="http://bioinformatics.oxfordjournals.org/content/28/23/3144"><i>Bioinformatics</i> <b>28</b>:3144-3146</a>)
<br>
Adding unaligned sequences into an existing alignment using MAFFT and LAST.
<br>
(describes the <a href="addsequences.html"><tt><b>--add</b></tt></a> and <a href="addsequences.html#fragments"><tt><b>--addfragments</b></tt></a> options)
<li>
Katoh, Toh 2010
(<a href="http://bioinformatics.oxfordjournals.org/cgi/content/abstract/26/15/1899"><i>Bioinformatics</i> <b>26</b>:1899-1900</a>)
<br>
Parallelization of the MAFFT multiple sequence alignment program.
<br>
(describes the multithread version)
<li>
Katoh, Asimenos, Toh 2009
(<a href="http://www.springerlink.com/content/h273273566336n74/"><i>Methods in Molecular Biology</i> <b>537</b>:39-64</a>)
<br>Multiple Alignment of DNA Sequences with MAFFT. In <i>Bioinformatics for DNA Sequence Analysis</i> edited by D. Posada
<br>(outlines DNA alignment methods and several tips including group-to-group alignment and rough clustering of a large number of sequences)
<li>
Katoh, Toh 2008
(<a href="http://www.biomedcentral.com/1471-2105/9/212"><i>BMC Bioinformatics</i> <b>9</b>:212</a>)
<br>Improved accuracy of multiple ncRNA alignment by incorporating structural information into a MAFFT-based framework.
<br>(describes RNA structural alignment methods)
<li>
Katoh, Toh 2008
(<a href="http://bib.oxfordjournals.org/cgi/content/abstract/9/4/286"><i>Briefings in Bioinformatics</i> <b>9</b>:286-298</a>)
<br>Recent developments in the MAFFT multiple sequence alignment program.
<br>(outlines version 6;
<a href="http://sciencewatch.com/dr/fbp/2009/09octfbp/09octfbpKato/">Fast Breaking Paper in Thomson Reuters' ScienceWatch</a>)
<li>
Katoh, Toh 2007
(<a href="http://bioinformatics.oxfordjournals.org/cgi/content/abstract/23/3/372"><i>Bioinformatics</i> <b>23</b>:372-374</a>)&nbsp; <a href="errata.html"><span class="redc00">Errata</span></a>
<br>
PartTree: an algorithm to build an approximate tree from a large number of unaligned sequences.
<br>
(describes the PartTree algorithm)
<li>
Katoh, Kuma, Toh, Miyata 2005
(<a href="http://nar.oupjournals.org/cgi/content/abstract/33/2/511"><i>Nucleic Acids Res.</i> <b>33</b>:511-518</a>)
<br>
MAFFT version 5: improvement in accuracy of multiple sequence alignment.
<br>
(describes [ancestral versions of] the G-INS-i, L-INS-i and E-INS-i strategies)
<li>
Katoh, Misawa, Kuma, Miyata 2002
(<a href="http://nar.oupjournals.org/cgi/content/abstract/30/14/3059"><i>Nucleic Acids Res.</i> <b>30</b>:3059-3066</a>)
<br>MAFFT: a novel method for rapid multiple sequence alignment based on
fast Fourier transform.
<br>
(describes the FFT-NS-1, FFT-NS-2 and FFT-NS-i strategies)
</ul>

# RNAseq
#article:From RNA-seq reads to differential expression results
#download data
nohup wget ftp://ftp.ensemblgenomes.org/pub/plants/release-28/fasta/arabidopsis_thaliana/cdna/Arabidopsis_thaliana.TAIR10.28.cdna.all.fa.gz &
nohup wget ftp://ftp.ensemblgenomes.org/pub/plants/release-28/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.28.dna.genome.fa.gz &
nohup wget  ftp://ftp.ensemblgenomes.org/pub/plants/release-28/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.28.gff3.gz &
nohup wget ftp://ftp.ensemblgenomes.org/pub/plants/release-28/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.28.gtf.gz &
#download rawdata
wget "http://www.ebi.ac.uk/arrayexpress/files/E-MTAB-5130/E-MTAB-5130.sdrf.txt"
awk 'NR>1' E-MTAB-5130.sdrf.txt | cut -f 33 |cat | while read id;do(nohup wget $id &);done

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
#install salmon
conda install -c bioconda salmon 
#build salmon index
salmon index -t Arabidopsis_thaliana.TAIR10.28.cdna.all.fa.gz -i athal_index
#map & counts
#! /bin/bash
index=/data3/zhengzx/rnaseq/Database/arabidopsis/athal_index #index directory
for fn in ERR1698{194..209};
do
    sample=`basename ${fn}`
    echo "Processin sample ${sampe}"
    salmon quant -i $index -l A \
        -1 ${sample}_1.fastq.gz \
        -2 ${sample}_2.fastq.gz \
        -p 28 -o quants/${sample}_quant
done

#替换quant.sf里的表头TPM信息
ls */quant.sf |while read id;do(abc=$(dirname  $id );abcd=${abc%%"_quant"};sed -i "s/TPM/$abcd/" $id);done
#生成大的表达矩阵
paste */quant.sf |awk -F "\t" '{printf $1"\t";for(i=4;i<=NF;i=i+5){printf $i"\t"};print $i}' > all.counts.txt
#去掉末尾的制表符
sed -i 's/\t$/$/g' all.counts.txt

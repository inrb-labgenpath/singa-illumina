#!/bin/bash

#set -eo pipefail

cat << singa
################################################################
Name ------------------- : singa_illumina.sh
Author ----------------- : Emmanuel Lokilo (INRB)
Version ---------------- : v.2024.01
Affiliation ------------ : Pathogen Genomics Laboratory (INRB)
Date ------------------- : 2024-06-07
Latest_Modification ---- : 2024-07-23
Use -------------------- : bash singa_illumina.sh
################################################################
singa

cat << Warning
################################################################
Before running the script, make sure you have installed all the
following packages and activated the conda singa_illumina.yalm environment

$ Make sure you have activated the environment by : "conda activate singa_illumina.yalm"

################################################################
Warning

#location of files to process

fastq=($(find ../reads -type f -name *.fastq.gz | cut -d "/" -f 3))
reads=($(find ../reads -type f -name *.fastq.gz))
f_id=$(echo ${fastq} | sed -E "s/_(.*)//g") 

echo ""
echo "`echo ${#fastq[@]}/2 | bc` illumina file(s) wating to be processed"
echo ""

# Proceeding to base quality vizualisation of illumina files before Trimming

for read in "${reads[@]}"
  do
    fastq=($(find ../reads -type f -name *.fastq.gz | cut -d "/" -f 3))
    f_id=$(echo ${fastq} | sed -E "s/_(.*)//g")
    # creating illumina samples subdirectories for the fastqc outputs
    mkdir -p ../fastqc_BT/`basename $f_id`

    # running fastqc for each sample
    echo "" 
    echo "Running FASTQC for `basename $basename $f_id` sample"
    echo ""
    fastqc $read -o ../fastqc_BT/`basename $basename $f_id`
done

mkdir --force -p ../multiQC
multiqc ../fastqc_BT/*/* -o ../multiQC/multiQC_BT #BT : Before Trimming

#Trimming low quality reads and adapters using fastp

names=($(find ../reads -type f -name *.fastq.gz | xargs basename -s ".fastq.gz" | sed 's/_R1//' | sed 's/_R2//'))

for name in "${names[@]}"    #display the fastq filename in the screen
do echo $name >> name_io.txt
done

sort name_io.txt | uniq > name_io_uniq.txt

samples=($(cut -f 1 name_io_uniq.txt))

for read in "${samples[@]}"
  do
    R1=($(find ../reads -type f -name *R1.fastq.gz))
    R2=($(find ../reads -type f -name *R2.fastq.gz))
    # # creating illumina samples subdirectories for the fastp outputs
    mkdir -p ../trimmed/`echo $f_id`

    # # running fastp for each sample
    echo "" 
    echo "Running FASTP for $f_id sample"
    echo ""
    fastp -V --adapter_fasta IlluminaAdapters.fa -i $R1 -I $R2 -o ../trimmed/`echo $read`/`echo $read"_R1.fastq"` -O ../trimmed/`echo $read`/`echo $read"_R2.fastq"` -h ../trimmed/`echo $read`/`echo $read`
done

#Proceeding to base quality vizualisation of illumina files after Trimming
 
reads=($(find ../trimmed -type f -name *fastq)) 

for read in "${reads[@]}"
  do
    fastq=`echo $read | cut -d "/" -f 3`
    f_id=$(echo ${fastq} | sed -E "s/_(.*)//g")
    # creating illumina samples subdirectories for the fastqc outputs
    mkdir -p ../fastqc_AT/`basename $f_id`

    # running fastqc for each sample
    echo "" 
    echo "Running FASTQC for `basename $f_id` sample"
    echo "" 
   fastqc $read -o ../fastqc_AT/`basename $f_id`
done

multiqc ../fastqc_AT/*/* -o ../multiQC/multiQC_AT #AT : After Trimming

#Polishing by depleting them from human reads with minimap2 and samtools

reads_tr=($(find ../trimmed -type f -name *.fastq))
names_tr=($(find ../trimmed -type f -name *.fastq | xargs basename -s ".fastq" | sed 's/_R1//' | sed 's/_R2//'))

for name in "${names_tr[@]}"    #display the fastq filename in the screen
do echo $name >> name.txt
done

sort name.txt | uniq > name_uniq.txt

samplenames=($(cut -f 1 name_uniq.txt))

for samplename in "${samplenames[@]}"
  do
    # creating illumina samples subdirectories for the human depleting outputs
      mkdir -p ../bams/`echo $samplename` ../not_human/`echo $samplename` ../trimmed_bams/ ../consensus/ ../variants

    # # running fastp for each sample
      echo "" 
      echo "Running MINIMAP2 and SAMTOOLS for $samplename sample"
      echo ""
      minimap2 --split-prefix=tmp$$ -a -xsr ../human_reference/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz ../trimmed/`echo $samplename`/`echo $samplename"_R1.fastq"` ../trimmed/`echo $samplename`/`echo $samplename"_R2.fastq"` | samtools view -bh | samtools sort -o ../bams/`echo $samplename`/$samplename".bam"

        samtools index ../bams/`echo $samplename`/$samplename".bam"
        samtools fastq -F 3584 -f 77 ../bams/`echo $samplename`/$samplename".bam" > ../not_human/`echo $samplename`/`echo $samplename"_R1.fastq"`
        samtools fastq -F 3584 -f 141 ../bams/`echo $samplename`/$samplename".bam" > ../not_human/`echo $samplename`/`echo $samplename"_R2.fastq"`
        samtools fastq -f 4 -F 1 ../bams/`echo $samplename`/$samplename".bam" > ../not_human/`echo $samplename`/`echo $samplename"_S_Singletons.fastq"`

   #   echo "Mapping $samplename sample to the human reference with MINIMAP2 and dispatch reads"
        bwa index ../reference/MPXV.reference.fasta

        bwa mem ../reference/MPXV.reference.fasta ../not_human/`echo $samplename`/`echo $samplename"_R1.fastq"` ../not_human/`echo $samplename`/`echo $samplename"_R2.fastq"` | samtools view -F 4 -Sb | samtools sort -T `echo $samplename".align"` -o ../not_human/`echo $samplename`/`echo $samplename".sorted.bam"`

   #   echo "Trimming $samplename primers from non human reads"

        ivar trim -e -i ../not_human/`echo $samplename`/`echo $samplename".sorted.bam"` -b ../reference/MPXV.bed -p ../not_human/`echo $samplename`/`echo $samplename".trimmed.bam"`

        samtools sort -T ../not_human/`echo $samplename`/`echo $samplename".trim"` -o ../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"` ../not_human/`echo $samplename`/`echo $samplename".trimmed.bam"`

   #   echo "Generating consensus from $samplename bams file"

        samtools mpileup -A -Q 0 -d 300000 ../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"` | ivar consensus -p ../not_human/`echo $samplename`/`echo $samplename".fa"` -m 30 -n N

   #   echo "Generating variant from $samplename bams file"

        samtools mpileup -aa -A -B -Q 0 ../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"` | ivar variants -p ../not_human/`echo $samplename`/`echo $samplename"_variant"` -t 0.03 -m 10 -r ../reference/MPXV.reference.fasta -g ../reference/MPXV.gff3

        python fasta-coverage.py ../not_human/`echo $samplename`/`echo $samplename".fa"` >> ../not_human/coverage.tsv

        samtools depth -d 0 -aa ../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"` | awk -v b="../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"`" 'BEGIN{MIN=10000000000;MAX=0;NUC=0;COV=0;DEPTH=0;NUCZERO=0;}{if(MIN > $3){MIN=$3;};if(MAX < $3){MAX=$3;};if($3==0){NUCZERO+=1};if($3 > 0){COV+=1;}NUC+=1;DEPTH+=$3;}END{if(NUC>0){print b"\t"DEPTH/NUC"\t"MIN"\t"MAX"\t"NUCZERO}else{print b"\t"0"\t"MIN"\t"MAX"\t"NUCZERO}}' >> ../not_human/coverage_depth.tsv

        cp ../not_human/`echo $samplename`/`echo $samplename".fa"` ../consensus/

        cp ../not_human/`echo $samplename`/`echo $samplename".trimmed.sorted.bam"` ../trimmed_bams/

        cp ../not_human/`echo $samplename`/`echo $samplename"_variant.tsv"` ../variants/
done

mkdir ../`date "+%Y_%m_%d_%H:%M"`_results/
mv ../[fcmtnbv]* ../`date "+%Y_%m_%d_%H:%M"`_results
rm -rf name*


echo "" 
echo "Matondo nabosaleli ya singa"
echo "" 
echo "Thank you for using the pipeline"
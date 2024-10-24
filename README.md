## <span style="color: green;">🌿 MpxV-SINGA</span> <span style="color: white;">: </span> <span style="color: blue;">🦠 MonkeyPox Virus - </span> <span style="color: green;">🧬 Sequence </span> <span style="color: yellow;">Information </span> <span style="color: white;">from </span> <span style="color: red;">🧪 Nucleotide </span> <span style="color: brown;">Generation </span> <span style="color: white;">and </span> <span style="color: purple;">🛠️ Assembly</span>

![Maintainer](https://badgen.net/badge/Maintener/Emmanuel%20Lokilo/blue?scale=0.9)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with Python](http://img.shields.io/badge/run%20with-Python-3776AB?labelColor=000000&logo=python)](https://www.python.org/)
[![run with Snakemake](http://img.shields.io/badge/run%20with-Snakemake-4EAA25?labelColor=000000&logo=snakemake)](https://snakemake.readthedocs.io/en/stable/)
[![Join the Slack Channel](https://img.shields.io/badge/Join%20the%20Slack%20Channel-4A154A?style=flat&logo=slack&logoColor=white)](https://singapipeline.slack.com)
[![Bash](https://img.shields.io/badge/run%20with-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
![macOS](https://badgen.net/badge/icon/Hight%20Sierra%20(10.13.6)%20%7C%20Catalina%20(10.15.7)%20%7C%20Big%20Sure%20(11.6.3)%20%7C%20Monterey%20(12.6.0)%20%7C%20Ventura%20(13.3.1)%20%7C%20Sonoma(%2014.2.1)/E6055C?icon=apple&label&list=%7C&scale=0.9)
![Ubuntu](https://badgen.net/badge/icon/Bionic%20Beaver%20(18.04)%20%7C%20Focal%20Fossa%20(20.04)%20%7C%20Jammy%20Jellyfish%20(22.04)/772953?icon=https://www.svgrepo.com/show/25424/ubuntu-logo.svg&label&list=%7C&scale=0.9)
![Windows](https://badgen.net/badge/icon/Bionic%20Beaver%20(18.04)%20%7C%20Focal%20Fossa%20(20.04)%20%7C%20Jammy%20Jellyfish%20(22.04)/00BCF2?icon=windows&label&list=%7C&scale=0.9)
![Maintained](https://badgen.net/badge/Maintened/Yes/red?scale=0.9)
![Open Source](https://badgen.net/badge/icon/Open%20Source/purple?icon=https://upload.wikimedia.org/wikipedia/commons/4/44/Coraz%C3%B3n.svg&label&scale=0.9)
![GitHub](https://badgen.net/badge/icon/GitHub/black?icon=https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png&label&scale=0.9) 

## Introduction

`SINGA` is a bioinformatics analysis pipeline designed for the assembly and variant calling of Monkeypox Virus (MPXV) samples. This pipeline places an emphasis on quality control, ensuring that low-quality reads are filtered out, primers are effectively trimmed, and human-derived reads are depleted. As a result, users can obtain high-quality MPXV sequences. Tailored specifically for Illumina sequencing data (singa-illumina repository), SINGA is optimized for amplicon-based approaches, focusing on data generated using carefully curated primer sets.

## Pipeline Overview

`SINGA` is designed with flexibility in mind, enabling users to execute specific components of the workflow as needed. For example, users can create an environment.yml file to manage dependencies using Conda, ensuring a reproducible environment for their analyses. The pipeline effectively integrates both Bash and Python scripts, all of which are managed by the Snakemake workflow manager. Furthermore, users have full access to all pipeline files, allowing them to edit and customize the workflow according to their specific requirements.

--------------------------------------------------------------------------------------------------------------------------------------------------------------

[![FastQC](https://badgen.net/badge/icon/FastQC/4CAF50?icon=appveyor&label)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) : Visualize reads quality before and after the reads trimming

[![Fastp](https://badgen.net/badge/icon/Fastp/4CAF50?icon=appveyor&label)](https://github.com/OpenGene/fastp) : Remove adapters and low quality reads

[![FastQ Screen](https://badgen.net/badge/icon/FastQ%20Screen/3F51B5?icon=appveyor&label)](https://github.com/GenePool/fastq_screen) : check for contamination

[![MultiQC](https://badgen.net/badge/icon/MultiQC/4CAF50?icon=appveyor&label)](https://github.com/MultiQC/MultiQC) : Assemble of the reports into a html file

[![BWA](https://badgen.net/badge/icon/BWA/3F51B5?icon=appveyor&label)](https://github.com/lh3/bwa) : Reads alignment and mapping

[![Samtools](https://badgen.net/badge/icon/Samtools/3F51B5?icon=appveyor&label)](https://github.com/samtools/samtools) : Sort, index and filter alignment

[![Bedtools](https://badgen.net/badge/icon/Bedtools/0072B2?icon=github&label)](https://bedtools.readthedocs.io/en/latest/) : mask genome region

[![iVar](https://badgen.net/badge/icon/IVAR/FF5722?icon=github&label)](https://github.com/olavloite/ivar) : Primer trimming

[![FreeBayes](https://badgen.net/badge/icon/FreeBayes/00BFFF?icon=github&label)](https://github.com/freebayes/freebayes): Generate VCF files

[![bcftools](https://badgen.net/badge/icon/bcftools?icon=https://upload.wikimedia.org/wikipedia/commons/2/28/BCFtools_logo.svg&label)](https://samtools.github.io/bcftools/) : Generate consenus file

--------------------------------------------------------------------------------------------------------------------------------------------------------------

## Usage

1. Clone the singa-illumina repository
   ```bash
   git clone https://github.com/inrb-labgenpath/singa-illumina.git
   ```
2. Create the singa-illumina conda environment
   ```bash
   cd singa-illumina/pipeline && conda env create -f environment.yml
   ```
   N.B: You can use `mamba` instead of `conda` (it is quicker)
   ```conda install -c conda-forge mamba```
   
3. Activate the singa-illumina conda environment
   ```bash
   conda activate singa-illumina
   ```

   !!! You may need to increase memory for Java (4 Go for this "-Xm4g"
   
         
         export _JAVA_OPTIONS="-Xmx4g" >> ~/.bash_profile or export _JAVA_OPTIONS="-Xmx4g" >> ~/.bashrc
         source ~/.bash_profile or source ~/.bashrc

5. Make sure to give the right absolute path for every folder

  <img width="1199" alt="Capture d’écran 2024-09-27 à 18 34 21" src="https://github.com/user-attachments/assets/064cfb8e-c32c-4652-b4e9-efb64bc06f35">

  Open the config.json file and give the right path to :
  
  `ref_path` : your primer-scheme reference and bed file
  
  `mask_reference` : a mpxv_3_LTR.bed gives cordinates for masking the 3' LTR of your mpxv reference
  
  `adapters` : the sequences used in the illumina (important to check that in the pipeline/IlluminaAdapters.fa file)
  
  `human_ref` : the human reference
  
  `fastq_dir` : path to fastq R1 and R2 
  
  `out_dir` : path to output directory
  
  `confile` : path to the fastq_screen file (make sure to open it and correct the path of each database)
  
  `gvcf_py` : generate a gvcf file
  
  `depth_cov` : minimum coverage to consider a base in a position
  
  `sample_path` : sample.tsv generated by create_sample_sheet.sh file
  
  `threads` : number of threads to run the command
  
  `mem` : amount of memory dedicated each specific command

   
5. Copy the .R1 and .R2 fastq.gz files to the /reads folder in the current directory (create the repo once)
   ```bash
   mkdir -p ../reads && ls -l ../
   ```
   ![image](https://github.com/user-attachments/assets/ec7ee73c-1765-4920-bc13-55f4ade17b50)

7. Generate the sample_sheet  
   ```bash
   bash create_sample_sheet.sh
   ```
5. Run the Snakemake file with a suitable number of cores for your host (use `htop` or `nproc` to check)
   ```bash
   snakemake --cores all 
   ```
   ```bash
   snakemake --cores all --rerun-incomplete  # in case you want to resume your analysis
   ```
   ```bash
   snakemake --cores all --rerun-incomplete --forceall  # in case you want to restart your analysis
   ```
   
Miscellaneous

   - Make sure about the primer-scheme you want to use. SINGA propose a list of pipeline similar to ones from artic. (By default, yale-mpox/v1.0.0-cladeI is selected)
     
     <img width="169" alt="Capture d’écran 2024-09-27 à 16 31 59" src="https://github.com/user-attachments/assets/53556ab7-369c-4849-ba76-f11ee93a04d8">
     
   - You can customize fastqscreen, make sure the reference is indexed and the path is exact in the pipeline/fastq_screen.conf file

## Documentation

The development of the SINGA pipeline has greatly benefited from collaborative efforts and contributions from various sources within the scientific community. Notably, insights gained from the `INRB 2023 workshop` (https://github.com/linsalrob/ComputationalGenomicsManual/blob/master/Workshops/INRB2023.md) have provided valuable knowledge and hands-on experience in computational genomics, enriching the pipeline's framework. Additionally, the expertise shared through `GeVarLi` (https://forge.ird.fr/transvihmi/nfernandez/GeVarLi) has further enhanced our understanding of genomic variation analysis. Acknowledgment is also due to the ARTIC Network's ongoing support, particularly through the `artic-mpxv-illumina-nf` and `piranha` repository (https://github.com/artic-network/artic-mpxv-illumina-nf) and (https://github.com/polio-nanopore/piranha) and other pipelines, which has offered robust resources and methodologies for analyzing Monkeypox Virus sequences. Together, these contributions have strengthened the development of SINGA, ensuring that it remains a reliable and cutting-edge tool for the genomic analysis of MPXV samples.


## Support

The invaluable support of the INRB data team—Gradi Luakanda, Sifa Kavira, and Princesse Paku—along with all the colleagues from the INRB Lab Gen Path, has been essential to the success of this project. Their expertise, dedication, and collaboration have helped overcome various challenges and ensured the project's successful completion. The pipeline improvement is still ongoing.

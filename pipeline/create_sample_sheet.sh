#!/bin/bash

# Extract configuration using Python
fastq_dir=$(python3 -c 'import json; print(json.load(open("config.json"))["fastq_dir"])')

# Verify that the directory exists
if [ ! -d "$fastq_dir" ]; then
    echo "Directory $fastq_dir does not exist. Please check the config file."
    exit 1
fi

# Create samples.tsv file with header
echo -e "forward\treverse\tsample\tsample_library" > samples.tsv

# Debugging: List files to ensure the find command is working correctly
echo "Finding FASTQ files in $fastq_dir..."

# Find and process FASTQ files
find "$fastq_dir" -name "*.fastq.gz" | sort | xargs -n 2 bash -c '
    forward_fastq=$0
    reverse_fastq=$1

    # Debugging: Output the files being processed
    # echo "Processing: $forward_fastq, $reverse_fastq"

    # Extract the file name without the path for both forward and reverse
    forward_filename=$(basename "$forward_fastq")
    reverse_filename=$(basename "$reverse_fastq")

    # Detect the sample name based on different formats
    if [[ $forward_filename =~ ^([^_]+)_R[12].fastq.gz$ ]]; then
        # Format: <sample>_R1.fastq.gz or <sample>_R2.fastq.gz
        sample_name="${BASH_REMATCH[1]}"
        sample_library="${sample_name}_L1"

    elif [[ $forward_filename =~ ^([^_]+)_S[0-9]+_L[0-9]+_R[12]_001.fastq.gz$ ]]; then
        # Format: <sample>_S<sample_number>_L<lane_number>_R<read_direction>_001.fastq.gz
        sample_name="${BASH_REMATCH[1]}"
        sample_library="${sample_name}_L1"

    else
        # Default case for unknown formats (you can adjust this as needed)
        sample_name=$(echo "$forward_filename" | cut -f 1 -d "_")
        sample_library="${sample_name}_L1"
    fi

    # Output the results to samples.tsv
    echo -e "$forward_fastq\t$reverse_fastq\t${sample_name}\t${sample_library}"
' >> samples.tsv

# Debugging: Verify the content of samples.tsv
echo "Content of samples.tsv:"
cat samples.tsv


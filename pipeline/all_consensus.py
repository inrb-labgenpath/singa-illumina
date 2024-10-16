import sys

def concatenate_consensus_files(input_files, output_file):
    """
    Concatenate all the provided .consensus.fasta files into a single output file.

    Parameters:
    - input_files (list): List of input .consensus.fasta files.
    - output_file (str): Path to the output file where all sequences will be concatenated.
    """
    # Open the output file in write mode
    with open(output_file, "w") as outfile:
        for input_file in input_files:
            # Write a header indicating the file being added (optional)
            # outfile.write(f"\n# Concatenating {input_file}\n")

            # Read the content of each consensus file and write to the output file
            with open(input_file, "r") as infile:
                outfile.write(infile.read())

    print(f"All .consensus.fasta files have been concatenated into {output_file}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python allcons.py <input_file1> <input_file2> ... <output_file>")
        sys.exit(1)

    input_files = sys.argv[1:-1]
    output_file = sys.argv[-1]
    concatenate_consensus_files(input_files, output_file)


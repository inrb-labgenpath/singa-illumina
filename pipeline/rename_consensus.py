import os
import sys

def modify_consensus_files_in_place(input_path):
    """
    Modify the first line of each .consensus.fasta file in the directory 
    of input_path to include the filename (without extension) followed by '>'.
    This change is done directly in the original file.
    """
    # Get the directory from the input path
    directory = os.path.dirname(input_path)

    # Check if the directory exists
    if not os.path.exists(directory):
        raise FileNotFoundError(f"Directory '{directory}' does not exist.")

    for filename in os.listdir(directory):
        if filename.endswith(".consensus.fasta"):
            input_file = os.path.join(directory, filename)

            # Read the content of the original file
            with open(input_file, "r") as f:
                lines = f.readlines()

            # Extract the base name without extension and modify the first line
            base_name = os.path.splitext(filename)[0]
            lines[0] = f">{base_name}\n"

            # Write the modified content back to the same file
            with open(input_file, "w") as f:
                f.writelines(lines)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python rename_consensus.py <input_path>")
        sys.exit(1)

    input_path = sys.argv[1]
    modify_consensus_files_in_place(input_path)
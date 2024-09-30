import os
import sys

def modify_consensus_files_in_place(input_path):
    """
    Modify the first line of each .fa file in the input_path to include the filename followed by '>'.
    This change is done directly in the original file.
    """
    # Check if input directory exists
    if not os.path.exists(input_path):
        raise FileNotFoundError(f"Input directory '{input_path}' does not exist.")

    for filename in os.listdir(input_path):
        if filename.endswith(".fa"):
            input_file = os.path.join(input_path, filename)

            # Read the content of the original file
            with open(input_file, "r") as f:
                lines = f.readlines()

            # Modify the first line to include the filename followed by '>'
            lines[0] = f">{filename}\n"

            # Write the modified content back to the same file
            with open(input_file, "w") as f:
                f.writelines(lines)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python rename_consensus.py <input_path>")
        sys.exit(1)

    input_path = sys.argv[1]
    modify_consensus_files_in_place(input_path)


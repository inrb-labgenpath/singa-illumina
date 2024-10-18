import os
import pandas as pd
import matplotlib.pyplot as plt
import sys
import numpy as np

def plot_depth_coverage(input_file, output_plot):
    # Read the TSV file
    data = pd.read_csv(input_file, sep="\t", header=None, names=["Chromosome", "Position", "Depth"])
    
    # Apply log10 transformation to depth, adding a small value to avoid log(0)
    data["LogDepth"] = np.log10(data["Depth"] + 1)  # Add 1 to avoid log(0)
    
    # Create a boolean column to identify zero depth positions
    zero_depth_positions = data["Depth"] == 0

    # Generate the plot
    plt.figure(figsize=(12, 8))

    # Plot the coverage with a log scale on the y-axis (no fill)
    plt.plot(data["Position"], data["LogDepth"], color="purple", label="Log10(Coverage Depth)")
    
    # Highlight positions with zero depth
    plt.scatter(data[zero_depth_positions]["Position"], data[zero_depth_positions]["LogDepth"], 
                color="red", s=10, label="Zero Depth")

    # Add a horizontal line at y=50
    plt.axhline(y=np.log10(50), color="blue", linestyle="--", label="y = 50")
    
    # Set x and y labels
    plt.xlabel("Genome Position")
    plt.ylabel("Coverage (log10 scale)")
    plt.title(f"{os.path.basename(input_file)}")

    # Adjust the y-axis scaling with two ranges: (0-1) and (>1)
    plt.yscale("log")
    plt.ylim(0.1, data["LogDepth"].max() + 1)  # Set lower limit slightly above 0

    # Display the grid
    plt.grid(True, which="both", linestyle="--", lw=0.5)

    # Show the legend
    plt.legend()

    # Save the plot
    plt.savefig(output_plot)
    plt.close()

if __name__ == "__main__":
    # Check if the correct number of arguments is passed
    if len(sys.argv) != 3:
        print("Usage: python depth_plot.py <input_tsv> <output_plot>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_plot = sys.argv[2]
    
    # Check if the input file exists
    if not os.path.isfile(input_file):
        print(f"Error: {input_file} does not exist.")
        sys.exit(1)
    
    # Plot the depth coverage for the individual file
    plot_depth_coverage(input_file, output_plot)


import json
from pathlib import Path

# Load the JSON file
with open("config.json", "r") as f:
    config = json.load(f)

# Extract the base_path
base_path = config["base_path"]

# Expand ${base_path} in all relevant paths
for key, value in config.items():
    if isinstance(value, str) and "${base_path}" in value:
        config[key] = value.replace("${base_path}", base_path)

# Save the modified JSON back to the file
with open("config.json", "w") as f:
    json.dump(config, f, indent=4)

print("Paths updated successfully in config.json!")


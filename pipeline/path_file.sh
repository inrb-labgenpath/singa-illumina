pwd > base_path
base_path=$(head -n 1 base_path)
jq --arg base_path "$base_path" '.base_path = $base_path' singa-illumina/pipeline/config.json > singa-illumina/pipeline/config_temp.json && mv singa-illumina/pipeline/config_temp.json singa-illumina/pipeline/config.json


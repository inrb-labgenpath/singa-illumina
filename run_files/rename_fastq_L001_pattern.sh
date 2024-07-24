

# Parcourir tous les fichiers FASTQ.gz correspondant au motif donné
for file in *_S*_L001_R1_001.fastq.gz; do
    # Extraire le préfixe avant le premier underscore et suffixe S
    prefix=$(echo "$file" | cut -d'_' -f1)
    suffix=$(echo "$file" | cut -d'_' -f2)
    
    # Définir les noms de fichiers d'origine et les nouveaux noms de fichiers
    original_r1="${prefix}_${suffix}_L001_R1_001.fastq.gz"
    original_r2="${prefix}_${suffix}_L001_R2_001.fastq.gz"
    new_r1="${prefix}_R1.fastq"
    new_r2="${prefix}_R2.fastq"
    
    # Décompresser les fichiers R1 et R2
    if [ -e "$original_r1" ]; then
        gunzip "$original_r1"
        echo "Décompressé: $original_r1"
    else
        echo "Le fichier $original_r1 n'existe pas."
        continue
    fi
    
    if [ -e "$original_r2" ]; then
        gunzip "$original_r2"
        echo "Décompressé: $original_r2"
    else
        echo "Le fichier $original_r2 n'existe pas."
        continue
    fi
    
    # Renommer les fichiers décompressés
    mv "${original_r1%.gz}" "$new_r1"
    echo "Renommé: ${original_r1%.gz} -> $new_r1"
    
    mv "${original_r2%.gz}" "$new_r2"
    echo "Renommé: ${original_r2%.gz} -> $new_r2"
    
    # Recompresser les fichiers renommés
    gzip "$new_r1"
    echo "Compressé: $new_r1.gz"
    
    gzip "$new_r2"
    echo "Compressé: $new_r2.gz"
done

echo "Tous les fichiers ont été traités."
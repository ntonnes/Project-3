#!/bin/bash

# Get the maximum number of products per model from the script argument
max_products_per_model=$1
echo "Creating 0-$max_products_per_model products for each model..."

# Initialize output variable with headers
output="ModelID,SerialNo,Return,SupplierName,RestockNo\n"

# Get all model IDs
mapfile -t modelIDs < <(tail -n +2 Model.csv | cut -d, -f1)

# Get total number of models
total_models=${#modelIDs[@]}

# Initialize counter for processed models
processed_models=0

# Get all restock rows
mapfile -t restockRows < <(tail -n +2 Restock.csv)

# Initialize counter for total products
total_products=0

# Generate all random numbers at once
mapfile -t randomNumbers < <(for ((i=0; i<$total_models; i++)); do echo $((RANDOM % max_products_per_model)); done)

# For each model ID
for ((index=0; index<${#modelIDs[@]}; index++))
do
    modelID=${modelIDs[$index]}
    nextSerialNo=100000000
    num_products=${randomNumbers[$index]}

    # For each product to create
    for ((i=1; i<=$num_products; i++))
    do
        # Break the loop if total products reached 499
        if ((total_products == 499)); then
            break 2
        fi

        # Get a random restock row
        restockRow=${restockRows[$RANDOM % ${#restockRows[@]}]}

        # Get the supplier name and restock number from the restock row
        supplierName=$(echo $restockRow | cut -d, -f1)
        restockNo=$(echo $restockRow | cut -d, -f2)

        nextSerialNo=$((nextSerialNo + 1))

        # Add the row to output variable
        output+="$modelID,$nextSerialNo,FALSE,$supplierName,$restockNo\n"

        # Increment counter for total products
        total_products=$((total_products + 1))
    done

    # Increment counter for processed models
    processed_models=$((processed_models + 1))

    # Calculate percentage of progress as a floating-point number and convert it to an integer
    percent=$(awk "BEGIN {printf \"%.0f\", 100 * $processed_models / $total_models}")

    # Print percentage of progress
    printf "\rProgress: %d%%" $percent
done

# Write the output to Product.csv
echo -e $output > Product.csv

# Remove trailing newlines from Product.csv
sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' Product.csv

echo -e "\nGenerated 'Product.csv' with $(( $(wc -l < Product.csv) - 1 )) rows.\n"
#!/bin/bash
# Script to create Parquet files from CSV using DuckDB CLI

set -e  # Exit on error

echo "Creating Parquet files from CSV data..."
echo ""

# Check if DuckDB is installed
if ! command -v duckdb &> /dev/null; then
    echo "❌ Error: DuckDB is not installed."
    echo ""
    echo "Please install DuckDB first:"
    echo "  macOS:    brew install duckdb"
    echo "  Linux:    wget https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip"
    echo "  Windows:  See https://duckdb.org/docs/installation/"
    echo ""
    exit 1
fi

# Verify CSV files exist
for file in customers.csv inventory.csv; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file '$file' not found."
        echo "Please run this script from the tutorial directory."
        exit 1
    fi
done

# Create customers.parquet
echo "Creating customers.parquet..."
if duckdb -c "COPY (SELECT * FROM 'customers.csv') TO 'customers.parquet' (FORMAT PARQUET);"; then
    echo "✅ customers.parquet created"
else
    echo "❌ Failed to create customers.parquet"
    exit 1
fi

# Create inventory.parquet
echo "Creating inventory.parquet..."
if duckdb -c "COPY (SELECT * FROM 'inventory.csv') TO 'inventory.parquet' (FORMAT PARQUET);"; then
    echo "✅ inventory.parquet created"
else
    echo "❌ Failed to create inventory.parquet"
    exit 1
fi

echo ""
echo "✅ All Parquet files created successfully!"
echo ""
echo "Files created:"
ls -lh customers.parquet inventory.parquet
echo ""
echo "You can now query these files with DuckDB:"
echo "  duckdb -c \"SELECT * FROM 'customers.parquet'\""
echo "  duckdb -c \"SELECT * FROM 'inventory.parquet'\""

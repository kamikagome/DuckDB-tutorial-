#!/bin/bash
# Script to create Parquet files from CSV using DuckDB CLI

echo "Creating Parquet files from CSV data..."
echo ""

# Create customers.parquet
echo "Creating customers.parquet..."
duckdb -c "COPY (SELECT * FROM 'customers.csv') TO 'customers.parquet' (FORMAT PARQUET);"

# Create inventory.parquet
echo "Creating inventory.parquet..."
duckdb -c "COPY (SELECT * FROM 'inventory.csv') TO 'inventory.parquet' (FORMAT PARQUET);"

echo ""
echo "✅ Parquet files created successfully!"
echo ""
echo "Files created:"
ls -lh customers.parquet inventory.parquet 2>/dev/null || echo "Note: Run this script from the tutorial directory"
echo ""
echo "You can now query these files with DuckDB:"
echo "  duckdb -c \"SELECT * FROM 'customers.parquet'\""

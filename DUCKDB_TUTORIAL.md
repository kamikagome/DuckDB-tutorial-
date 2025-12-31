# DuckDB Tutorial: Analyzing CSV and Parquet Files

This tutorial demonstrates how to use DuckDB to analyze CSV and Parquet files efficiently.

## Table of Contents
1. [Installation](#installation)
2. [Sample Data Files](#sample-data-files)
3. [Getting Started](#getting-started)
4. [Querying CSV Files](#querying-csv-files)
5. [Querying Parquet Files](#querying-parquet-files)
6. [Advanced Queries](#advanced-queries)
7. [Joining Data](#joining-data)
8. [Exporting Results](#exporting-results)

## Installation

### Install DuckDB CLI
```bash
# macOS
brew install duckdb

# Or download from https://duckdb.org/
# For Python users:
pip install duckdb
```

## Sample Data Files

This directory contains sample data files:

**CSV Files:**
- `sales_data.csv` - Sales transactions with date, product, quantity, price, and region
- `employees.csv` - Employee information including department and salary

**Parquet Files:**
- `customers.parquet` - Customer data with purchase history
- `inventory.parquet` - Product inventory information

To create the Parquet files, run:
```bash
pip install pandas pyarrow
python3 create_parquet_files.py
```

## Getting Started

### Launch DuckDB CLI
```bash
duckdb
```

### Or use DuckDB in-memory mode (no persistent database)
```bash
duckdb :memory:
```

## Querying CSV Files

### 1. Read CSV file directly (no import needed!)
```sql
SELECT * FROM 'sales_data.csv' LIMIT 5;
```

### 2. View all sales data
```sql
SELECT * FROM 'sales_data.csv';
```

### 3. Filter by region
```sql
SELECT date, product, quantity, price
FROM 'sales_data.csv'
WHERE region = 'North';
```

### 4. Calculate total revenue per product
```sql
SELECT
    product,
    SUM(quantity) as total_quantity,
    SUM(quantity * price) as total_revenue
FROM 'sales_data.csv'
GROUP BY product
ORDER BY total_revenue DESC;
```

### 5. Analyze sales by region
```sql
SELECT
    region,
    COUNT(*) as num_transactions,
    SUM(quantity * price) as total_sales,
    AVG(quantity * price) as avg_transaction_value
FROM 'sales_data.csv'
GROUP BY region
ORDER BY total_sales DESC;
```

### 6. Query employee data
```sql
SELECT * FROM 'employees.csv';
```

### 7. Find average salary by department
```sql
SELECT
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM 'employees.csv'
GROUP BY department
ORDER BY avg_salary DESC;
```

### 8. Find employees hired in 2020 or later
```sql
SELECT name, department, salary, hire_date
FROM 'employees.csv'
WHERE hire_date >= '2020-01-01'
ORDER BY hire_date;
```

## Querying Parquet Files

Parquet files work exactly like CSV - just reference them directly!

### 1. Read Parquet file
```sql
SELECT * FROM 'customers.parquet';
```

### 2. Analyze customer data by country
```sql
SELECT
    country,
    COUNT(*) as customer_count,
    SUM(total_purchases) as total_purchases,
    SUM(lifetime_value) as total_value
FROM 'customers.parquet'
GROUP BY country
ORDER BY total_value DESC;
```

### 3. Top customers by lifetime value
```sql
SELECT
    customer_name,
    country,
    total_purchases,
    lifetime_value
FROM 'customers.parquet'
ORDER BY lifetime_value DESC
LIMIT 5;
```

### 4. Query inventory data
```sql
SELECT * FROM 'inventory.parquet';
```

### 5. Check stock levels by warehouse
```sql
SELECT
    warehouse,
    COUNT(*) as product_count,
    SUM(stock_quantity) as total_stock
FROM 'inventory.parquet'
GROUP BY warehouse;
```

## Advanced Queries

### 1. Using CTEs (Common Table Expressions)
```sql
WITH product_stats AS (
    SELECT
        product,
        SUM(quantity) as total_sold,
        SUM(quantity * price) as revenue
    FROM 'sales_data.csv'
    GROUP BY product
)
SELECT
    product,
    total_sold,
    revenue,
    ROUND(revenue / total_sold, 2) as avg_price_per_unit
FROM product_stats
ORDER BY revenue DESC;
```

### 2. Window functions - Running total of sales
```sql
SELECT
    date,
    product,
    quantity * price as daily_revenue,
    SUM(quantity * price) OVER (ORDER BY date) as running_total
FROM 'sales_data.csv'
ORDER BY date;
```

### 3. Rank regions by sales
```sql
SELECT
    region,
    SUM(quantity * price) as total_sales,
    RANK() OVER (ORDER BY SUM(quantity * price) DESC) as sales_rank
FROM 'sales_data.csv'
GROUP BY region;
```

## Joining Data

### Join sales with inventory (by product name)
```sql
SELECT
    s.product,
    SUM(s.quantity) as total_sold,
    i.stock_quantity,
    i.warehouse
FROM 'sales_data.csv' s
LEFT JOIN 'inventory.parquet' i ON s.product = i.product_name
GROUP BY s.product, i.stock_quantity, i.warehouse;
```

## Exporting Results

### 1. Export query results to CSV
```sql
COPY (
    SELECT
        product,
        SUM(quantity) as total_quantity,
        SUM(quantity * price) as total_revenue
    FROM 'sales_data.csv'
    GROUP BY product
) TO 'sales_summary.csv' (HEADER, DELIMITER ',');
```

### 2. Export to Parquet
```sql
COPY (
    SELECT * FROM 'employees.csv'
    WHERE department = 'Engineering'
) TO 'engineering_employees.parquet' (FORMAT PARQUET);
```

### 3. Export to JSON
```sql
COPY (
    SELECT * FROM 'customers.parquet'
    WHERE country = 'USA'
) TO 'usa_customers.json';
```

## Using DuckDB with Python

```python
import duckdb

# Connect to DuckDB (in-memory)
con = duckdb.connect(':memory:')

# Query CSV file
result = con.execute("""
    SELECT product, SUM(quantity * price) as revenue
    FROM 'sales_data.csv'
    GROUP BY product
    ORDER BY revenue DESC
""").fetchall()

print(result)

# Convert to pandas DataFrame
df = con.execute("SELECT * FROM 'sales_data.csv'").df()
print(df.head())

# Query Parquet file
customers = con.execute("SELECT * FROM 'customers.parquet'").df()
print(customers)

con.close()
```

## Performance Tips

1. **Use Parquet for large datasets** - Parquet is columnar and compressed, much faster than CSV
2. **Filter early** - Use WHERE clauses to reduce data processing
3. **Select only needed columns** - Don't use `SELECT *` in production queries
4. **Use appropriate data types** - DuckDB infers types but you can specify them
5. **Leverage DuckDB's parallel processing** - It automatically uses multiple cores

## Common DuckDB Commands

```sql
-- Show tables in current session
SHOW TABLES;

-- Describe file structure
DESCRIBE SELECT * FROM 'sales_data.csv';

-- Get file metadata
SELECT * FROM parquet_metadata('customers.parquet');

-- Show DuckDB version
SELECT version();

-- Enable/disable progress bar
.mode line
```

## Key Advantages of DuckDB

- **No ETL needed** - Query files directly without loading
- **Fast** - Optimized for analytical queries
- **Embedded** - No server setup required
- **SQL-compliant** - Use standard SQL syntax
- **Multiple formats** - CSV, Parquet, JSON, Excel, and more
- **Python integration** - Seamless pandas/arrow integration

## Next Steps

- Explore DuckDB's [official documentation](https://duckdb.org/docs/)
- Try querying larger datasets
- Experiment with more complex joins and aggregations
- Use DuckDB with your own CSV/Parquet files
- Integrate DuckDB into your Python data pipelines

Happy querying!

<div align="center">

# 🦆 DuckDB CLI Data Analysis Tutorial

### Master SQL Analytics on CSV and Parquet Files Using DuckDB Command Line

[![DuckDB](https://img.shields.io/badge/DuckDB-0.9+-yellow.svg)](https://duckdb.org/)
[![SQL](https://img.shields.io/badge/SQL-Standard-blue.svg)](https://www.iso.org/standard/63555.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Overview](#overview) • [Features](#features) • [Quick Start](#quick-start) • [Tutorial](#tutorial) • [Examples](#examples)

</div>

---

## 📋 Overview

This project is a **hands-on tutorial** demonstrating how to use the [DuckDB CLI](https://duckdb.org/) for efficient data analysis on CSV and Parquet files. DuckDB is an in-process SQL OLAP database management system designed for analytical workloads, offering fast performance without the need for a server setup.

Perfect for data analysts, SQL enthusiasts, and developers looking to:
- 🚀 Query large datasets without ETL pipelines
- 📊 Perform SQL analytics directly on flat files (CSV, Parquet, JSON)
- ⚡ Leverage columnar storage for faster queries
- 💻 Use pure SQL from the command line - no programming required

## ✨ Features

- **📁 Sample Datasets**: Pre-configured CSV and Parquet files with realistic data
- **📖 Comprehensive Tutorial**: Step-by-step guide covering basic to advanced SQL queries
- **💻 Pure CLI Approach**: All examples use DuckDB command line - no programming needed
- **🔗 Real-world Examples**: Aggregations, joins, window functions, and CTEs
- **🛠️ Ready-to-run**: Just install DuckDB and start querying immediately
- **📤 Export Examples**: Learn to export results to CSV, Parquet, and JSON formats

## 🗂️ Project Structure

```
duckdb-tutorial/
├── README.md                      # This file
├── DUCKDB_TUTORIAL.md            # Complete tutorial with SQL examples
├── setup_parquet.sh              # Script to create Parquet files
├── sales_data.csv                # Sample sales transactions dataset
├── employees.csv                 # Sample employee information dataset
├── customers.csv                 # Customer source data
├── inventory.csv                 # Inventory source data
├── customers.parquet             # Generated Parquet file (after setup)
└── inventory.parquet             # Generated Parquet file (after setup)
```

## 📦 Sample Datasets

| File | Format | Description | Records |
|------|--------|-------------|---------|
| `sales_data.csv` | CSV | Sales transactions with product, quantity, price, region | 10 |
| `employees.csv` | CSV | Employee records with department, salary, hire date | 8 |
| `customers.csv` | CSV | Customer data with lifetime value and purchases | 8 |
| `inventory.csv` | CSV | Product inventory by warehouse | 5 |
| `customers.parquet` | Parquet | Customer data (generated from CSV) | 8 |
| `inventory.parquet` | Parquet | Product inventory (generated from CSV) | 5 |

## 🚀 Quick Start

### Prerequisites

- DuckDB CLI - That's it! No programming languages, no dependencies.

### Step-by-Step Setup

#### 1️⃣ Clone or Download the Repository

```bash
git clone https://github.com/yourusername/duckdb-tutorial.git
cd duckdb-tutorial
```

Or simply download the files to a directory on your computer.

#### 2️⃣ Install DuckDB CLI

**macOS:**
```bash
brew install duckdb
```

#### 3️⃣ Verify Installation

```bash
duckdb --version
```

#### 4️⃣ Generate Parquet Files (Optional)

The tutorial includes CSV versions of all data. To create Parquet files and see the performance difference:

```bash
./setup_parquet.sh
```

This uses DuckDB to convert CSV files to Parquet format.

#### 5️⃣ Start Analyzing!

Launch DuckDB CLI:
```bash
duckdb
```

Now run some queries:

```sql
-- Query CSV directly (no import needed!)
SELECT * FROM 'sales_data.csv';

-- Analyze sales by region
SELECT region, SUM(quantity * price) as total_sales
FROM 'sales_data.csv'
GROUP BY region
ORDER BY total_sales DESC;

-- Query Parquet file
SELECT * FROM 'customers.parquet' WHERE country = 'USA';

-- Exit DuckDB
.quit
```

**Or run a single query from the command line:**
```bash
duckdb -c "SELECT * FROM 'sales_data.csv' LIMIT 5"
```

## 📚 Tutorial

For a comprehensive guide with detailed examples, see **[DUCKDB_TUTORIAL.md](DUCKDB_TUTORIAL.md)**.

The tutorial covers:

1. **Installation** - Setting up DuckDB CLI
2. **Basic Queries** - Reading and filtering CSV/Parquet files
3. **Aggregations** - GROUP BY, SUM, AVG, COUNT operations
4. **Joins** - Combining data from multiple files
5. **Advanced SQL** - CTEs, window functions, subqueries
6. **Exporting Results** - Save results to CSV, Parquet, JSON
7. **Command-line Usage** - Running queries from shell scripts
8. **Performance Tips** - Optimizing queries for large datasets

## 💡 Examples

### Example 1: Sales Analysis by Region

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

### Example 2: Employee Salary Analysis

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

### Example 3: Join Sales and Inventory Data

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

### Example 4: Customer Analysis from Command Line

```bash
# Run a query directly from the terminal
duckdb -c "
SELECT
    customer_name,
    country,
    total_purchases,
    lifetime_value,
    ROUND(lifetime_value / total_purchases, 2) as avg_purchase_value
FROM 'customers.parquet'
ORDER BY lifetime_value DESC
LIMIT 5
"
```

### Example 5: Create a Report Script

Create a file called `sales_report.sh`:
```bash
#!/bin/bash
# Daily sales report

echo "=== Sales Report ==="
echo ""

duckdb -c "
SELECT
    product,
    SUM(quantity) as units_sold,
    ROUND(SUM(quantity * price), 2) as total_revenue
FROM 'sales_data.csv'
GROUP BY product
ORDER BY total_revenue DESC
"

echo ""
echo "Report generated at $(date)"
```

Make it executable and run:
```bash
chmod +x sales_report.sh
./sales_report.sh
```

## 🎯 Learning Path

Follow this path to master DuckDB CLI:

1. ✅ **Install DuckDB** - Complete the Quick Start steps above
2. ✅ **Read Tutorial** - Go through [DUCKDB_TUTORIAL.md](DUCKDB_TUTORIAL.md)
3. ✅ **Try Basic Queries** - Practice SELECT, WHERE, GROUP BY on CSV files
4. ✅ **Explore Parquet** - Compare performance between CSV and Parquet
5. ✅ **Advanced SQL** - Experiment with joins, CTEs, and window functions
6. ✅ **Automation** - Build shell scripts for automated reporting
7. ✅ **Use Your Data** - Apply DuckDB to your own CSV/Parquet files

## 🔧 Key DuckDB Advantages

| Feature | Benefit |
|---------|---------|
| **Zero ETL** | Query files directly without loading into a database |
| **Blazing Fast** | Vectorized query execution and columnar storage |
| **Embedded** | No server setup - runs in-process |
| **SQL Standard** | Use familiar SQL syntax |
| **Multi-format** | CSV, Parquet, JSON, Excel, and more |
| **CLI-Friendly** | Perfect for shell scripts and automation |
| **Portable** | Single binary, works anywhere |

## 📖 Additional Resources

- [DuckDB Official Documentation](https://duckdb.org/docs/)
- [DuckDB Python API Guide](https://duckdb.org/docs/api/python/overview)
- [Parquet Format Overview](https://parquet.apache.org/)
- [SQL Tutorial](https://www.w3schools.com/sql/)

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs or issues
- Suggest new examples or tutorials
- Improve documentation
- Add new sample datasets

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [DuckDB Team](https://duckdb.org/) for creating an amazing database system
- Community contributors for feedback and improvements

---

## 🧪 About This Project

This tutorial was created as an experimental project using [Claude Code](https://claude.ai/claude-code), an AI-powered coding assistant. The project demonstrates how DuckDB can simplify data analysis workflows using only SQL and the command line.

---

<div align="center">

**⭐ If you found this tutorial helpful, please consider giving it a star!**

Made with ❤️ for the data nerds

</div>

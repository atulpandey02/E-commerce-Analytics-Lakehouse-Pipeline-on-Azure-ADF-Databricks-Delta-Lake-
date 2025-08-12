# E-Commerce Analytics Lakehouse Pipeline on Azure

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=for-the-badge&logo=apache-spark&logoColor=white)
![Delta Lake](https://img.shields.io/badge/Delta%20Lake-003366?style=for-the-badge&logo=delta&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Architecture Diagram](images/architecture.png)

## Overview
This project implements a **data lakehouse pipeline** for **E-commerce analytics** using Azure services and the **Medallion Architecture** (Bronze → Silver → Gold). The pipeline ingests raw datasets, incrementally refines them into analytics-ready data, and visualizes insights using dashboards.

### Key Azure Components:
- **Azure Data Factory (ADF)** – Orchestrates ingestion from external sources (e.g., `data.world`) into Azure Data Lake.
- **Azure Data Lake Storage Gen2 (ADLS)** – Stores raw and processed data in Landing Zones.
- **Azure Databricks (Apache Spark)** – Handles scalable transformations across Medallion layers.
- **Delta Lake** – Stores Bronze, Silver, and Gold layer data with ACID transactions and Time Travel.
- **Databricks SQL** – Runs queries and builds interactive dashboards.

---

## Architecture & Workflow
The pipeline uses **two ADLS containers**:
- **Landing Zone 1 (LZ1)** – Stores **raw data**.
- **Landing Zone 2 (LZ2)** – Stores **to_process_data**, **processed_data**, and **Delta tables**.

### Workflow:
1. **Ingestion (Bronze Layer)**
   - ADF ingests raw datasets: `users`, `buyers`, `sellers`, `countries`.
   - Event-based trigger for `users` dataset (real-time updates).
   - Weekly schedule trigger for reference datasets (`buyers`, `sellers`, `countries`).
   - Files are moved to **LZ2/to_process_data** after ingestion.

2. **Transformation (Silver & Gold Layers)**
   - Databricks processes `to_process_data` files through Bronze → Silver → Gold stages.
   - **Bronze:** Raw format ingestion.
   - **Silver:** Data cleaning, validation, deduplication, and integration.
   - **Gold:** Aggregated, business-friendly tables ready for analytics.

3. **Storage (Delta Lake)**
   - Data stored in Delta format for ACID transactions and versioning.
   - Optimized for fast reads in analytics.

4. **Consumption & Analytics**
   - Databricks SQL queries on Gold tables.
   - Dashboard with filters, KPIs, and charts.

---

## Automation & Orchestration
- **ADF Pipelines & Triggers**
  - Event trigger for `user_data`.
  - Scheduled trigger for `buyers`, `sellers`, `countries`.
- **Databricks Jobs**
  - Runs transformation notebooks automatically.
- **Error Handling & Monitoring**
  - ADF alerts for failed runs.
  - Delta ACID transactions prevent partial writes.

---

## Example SQL Queries
```sql
-- Top 5 Countries by Number of Buyers
SELECT Country, COUNT(DISTINCT BuyerID) AS TotalBuyers
FROM gold.ecom_one_big_table
GROUP BY Country
ORDER BY TotalBuyers DESC
LIMIT 5;

-- Buyers vs. Sellers by Country
SELECT Country,
       SUM(CASE WHEN UserType = 'Buyer' THEN 1 ELSE 0 END) AS Buyers_Count,
       SUM(CASE WHEN UserType = 'Seller' THEN 1 ELSE 0 END) AS Sellers_Count
FROM gold.ecom_one_big_table
GROUP BY Country;
```

---

## Repository Structure
```
├── notebooks/                # Databricks notebooks for ETL
├── pipelines/                # ADF pipeline JSON exports
├── sql/                      # SQL query files
├── images/                   # Architecture diagrams & screenshots
├── docs/                     # Additional documentation
└── README.md                 # Project documentation
```

---

## Deployment Guide
### Prerequisites
- Azure Subscription
- ADLS Gen2 Storage account (with hierarchical namespace enabled)
- Azure Data Factory instance
- Azure Databricks workspace
- Databricks cluster with ADLS access

### Steps
1. **Provision Resources** in Azure (Storage, ADF, Databricks).
2. **Create Containers** in ADLS: `landing-zone-1` and `landing-zone-2`.
3. **Set Up ADF Pipelines** with triggers for user and reference data ingestion.
4. **Import Databricks Notebooks** for Bronze → Silver → Gold transformations.
5. **Configure Databricks Job** to automate transformations.
6. **Register Gold Tables** in Databricks SQL and build dashboard.

---

## Conclusion
This project delivers an **end-to-end, automated, and scalable data engineering solution** for e-commerce analytics, leveraging Azure's modern data stack. It ensures **data quality, reliability, and real-time insights**, making it extensible for future analytics and machine learning use cases.

# 📄 Project Documentation – E-Commerce Analytics Lakehouse Pipeline

This `docs` directory contains detailed documentation for the **E-Commerce Analytics Lakehouse Pipeline** project, including architecture details, setup instructions, workflow explanations, and references for future development.

---

## 📂 Documentation Structure

| File / Folder | Description |
|---------------|-------------|
| **architecture.md** | Detailed explanation of the system architecture with diagrams. |
| **workflow.md** | Step-by-step breakdown of the pipeline workflow from ingestion to analytics. |
| **setup_guide.md** | Instructions for setting up the project locally and on Azure. |
| **adf_pipeline_exports/** | JSON exports of Azure Data Factory pipelines. |
| **databricks_notebooks/** | Additional Databricks notebooks used in transformations or analytics. |
| **queries/** | Example SQL queries used for dashboards and analytics. |

---

## 🔹 Overview

The **E-Commerce Analytics Lakehouse Pipeline** processes and analyzes e-commerce datasets using:
- **Azure Data Factory (ADF)** for ingestion & orchestration.
- **ADLS Gen2** for data storage.
- **Databricks (Apache Spark)** for transformation using the **Medallion Architecture**.
- **Delta Lake** for optimized analytics storage.
- **Databricks SQL Dashboards** for visualization.

---

## 🔹 Architecture Summary

- **Bronze Layer** → Raw data ingestion.
- **Silver Layer** → Data cleaning, validation, and integration.
- **Gold Layer** → Aggregated, business-ready datasets.

Refer to [`architecture.md`](architecture.md) for a full diagram and explanation.

---

## 🔹 Workflow Summary

1. **Ingestion** – Data Factory ingests raw CSV/JSON files from `data.world`.
2. **Processing** – Databricks processes raw files through Bronze → Silver → Gold.
3. **Storage** – Delta tables stored in ADLS Gen2.
4. **Analytics** – Dashboards built in Databricks SQL.

---

## 📌 Additional Resources

- **[Azure Data Factory Documentation](https://learn.microsoft.com/azure/data-factory/)**
- **[Azure Databricks Documentation](https://learn.microsoft.com/azure/databricks/)**
- **[Delta Lake Documentation](https://delta.io/documentation/)**

---

## 🛠 Future Enhancements
- Implement CI/CD for pipeline deployment.
- Add real-time streaming ingestion using Azure Event Hubs.
- Deploy dashboards via Power BI for wider accessibility.

---

# 🏗 Architecture – E-Commerce Analytics Lakehouse Pipeline

## 🔹 Overview
The architecture follows the **Medallion Architecture** pattern:  
**Bronze → Silver → Gold** layers for structured data processing and analytics.

---

## 🔹 Components

1. **Azure Data Factory (ADF)** – Orchestrates ingestion from `data.world` into Azure Data Lake Storage Gen2.
2. **ADLS Gen2** – Stores all raw, intermediate, and curated datasets.
3. **Databricks (Apache Spark)** – Processes data across Bronze, Silver, and Gold stages.
4. **Delta Lake** – Stores Gold layer tables with ACID compliance and time travel.
5. **Databricks SQL Dashboards** – Provides business analytics and KPIs.

---

## 🔹 Data Flow

```plaintext
Data Source (data.world) 
       ↓
Azure Data Factory (ADF) → ADLS Gen2 (Bronze Layer: Raw Data)
       ↓
Databricks (Bronze → Silver → Gold)
       ↓
Delta Lake (Gold Tables)
       ↓
Databricks SQL Dashboard


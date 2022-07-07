# %%
# Set the Datalake Access Key configuration
spark.conf.set(
    "fs.azure.account.key.cryptoanalyticslake.dfs.core.windows.net",
    dbutils.secrets.get(scope="key-vault-secret-scope",key="cryptoanalyticslake-access-key"))

# %%
spark.sql("CREATE SCHEMA IF NOT EXISTS bronze")

# %%
sql_table_create = "CREATE TABLE IF NOT EXISTS bronze.quotes \
                      (Symbol STRING NOT NULL, Price DECIMAL(38,15) NOT NULL, PriceTimeStamp TIMESTAMP NOT NULL, PriceDate DATE NOT NULL) \
                    USING DELTA \
                    PARTITIONED BY (PriceDate) \
                    LOCATION 'abfss://crypto-bronze@cryptoanalyticslake.dfs.core.windows.net/quotes-delta-table'"

spark.sql(sql_table_create)

# %%
# Set Day Month Year
from datetime import datetime

today = datetime.utcnow()
year = today.year
month = today.month
day = today.day

# %%
sql_copy = f"COPY INTO bronze.quotes \
             FROM (SELECT Symbol, Price, PriceTimeStamp, PriceDate \
                FROM 'abfss://crypto-bronze@cryptoanalyticslake.dfs.core.windows.net/quotes-by-day-manual-partition/{year}/{month:0>2d}/{day:0>2d}') \
             FILEFORMAT = PARQUET"

spark.sql(sql_copy)



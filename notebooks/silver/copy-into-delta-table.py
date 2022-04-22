# %%
# Set the Datalake Access Key configuration
spark.conf.set(
    "fs.azure.account.key.cryptoanalyticslake.dfs.core.windows.net",
    dbutils.secrets.get(scope="key-vault-secret-scope",key="cryptoanalyticslake-access-key"))

# %%
spark.sql("CREATE SCHEMA IF NOT EXISTS silver")

# %%
sql_table_create = "CREATE TABLE IF NOT EXISTS silver.quotes \
                      (Symbol STRING NOT NULL, Price DECIMAL(38,15) NOT NULL, PriceTimeStamp TIMESTAMP NOT NULL, PriceDate DATE NOT NULL) \
                    USING DELTA \
                    PARTITIONED BY (PriceDate) \
                    LOCATION 'abfss://crypto-silver@cryptoanalyticslake.dfs.core.windows.net/delta-table/quotes'"

spark.sql(sql_table_create)

# %%
# Set Day Month Year
from datetime import datetime

today = datetime.utcnow()
year = today.year
month = today.month
day = today.day

# %%
sql_copy = f"COPY INTO silver.quotes \
             FROM (SELECT Symbol, Price, PriceTimeStamp, PriceDate \
                FROM 'abfss://crypto-silver@cryptoanalyticslake.dfs.core.windows.net/quotes-by-day/manual-partition/{year}/{month:0>2d}/{day:0>2d}') \
             FILEFORMAT = DELTA"

spark.sql(sql_copy)



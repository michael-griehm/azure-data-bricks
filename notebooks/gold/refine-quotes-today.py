# %%
# Set the Datalake Access Key configuration
spark.conf.set(
    "fs.azure.account.key.cryptoanalyticslake.dfs.core.windows.net",
    dbutils.secrets.get(scope="key-vault-secret-scope",key="cryptoanalyticslake-access-key"))

# %%
# Set Day Month Year
from datetime import datetime

today = datetime.utcnow()
year = today.year
month = today.month
day = today.day

# %%
# Recursive data load for all files from a day from every partition in the Event Hub Namespace
from pyspark.sql.functions import to_date
sourcefolderpath = f"abfss://crypto-silver@cryptoanalyticslake.dfs.core.windows.net/quotes-by-day/{year}/{month:0>2d}/{day:0>2d}"

print(sourcefolderpath)

df = spark.read.format("delta").option("recursiveFileLookup","true").load(sourcefolderpath)

df = df.withColumn("PriceDate", to_date("PriceTimeStamp"))

# %%
destinationfolderpath = f"abfss://crypto-gold@cryptoanalyticslake.dfs.core.windows.net/quotes-by-day"

print(destinationfolderpath)

df.write.partitionBy("PriceDate").format("csv").mode("append").save(destinationfolderpath)

# %%
singlecsvdestinationfolderpath = f"abfss://crypto-gold@cryptoanalyticslake.dfs.core.windows.net/quotes-by-day-single-csv/{year}/{month:0>2d}/{day:0>2d}/quotes.csv"

print(singlecsvdestinationfolderpath)

df.coalesce(1).write.format("csv").mode("overwrite").option("header", "true").save(singlecsvdestinationfolderpath)

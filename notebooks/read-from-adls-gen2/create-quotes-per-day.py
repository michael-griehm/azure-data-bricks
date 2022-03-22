# Set the Datalake Access Key configuration
spark.conf.set(
    "fs.azure.account.key.cryptoanalyticslake.dfs.core.windows.net",
    dbutils.secrets.get(scope="key-vault-secret-scope",key="cryptoanalyticslake-access-key"))

# Set Day Month Year
from datetime import date
from datetime import timedelta

today = date.today()
yesterday = today - timedelta(days = 1)
year = yesterday.year
month = yesterday.month
day = yesterday.day

# Recursive data load for all files from a day from every partition in the Event Hub Namespace
df = spark.read.option("recursiveFileLookup","true").option("header","true").format("avro").load(f"abfss://crypto-quotes@cryptoanalyticslake.dfs.core.windows.net/ehns-quote-streams/eh-crypto-stream/*/{year}/{month:0>2d}/{day:0>2d}")

# Change the Body field from Binary to JSON 
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StringType, DoubleType, StructType, StructField

sourceSchema = StructType([
        StructField("Symbol", StringType(), False),
        StructField("Price", DoubleType(), True),
        StructField("PriceTimeStamp", StringType(), True)])

df = df.withColumn("StringBody", col("Body").cast("string"))
jsonOptions = {"dateFormat" : "yyyy-MM-dd HH:mm:ss.SSS"}
df = df.withColumn("JsonBody", from_json(df.StringBody, sourceSchema, jsonOptions))

# Flattent he Body JSON field into columns of the DataFrame
for c in df.schema["JsonBody"].dataType:
    df = df.withColumn(c.name, col("JsonBody." + c.name))

# Remove Null data
df = df.filter("Price is not NULL")
df = df.filter("Price > 0")

# Sort the data
df = df.sort("Symbol", "PriceTimeStamp")

# Display the DataFrame
display(df)

# df.printSchema()


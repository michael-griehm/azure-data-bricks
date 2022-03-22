spark.conf.set(
    "fs.azure.account.key.cryptoanalyticslake.dfs.core.windows.net",
    dbutils.secrets.get(scope="key-vault-secret-scope",key="cryptoanalyticslake-access-key"))

from pyspark.sql.types import StringType, IntegerType, DecimalType, StructType, StructField
from pyspark.sql.functions import from_json, col

sourceSchema = StructType([
        StructField("Symbol", StringType(), False),
        StructField("Price", DecimalType(), True),
        StructField("PriceTimeStamp", StringType(), True)])

df = spark.read.format("avro").load("abfss://crypto-quotes@cryptoanalyticslake.dfs.core.windows.net/ehns-quote-streams/eh-crypto-stream/0/2022/03/11/18/45/03.avro")

df = df.withColumn("Body", col("Body").cast("string"))
jsonOptions = {"dateFormat" : "yyyy-MM-dd HH:mm:ss.SSS"}
df = df.withColumn("Body", from_json(df.Body, sourceSchema, jsonOptions))

for c in df.schema['Body'].dataType:
    df = df.withColumn(c.name, col("Body." + c.name))

display(df)

# df.printSchema()


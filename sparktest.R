# Local Spark setup (running on single-node machine, aka my 2015 Macbook Pro)
# Download latest stable version here: https://spark.apache.org/downloads.html
# Version: spark-2.2.0-bin-hadoop2.7.tgz

Sys.setenv(SPARK_HOME = "/Users/vboykis/Downloads/spark")
lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"))

#call SparkR library
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

#initiate Spark session
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))


data(income) #call local dataset
class(income) #examine object type
head(income) #examine local data
income[row.names(income)==2,]


sdf <- as.DataFrame(income) #convert to SparkDataFrame
sdf #check out type
head(sdf) #same function as on local data
sdf[row.names(income)==2,]
x<-collect(sdf)
head(x)


#### Random NA fill####

# Local data.frame
m <- matrix(sample(c(NA, 1:10), 100, replace = TRUE), 10)
d <- as.data.frame(m)
for(i in 1:ncol(d)){d[is.na(d[,i]), i] <- mean(d[,i], na.rm = TRUE)}
d

#SparkR
m <- matrix(sample(c(NA, 1:10), 100, replace = TRUE), 10)
d <- as.data.frame(m)
sdfD <- as.DataFrame(d)
head(sdfD)
for(i in 1:ncol(sdfD)){sdfD[is.na(sdfD[,i]), i] <- mean(d[,i], na.rm = TRUE)}

mean(sdfD$v10)
your_average<-as.list(head(select(sdfD,mean(sdfD$v10))))
sdfFinal<-fillna(sdfD,list("v10" = your_average[[1]]))
sdfFinal
head(sdfFinal)

### Cluster analysis ###

#Local
set.seed(20)
iris
irisCluster <- kmeans(iris[, 3:4], 3, nstart = 20)
irisCluster

#R
set.seed(20)
df <- createDataFrame(iris)
model <- spark.kmeans(df, ~ Petal_Length + Petal_Width, k = 3, initMode = "random")
summary(model)





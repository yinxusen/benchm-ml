#!/usr/bin/env Rscript

library(data.table)

head <- "/Users/panda/data/airline"
fin_train <- paste(head, "train-0.1m.csv", sep = "/")
fin_test <- paste(head, "test.csv", sep = "/")
fout_train <- paste(head, "spark-train-0.1m.csv", sep = "/")
fout_test <- paste(head, "spark-test.csv", sep = "/")

d1 <- fread(fin_train)
d2 <- fread(fin_test)
d <- rbind(d1,d2)

X <- model.matrix(dep_delayed_15min ~ ., d)
y <- ifelse(d[["dep_delayed_15min"]]=="Y",1,0)
dd <- cbind(y,X)
dd1 <- dd[1:nrow(d1),]
dd2 <- dd[(nrow(d1)+1):(nrow(d1)+nrow(d2)),]

write.table(dd1, fout_train, row.names=FALSE, col.names=FALSE, sep=",")
write.table(dd2, fout_test, row.names=FALSE, col.names=FALSE, sep=",")

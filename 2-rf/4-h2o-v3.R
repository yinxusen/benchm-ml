#!/usr/bin/env Rscript

library(h2o)

h2oServer <- h2o.init(max_mem_size="60g", nthreads=4)

dx_train <- h2o.importFile(path = "/Users/panda/data/airline/train-0.1m.csv")
dx_test <- h2o.importFile(path = "/Users/panda/data/airline/test.csv")

Xnames <- names(dx_train)[which(names(dx_train)!="dep_delayed_15min")]

# Params for RandomForest
params = list(ntrees = c(1, 5, 50, 100, 250, 500),
              max_depth = c(1, 5, 10, 20),
              mtries = c(-1, 1, 10),
              sample_rate = c(0.632, 0.8, 1.0),
              min_rows = c(1),
              nbins = c(20),
              nbins_cats = c(1024),
              stopping_metric = c("AUC")
              )

grid <- h2o.grid("randomForest", x = Xnames, y = "dep_delayed_15min", nfolds = 3,
                 keep_cross_validation_predictions = TRUE, score_each_iteration = TRUE,
                 build_tree_one_node = TRUE, training_frame = dx_train,
                 hyper_params = params)

summary(grid)

#system.time({
#  md <- h2o.randomForest(x = Xnames, y = "dep_delayed_15min", training_frame = dx_train, ntrees = 5)
#})
#
#system.time({
#  print(h2o.auc(h2o.performance(md, dx_test)))
#})




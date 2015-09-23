# 
# Loads datasets and transforms from original JSON-based format to a data frame
# representation of the following form:
# <id> <cuisine> <ingredient 1> <ingredient 2> .. <ingredient n>
#
# where every unique ingredient of the dataset is represented by one column with
# 1 for "present" and 0 for "absent".
#

library(rjson)

# Read data
train_file <- "train.json"
test_file <- "test.json"

train <- fromJSON(file=train_file)
test <- fromJSON(file=test_file)

## Split train data further into train and validation set
#set.seed(42)
#train_size <- length(train)
#train_idx <- sample(train_size, size=train_size*0.75)
#validation <- train[-train_idx]
#train <- train[train_idx]

# Find unique ingredients and cuisines
ingredients <- unlist(sapply(train, function(x) x$ingredients))
ingredients_unique <- unique(ingredients)
ingredients_count <- length(ingredients_unique)
cuisines <- unlist(sapply(train, function(x) x$cuisine))
cuisines_unique <- unique(cuisines)
cuisines_count <- length(cuisines_unique)

# Create data frame (intermediary step)
trainProcessed <- lapply(train, function(x){ indexes <- rep(0, ingredients_count)
                        indexes[which(ingredients_unique %in% x$ingredients)] <- 1
                        curRow <- c(x$id, x$cuisine, as.numeric(indexes))
                        curRow })
testProcessed <- lapply(test, function(x){ indexes <- rep(0, ingredients_count)
                        indexes[which(ingredients_unique %in% x$ingredients)] <- 1
                        curRow <- c(x$id, NA, as.numeric(indexes))
                        curRow })


# Create data frame
trainProcessedDF <- data.frame(t(data.frame(trainProcessed, stringsAsFactors = FALSE)))
testProcessedDF <- data.frame(t(data.frame(testProcessed, stringsAsFactors=FALSE)))
names(trainProcessedDF) <- c("Index", "Cuisine", words_unique)
rownames(trainProcessedDF) <- NULL
names(testProcessedDF) <- c("Index", "Cuisine", words_unique)
rownames(testProcessedDF) <- NULL


# Create mapping cuisine<->numeric factor representation for sk-learn
CuisineToNumeric <- character()
for(i in seq_along(cuisines_unique)) { CuisineToNumeric[cuisines_unique[i]] <- i}
NumericToCuisine <- character()
for(i in seq_along(cuisines_unique)) { NumericToCuisine[paste(i)] <- cuisines_unique[i]}
saveRDS(NumericToCuisine, "NumericToCuisine.rds")

# Revalue cuisine column based on mapping
trainProcessedDF$Cuisine <- revalue(trainProcessedDF$Cuisine, CuisineToNumeric)

# Write train and test data frame to CSV for processing by sk-learn
write.table(trainProcessedDF, "trainProcessedDF.csv", row.names=FALSE, quote=FALSE, sep="::")
write.table(testProcessedDF, "testProcessedDF.csv", row.names=FALSE, quote=FALSE, sep="::")
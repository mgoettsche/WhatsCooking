#
# Converts number-based model predictions back to string-based representation
#

NumericToCuisine <- readRDS("NumericToCuisine.rds")

submission <- read.csv("submission.csv")
submission$cuisine <- as.character(submission$cuisine)
submission$cuisine <- revalue(submission$cuisine, NumericToCuisine)
write.csv(submission, "submission.csv", quote=FALSE, row.names=FALSE) 
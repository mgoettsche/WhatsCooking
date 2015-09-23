#
# Exploratory throw-away code.
# 

# How often did an ingredient appear?
occurences <- sapply(trainProcessedDF, function(x) sum(x==1))
hist(occurences)
max(occurences)
which(occurences=18048)
which(occurences==18048)
sum(trainProcessedDF[14]==1)
hist(occurences, xlim=c(0, 150), breaks=c(1, 2, 3, 4, 5, 1:15*10, 20000))

# String distances
stringdistances_lv <- stringdistmatrix(ingredients_unique, ingredients_unique, method="lv")

stringdistances_cosine <- stringdistmatrix(ingredients_unique, ingredients_unique, method="cosine")

combined <- stringdistances_lv + stringdistances_cosine
agreement <- which(combined>1 & combined<1.02, arr.ind=TRUE)

for(i in seq_along(agreement)/2) { print(ingredients_unique[c(agreement[i,1], agreement[i, 2])])}

#osa_matches <- which(tmp==1, arr.ind=TRUE)
#cosine_matches <- which(stringdistances>0 & stringdistances < 0.02, arr.ind = TRUE)
#agreement <- union(osa_matches, cosine_matches)

grep("mozzarella", ingredients_unique)
mozzarellas <- grep("mozzarella", ingredients_unique)
distances_mozzarellas <- stringdistmatrix(ingredients_unique[mozzarellas], ingredients_unique[mozzarellas],
                                                method = "lv")
mean(distances_mozzarellas)

for(i in seq_along(cd_match)/2) { print(ingredients_unique[c(cd_match[i,1], cd_match[i, 2])])}





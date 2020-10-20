# Create data set of just "IPA" and "Ale"
ipa_ale <- beer_brew %>% 
  mutate(style2 = as_factor(case_when(str_detect(style, "IPA") ~ "IPA",
                                      str_detect(style, "ale") ~ "Ale"))) %>% 
  filter(!is.na(style2)) %>% 
  select(style2,
         abv,
         ibu)

trainInd <- sample(1:dim(ipa_ale)[1], round(0.75 * dim(ipa_ale)[1]))
train <- ipa_ale[trainInd,]
test <- ipa_ale[-trainInd,]

knn_model <- knn(train[, c(2, 3)], test[, c(2, 3)], train$style2, k = 3)

table(knn_model, test$style2)

(130 + 95) / 251
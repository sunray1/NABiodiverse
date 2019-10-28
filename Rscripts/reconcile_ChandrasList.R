library(dplyr)

c_list <- read.csv("C:/Users/Mike/Documents/UF2/na_but_pd/name_reconciliation/Chandras_list.csv",
                   stringsAsFactors = FALSE)

m_list <- read.csv("C:/Users/Mike/Documents/UF2/na_but_pd/name_reconciliation/ButterflyNamesReconciled - ButterflyNamesReconciled.csv",
                   stringsAsFactors = FALSE)



perfectjoin <- left_join(c_list, m_list, by = c("binomial" = "Lamas_Valid_Name"))
perfectjoin2 <- inner_join(c_list, m_list, by = c("binomial" = "Lamas_Valid_Name"))

matched <- filter(perfectjoin, !is.na(match))
unmatched <- filter(perfectjoin, is.na(match))

unmatched <- unmatched %>% 
  select(binomial)

joinstoKaufman <- inner_join(unmatched, m_list, by = c("binomial" = "Kaufman.US.CAN._name"))

matchedKaufman <- filter(joinstoKaufman, binomial != "")

joinstoGlassberg <- inner_join(unmatched, m_list, by = c("binomial" = "Glassberg.Mexico._Name"))

matchedGlassberg <- filter(joinstoGlassberg, binomial != "")

matchedGlassberg2 <- select(matchedGlassberg, binomial, status, Lamas_Valid_Name, match)
matchedKaufman2 <- select(matchedKaufman, binomial, status, Lamas_Valid_Name, match)
matched2 <- select(matched, binomial, status, match) %>% 
  mutate(Lamas_Valid_Name = binomial)

allMatchedNames <- rbind(matched2, matchedGlassberg2, matchedKaufman2)

notmatched <- left_join(m_list, allMatchedNames, by = "Lamas_Valid_Name")

notinChandrasList <- filter(notmatched, is.na(match.y))



# in Chandras List but not in Mike's List

noRangeMaps <-  left_join(unmatched, matchedGlassberg)
noRangeMaps2 <- left_join(noRangeMaps, matchedKaufman)

noRangeMaps3 <- filter(noRangeMaps2, is.na(Lamas_Valid_Name))

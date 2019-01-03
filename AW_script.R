# customer data

customers <- read_csv('AWCustomers.csv', col_types = cols(

  CustomerID = col_integer(),

  Title = col_character(),

  FirstName = col_character(),

  MiddleName = col_character(),

  LastName = col_character(),

  Suffix = col_character(),

  AddressLine1 = col_character(),

  AddressLine2 = col_character(),

  City = col_character(),

  StateProvinceName = col_character(),

  CountryRegionName = col_character(),

  PostalCode = col_character(),

  PhoneNumber = col_character(),

  BirthDate = col_date(format = ""),

  Education = col_character(),

  Occupation = col_factor(levels = c('Skilled Manual','Manual', 'Clerical',

                                     'Management','Professional')),

  Gender = col_factor(levels = c('M','F')),

  MaritalStatus = col_factor(levels = c('M','S')),

  HomeOwnerFlag = col_integer(),

  NumberCarsOwned = col_integer(),

  NumberChildrenAtHome = col_integer(),

  TotalChildren = col_integer(),

  YearlyIncome = col_integer(),

  LastUpdated = col_date(format = "")

))



# sales data

sales <- read_csv('AWSales.csv', col_types = cols(

  CustomerID = col_integer(),

  BikeBuyer = col_integer(),

  AvgMonthSpend = col_double()

))


# classification training data

class.test <- read_csv('AWTest-Classification.csv', col_types = cols(

  CustomerID = col_integer(),

  Title = col_character(),

  FirstName = col_character(),

  MiddleName = col_character(),

  LastName = col_character(),

  Suffix = col_character(),

  AddressLine1 = col_character(),

  AddressLine2 = col_character(),

  City = col_character(),

  StateProvinceName = col_character(),

  CountryRegionName = col_character(),

  PostalCode = col_character(),

  PhoneNumber = col_character(),

  BirthDate = col_date(format = ""),

  Education = col_character(),

  Occupation = col_factor(levels = c('Skilled Manual','Manual', 'Clerical',

                                     'Management','Professional')),

  Gender = col_factor(levels = c('M','F')),

  MaritalStatus = col_factor(levels = c('M','S')),

  HomeOwnerFlag = col_integer(),

  NumberCarsOwned = col_integer(),

  NumberChildrenAtHome = col_integer(),

  TotalChildren = col_integer(),

  YearlyIncome = col_integer(),

  LastUpdated = col_date(format = "")

))

# regression training data

reg.test <- read_csv('AWTest-Regression.csv', col_types = cols(

  CustomerID = col_integer(),

  Title = col_character(),

  FirstName = col_character(),

  MiddleName = col_character(),

  LastName = col_character(),

  Suffix = col_character(),

  AddressLine1 = col_character(),

  AddressLine2 = col_character(),

  City = col_character(),

  StateProvinceName = col_character(),

  CountryRegionName = col_character(),

  PostalCode = col_character(),

  PhoneNumber = col_character(),

  BirthDate = col_date(format = ""),

  Education = col_character(),

  Occupation = col_factor(levels = c('Skilled Manual','Manual', 'Clerical',

                                     'Management','Professional')),

  Gender = col_factor(levels = c('M','F')),

  MaritalStatus = col_factor(levels = c('M','S')),

  HomeOwnerFlag = col_integer(),

  NumberCarsOwned = col_integer(),

  NumberChildrenAtHome = col_integer(),

  TotalChildren = col_integer(),

  YearlyIncome = col_integer(),

  LastUpdated = col_date(format = "")

))





# STRUCTURE ---------------------------------------------------------------



str(customers, give.attr=F)

str(sales)



# DATA CLEANING -----------------------------------------------------------



# remove duplicates

customers %>% group_by(CustomerID) %>% filter(n() > 1)

sales %>% group_by(CustomerID) %>% filter(n() > 1)



# remove duplicate customers

customers <- customers %>% dplyr::distinct(CustomerID, .keep_all = TRUE)

dim(customers)



# join sales data

df <- left_join(customers, sales, by = "CustomerID")

head(df)



# check for na values

sapply(df, function(x) sum(is.na(x)))
       
# MODELING ----------------------------------------------------------------



# libraries for modeling

pacman::p_load(caret, randomForest, formattable, ROCR)



# TRAIN/TEST SPLIT --------------------------------------------------------



# select columns of interest

df <- df %>%

  select(BikeBuyer, AvgMonthSpend, Gender, Age_Bin, YearlyIncome, Occupation,

         MaritalStatus, NumberCarsOwned, Age, NumberChildrenAtHome, TotalChildren)





# split index

set.seed(123)

index <- createDataPartition(df$BikeBuyer, p = .8, 

                             list = FALSE, 

                             times = 1)



# split data into training and testing sets

train <- df[index,]

test <- df[-index,]



# CLASSIFICATION ----------------------------------------------------------



# create model

rf.model <- randomForest(BikeBuyer ~ Gender + Age_Bin + YearlyIncome + 

                           Occupation + MaritalStatus + NumberCarsOwned + Age + 

                           NumberChildrenAtHome + TotalChildren,

                         data = train,

                         importance = T,

                         ntree = 1000,

                         mtry = 3)



# make predictions using test data

rf.predict <- predict(rf.model, newdata = test, type = 'response')







# append to test df

formattable(head(data.frame(test, rf.predict)), 

            list(rf.predict = formatter("span",

                                        style = x ~ style(color = ifelse( x == 1, "green", "gray")))))

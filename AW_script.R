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

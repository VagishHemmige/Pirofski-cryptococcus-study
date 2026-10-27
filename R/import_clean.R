# Purpose: import the study workbook and derive the analysis variables.
# Needs: raw_data_path, raw_data_sheet (setup.R).
# Produces: CleanData, CleanData_NoMissingTiters, CategoricalVariables,
#   TiterVariables, LogTiterVariables, ContinuousVariables.
# Source: the "dataimport" chunk of the original 2022 R Markdown file. The only
#   change is that the file name and sheet now come from setup.R.

## ---- import-data
#Imports data and prepares for data analysis
RawData<- read_excel(raw_data_path, sheet = raw_data_sheet)

## ---- clean-data
#Data cleaning
CleanData<-RawData %>%
  #Create drug variables for CNI, mycophenolate, etc after cleaning up capitalization issues
  mutate(Drugs=toupper(Drugs)) %>%
  #DrugCNI variable is positive if drug regimen includes PRO (Prograf), T (tacrolimus), or CYC (cyclosporine)
  mutate(DrugCNI=grepl('PRO',Drugs)|grepl('T',Drugs)|grepl('CYC',Drugs)) %>%
  #DrugMycophenolate variable is positive if drug regimen includes M (mycophenolate) or CELL (Cellcept)
  mutate(DrugMycophenolate=grepl('M',Drugs)|grepl('CELL',Drugs)) %>%
  #DrugMTOR variable is positive if drug regimen includes SIR (sirolimus) or EVER (everolimus)
  mutate(DrugMTOR=grepl('SIR',Drugs)|grepl('EVER',Drugs)) %>%
  #Clean SerumCrAg variable and store numerical titer in CryptococcalAg variable
  mutate(CryptococcalAg=as.numeric(SerumCrAg)) %>%
  mutate(CryptococcalAg=ifelse(SerumCrAg %in% c("Negative", "negative"), 0, CryptococcalAg))%>%
  #Create variable for CNS disease
  mutate(CNSDisease=grepl('CNS',InfSite))%>%
  #Remove Subject 116-was control, but crypto antigen was positive
  filter(ID!=116)

#Create a binary HasCryptococcus variable for the purposes of logistic regression
CleanData<-CleanData %>% mutate(HasCryptococcus= CaseOrControl=="Case")

#We fix the capitalization issues in the TransplantOrgan variable
CleanData$TransplantOrgan<-str_to_title(CleanData$TransplantOrgan)

## ---- define-variable-lists
#We define lists of categorical and titer variables
CategoricalVariables<-c("Sex", "TransplantOrgan", "RACE", "CaseOrControl", "STEROID", "DrugCNI",
                        "DrugMycophenolate", "DrugMTOR", "CNSDisease")
TiterVariables<-c("GXMIgG","GXMIgM","LAMIgG","LAMIgM","IgM","IgG1","IgG2" )

## ---- log-transform-titers
# Create logged versions of all titer variables
CleanData<-CleanData %>% mutate(across(TiterVariables, log, .names = "log_{col}"))

#Save the names of the logged titer variables into a list
LogTiterVariables<-paste0("log_",TiterVariables)

#Create a list of all continuous variables
ContinuousVariables<-c("AGE" ,TiterVariables ,LogTiterVariables)

## ---- convert-factors
#Convert appropriate variables from strings to factor variables
CleanData[,CategoricalVariables] <- lapply(CleanData[,CategoricalVariables] , as_factor)

## ---- exclude-missing-titers
#Create a data set where subjects with missing titer data are removed
CleanData_NoMissingTiters<-CleanData%>%
  #Filter observations with missing titer data
  filter(!is.na(GXMIgG))

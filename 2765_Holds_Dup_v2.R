holds_dup <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/M1Holds/",sub('\\.xlsm$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$M1Holds)==0)
  {
    print(filename)
    print("No M1Hold data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_HoldsDUP <- data.frame(value=df_tabs$M1Holds)
  colnames(Data_HoldsDUP) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "County", "InitiateParty", "ProfessionalType","Reason", "Disposition" )
  Data_HoldsDUP$facilityName <- FacilityInfo$"Facility Name"
  Data_HoldsDUP$facilityType <- FacilityInfo$"Facility Type"
  Data_HoldsDUP$year <- FacilityInfo$year
  
  Data_HoldsDUP <- Data_HoldsDUP[, c('facilityName','facilityType','year','ClientID',"DateofBirth","GenderIdentity","Race","Ethnicity", "County", "InitiateParty", "ProfessionalType","Reason", "Disposition")]
  
  write.csv(Data_HoldsDUP,paste(folder_path,"Flattened Data/M1Holds/M1Holds_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
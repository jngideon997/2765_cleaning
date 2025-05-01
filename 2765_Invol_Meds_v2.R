Data_InvolMeds <- invol_meds(df_tabs,FacilityInfo)

invol_meds <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/InvolMeds/",sub('\\.xlsx$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$InvolMeds)==0)
  {
    print(filename)
    print("No InvolMed data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_InvolMeds <- data.frame(value=df_tabs$SeclRestraint)
  colnames(Data_InvolMeds) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "MedOrderType", "MedType", "ERmeds", "COM")
  Data_InvolMeds$facilityName <- FacilityInfo$"Facility Name"
  Data_InvolMeds$facilityType <- FacilityInfo$"Facility Type"
  Data_InvolMeds$year <- FacilityInfo$year
  
  Data_InvolMeds <- Data_InvolMeds[, c('facilityName','facilityType','year',"ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "MedOrderType", "MedType", "ERmeds", "COM")]
  
  write.csv(Data_InvolMeds,paste(folder_path,"Flattened Data/InvolMeds/InvolMeds_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
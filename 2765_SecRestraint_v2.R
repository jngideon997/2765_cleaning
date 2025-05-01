sec_restraint <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/SecRestraint/",sub('\\.xlsx$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$SeclRestraint)==0)
  {
    print(filename)
    print("No SecRestraint data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_SecRestraint <- data.frame(value=df_tabs$SeclRestraint)
  colnames(Data_SecRestraint) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "InterventionType", "RestraintType", "LengthofEpisode")
  Data_SecRestraint$facilityName <- FacilityInfo$"Facility Name"
  Data_SecRestraint$facilityType <- FacilityInfo$"Facility Type"
  Data_SecRestraint$year <- FacilityInfo$year
  
  Data_SecRestraint <- Data_SecRestraint[, c('facilityName','facilityType','year',"ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "InterventionType", "RestraintType", "LengthofEpisode")]
  
  write.csv(Data_SecRestraint,paste(folder_path,"Flattened Data/SecRestraint/SecRestraint_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
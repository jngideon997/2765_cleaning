invol_transport <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/TransportHolds/",sub('\\.xlsm$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$InvolTransport)==0)
  {
    print(filename)
    print("No TransportHold data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_InvolTransport <- data.frame(value=df_tabs$InvolTransport)
  colnames(Data_InvolTransport) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "County", "InitiateParty", "RestraintUse", "Disposition" )
  Data_InvolTransport$facilityName <- FacilityInfo$"Facility Name"
  Data_InvolTransport$facilityType <- FacilityInfo$"Facility Type"
  Data_InvolTransport$year <- FacilityInfo$year
  
  Data_InvolTransport <- Data_InvolTransport[, c('facilityName','facilityType','year','ClientID',"DateofBirth","GenderIdentity","Race","Ethnicity", "County", "InitiateParty", "RestraintUse", "Disposition")]
  
  write.csv(Data_InvolTransport,paste(folder_path,"Flattened Data/TransportHolds/TransportHolds_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
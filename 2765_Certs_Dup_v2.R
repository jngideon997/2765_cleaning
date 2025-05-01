Data_CertsDUP <- certs_dup(df_tabs,FacilityInfo)

certs_dup <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/TransportHolds/",sub('\\.xlsm$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$Certs)==0)
  {
    print(filename)
    print("No Certs data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_CertsDUP <- data.frame(value=df_tabs$Certs)
  colnames(Data_CertsDUP) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "County", "CertType", "Status", "InitiateParty", "Reason", "Services")
  Data_CertsDUP$facilityName <- FacilityInfo$"Facility Name"
  Data_CertsDUP$facilityType <- FacilityInfo$"Facility Type"
  Data_CertsDUP$year <- FacilityInfo$year
  
  Data_CertsDUP <- Data_CertsDUP[, c('facilityName','facilityType','year','ClientID',"DateofBirth","GenderIdentity","Race","Ethnicity", "County", "CertType", "Status", "InitiateParty", "Reason", "Services")]
  
  write.csv(Data_CertsDUP,paste(folder_path,"Flattened Data/Certifications/Certs_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
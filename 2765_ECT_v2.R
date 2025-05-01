Data_ECT<-ect(df_tabs,FacilityInfo)

ect <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/ECT/",sub('\\.xlsx$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$ECT)==0)
  {
    print(filename)
    print("No ECT data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_ECT <- data.frame(value=df_tabs$SeclRestraint)
  colnames(Data_ECT) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "Status", "TotalTx")
  Data_ECT$facilityName <- FacilityInfo$"Facility Name"
  Data_ECT$facilityType <- FacilityInfo$"Facility Type"
  Data_ECT$year <- FacilityInfo$year
  
  Data_ECT <- Data_ECT[, c('facilityName','facilityType','year',"ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "Status", "TotalTx")]
  
  write.csv(Data_ECT,paste(folder_path,"Flattened Data/ECT/ECT_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
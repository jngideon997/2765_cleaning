Data_ILD_DOR<-ild_dor(df_tabs,FacilityInfo)

ild_dor <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/ILDDOR/",sub('\\.xlsx$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$ILD_DOR)==0)
  {
    print(filename)
    print("No ILD DOR data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_ILD_DOR <- data.frame(value=df_tabs$SeclRestraint)
  colnames(Data_ILD_DOR) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "RightDeprived")
  Data_ILD_DOR$facilityName <- FacilityInfo$"Facility Name"
  Data_ILD_DOR$facilityType <- FacilityInfo$"Facility Type"
  Data_ILD_DOR$year <- FacilityInfo$year
  
  Data_ILD_DOR <- Data_ILD_DOR[, c('facilityName','facilityType','year',"ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "RightDeprived")]
  
  write.csv(Data_ILD_DOR,paste(folder_path,"Flattened Data/ILDDOR/ILDDOR_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}
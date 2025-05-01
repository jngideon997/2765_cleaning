########################
## 2765 Pancake Maker ##
########################
# Purpose: Flattens 2765 data from XLSX format to CSV 
# for ingestion into BHA data lakehouse


########################
# Step 1: Declare static values
## Year - year for which data was received for
year <- 2024


## define file directory paths
#designated facilities
des_folder_path <- "Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY24/TEST"
#### DO NOT EDIT - this pulls the unique des/non-des filenames
des_filenames <- list.files(des_folder_path, pattern="*.xlsm", full.names=TRUE)

# non-designated facilties
# non_des_filenames <- list.files(non_des_folder_path, pattern="*.xlsx", full.names=TRUE)

########################
# Step 2: Import necessary libraries and functions
library(readxl)
read_excel_allsheets <- function(filename, tibble = FALSE) {
    sheets <- readxl::excel_sheets(filename)
    x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
    if(!tibble) x <- lapply(x, as.data.frame)
    names(x) <- sheets
    x
}

#Read in 2765 transformation scripts
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Facility_Info.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Vol_Indiv.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Invol_Transport.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Holds_Dup.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Holds_Undup.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Certs_Dup.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Certs_Undup.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_Invol_Meds.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_ECT.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_ILD_DOR.R")
source("Z:/Evaluation Team/27-65 - Involuntary Treatment/Data & Reports/27-65 Annual Data - FY10 thru CY22/CY23/2765_Functions/2765_SecRestraint.R")


########################
# Step 3: Ensure subfolders are created for transformed data
## Note: processed data will be stored in a subfolder of both filepaths above
dir.create(file.path(des_folder_path, "Flattened Data"))
dir.create(file.path(des_folder_path, "Flattened Data/SecRestraint"))
dir.create(file.path(des_folder_path, "Flattened Data/VoluntaryHolds"))
dir.create(file.path(des_folder_path, "Flattened Data/M1Holds"))
dir.create(file.path(des_folder_path, "Flattened Data/TransportHolds"))
dir.create(file.path(des_folder_path, "Flattened Data/Certifications"))
dir.create(file.path(des_folder_path, "Flattened Data/InvolMeds"))
dir.create(file.path(des_folder_path, "Flattened Data/EmergencyInt"))
dir.create(file.path(des_folder_path, "Flattened Data/ECT"))
dir.create(file.path(des_folder_path, "Flattened Data/ILDDOR"))
dir.create(file.path(des_folder_path, "Flattened Data/FeedingTubes"))
# dir.create(file.path(non_des_folder_path, "Flattened Data"))

########################
# Step 4: Process designated facility files
#Designated facilities
for(x in unique(des_filenames)) {
  #See if output file already exists
  #If it exists - skip to the next file
  output_file <- paste(des_folder_path,"Flattened Data/",sub('\\.xlsx$', '', basename(x)),'.csv',sep="")
  sec_rest_output_file <- paste(des_folder_path,"Flattened Data/SecRestraint/SecRestraint_",sub('\\.xlsx$', '', basename(x)),'_v101.csv',sep="")
  
  #Print out name of current working file
  print(x)
  
  if (file.exists(output_file))
    {
      print("file already created - skip")
      
    #Check to see if sec/restraint file is created before moving to next in loop
    if (!file.exists(sec_rest_output_file))
      {  
      
        #Convert XLSX tabs to individual dataframes and rename dfs
        df_tabs <- read_excel_allsheets(x)
        names(df_tabs) <- c("DataDict","FacilityInfo","VolIndivs", "M1Holds", "InvolTransport","Certs","InvolMeds","ERInt","ECT","ILD_DOR", "FeedingTubes")
        
        sec_restraint(df_tabs,FacilityInfo,x,des_folder_path)
    }
    
      Sys.sleep(2)
      next
  }
  
  #Convert XLSX tabs to individual dataframes and rename dfs
  df_tabs <- read_excel_allsheets(x)
  names(df_tabs) <- c("DataDict","FacilityInfo","VolIndivs", "M1Holds", "InvolTransport","Certs","InvolMeds","ERInt","ECT","ILD_DOR", "FeedingTubes")
  
  #Call tab functions to process data accordingly
  FacilityInfo <- facility_info(df_tabs)
  FacilityInfo$year <- year
  Data_Voluntary <- vol_indiv(df_tabs,FacilityInfo)
  Data_InvolTransport <- invol_transport(df_tabs,FacilityInfo)
  Data_HoldsDUP <- holds_dup(df_tabs,FacilityInfo)
  # Data_InvolIndiv <- holds_undup(df_tabs,FacilityInfo)
  Data_CertsDUP <- certs_dup(df_tabs,FacilityInfo)
  # Data_CertsUNDUP <- certs_undup(df_tabs,FacilityInfo)
  Data_InvolMeds <- invol_meds(df_tabs,FacilityInfo)
  Data_EmergInt <- ERInt(df_tabs,FacilityInfo)
  Data_ECT<-ect(df_tabs,FacilityInfo)
  Data_ILD_DOR<-ild_dor(df_tabs,FacilityInfo)
  Data_feedingtube<- ft(df_tabs,FacilityInfo)
  
  #Call tab functions - no return data is provided
  sec_restraint(df_tabs,FacilityInfo,x,des_folder_path)
  vol_indiv(df_tabs,FacilityInfo,x,des_folder_path)
  invol_transport(df_tabs,FacilityInfo,x,des_folder_path)
  holds_dup(df_tabs,FacilityInfo,x,des_folder_path)
  certs_dup(df_tabs,FacilityInfo,x,des_folder_path)
  invol_meds(df_tabs,FacilityInfo,x,des_folder_path)
  ERInt(df_tabs,FacilityInfo,x,des_folder_path)
  ect(df_tabs,FacilityInfo,x,des_folder_path)
  ild_dor(df_tabs,FacilityInfo,x,des_folder_path)
  ft(df_tabs,FacilityInfo,x,des_folder_path)
  
  #Bind all data together for output
  output <- rbind(Data_Voluntary, Data_InvolTransport, Data_HoldsDUP,
                Data_CertsDUP, Data_InvolMeds, Data_EmergInt, Data_ECT, Data_ILD_DOR,
                Data_feedingtube)
  
  
  #Write out csv
  write.csv(output,paste(des_folder_path,"Flattened Data/",sub('\\.xlsx$', '', basename(x)) ,".csv",sep=""), row.names = F)
  
  #Pause briefly
  Sys.sleep(3)
}


########################
# Step 5: Process nondesignated facility files
for(x in unique(non_des_filenames)) {
  #See if output file already exists
  #If it exists - skip to the next file
  output_file <- paste(non_des_folder_path,"Flattened Data/",sub('\\.xlsx$', '', basename(x)),'.csv',sep="")
  
  if (file.exists(output_file))
  {
    print(x)
    print("file already created - skip")
    Sys.sleep(2)
    next
  }
  
  #Print out name of current working file
  print(x)
  
  #Convert XLSX tabs to individual dataframes and rename dfs
  df_tabs <- read_excel_allsheets(x)
  names(df_tabs) <- c('DataDict', 'FacilityInfo', "HoldsDUP",'InvolTransport')
  
  #Call tab functions to process data accordingly
  FacilityInfo <- nondes_facility_info(df_tabs)
  FacilityInfo$year <- year
  Data_HoldsDUP <- holds_dup(df_tabs,FacilityInfo)
 # Data_InvolIndiv <- holds_undup(df_tabs,FacilityInfo)
  Data_InvolTransport <- invol_transport(df_tabs,FacilityInfo)
  
  #Bind all data together for output
  output <- rbind(Data_HoldsDUP, Data_InvolTransport)
  
  #Write out csv
  write.csv(output,paste(non_des_folder_path,"Flattened Data/",sub('\\.xlsx$', '', basename(x)) ,".csv",sep=""), row.names = F)
  
  #Pause briefly
  Sys.sleep(3)
}
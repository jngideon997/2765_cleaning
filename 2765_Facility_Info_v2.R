facility_info <- function(df_tabs) {
  FacilityInfo <- data.frame(value=df_tabs$FacilityInfo[2,1:3])
  colnames(FacilityInfo) <- c("Facility Name","County where Facility is Located","Facility Type")
  FacilityInfo$year <- 2024 #change this year to the current reporting year getting input
  return(FacilityInfo)
}

nondes_facility_info <- function(df_tabs) {
  FacilityInfo <- data.frame(value=df_tabs$FacilityInfo[1,1:3])
  colnames(FacilityInfo) <- c("Facility Name","County Where Facility is Located","Address of Facility Location")
  FacilityInfo$"Facility Type" <- "Non-Designated"
  FacilityInfo$year <- 2024 #change this year to the current reporting year getting input
  return(FacilityInfo)
}
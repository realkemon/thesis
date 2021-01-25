OSM_download_datasets <- function(country, link, name, remove)
{
  print("==========")
  print(name)
  print("==========")
  print(sprintf("Starting download at %s", Sys.time()))
  download.file(link,sprintf("%s/%s.zip",country,name))
  unzip(sprintf("%s/%s.zip",country,name), exdir = sprintf("%s/%s",country,name))
  OSM_import_datasets(country,name)
  if(remove == TRUE)
  {
    print(sprintf("#### Removing downloaded files. Starting at %s", Sys.time()))
    unlink(sprintf("%s/%s.zip",country,name))
    unlink(sprintf("%s/%s",country,name), recursive = TRUE)
    print("----> Downloaded files removed.")
  }
  assign("shapefile_list", c(shapefile_list, name), envir = .GlobalEnv)
}

OSM_import_datasets <- function(country,shapefile)
{
  print(sprintf("#### Starting R import at %s", Sys.time()))
  
  assign(paste(shapefile,"building",sep="_"),    drop_na(select(read_sf(sprintf('%s/%s/gis_osm_buildings_a_free_1.shp', country,shapefile)),"fclass" = "type","geometry")),   envir = .GlobalEnv)
  assign(paste(shapefile,"landuse",sep="_"),     drop_na(select(read_sf(sprintf('%s/%s/gis_osm_landuse_a_free_1.shp',   country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"natural_1",sep="_"),   drop_na(select(read_sf(sprintf('%s/%s/gis_osm_natural_a_free_1.shp',   country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"natural_2",sep="_"),   drop_na(select(read_sf(sprintf('%s/%s/gis_osm_natural_free_1.shp',     country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"places_1",sep="_"),    drop_na(select(read_sf(sprintf('%s/%s/gis_osm_places_a_free_1.shp',    country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"places_2",sep="_"),    drop_na(select(read_sf(sprintf('%s/%s/gis_osm_places_free_1.shp',      country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"pofw_1",sep="_"),      drop_na(select(read_sf(sprintf('%s/%s/gis_osm_pofw_a_free_1.shp',      country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"pofw_2",sep="_"),      drop_na(select(read_sf(sprintf('%s/%s/gis_osm_pofw_free_1.shp',        country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"pois_1",sep="_"),      drop_na(select(read_sf(sprintf('%s/%s/gis_osm_pois_a_free_1.shp',      country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"pois_2",sep="_"),      drop_na(select(read_sf(sprintf('%s/%s/gis_osm_pois_free_1.shp',        country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"railways",sep="_"),    drop_na(select(read_sf(sprintf('%s/%s/gis_osm_railways_free_1.shp',    country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"roads",sep="_"),       drop_na(select(read_sf(sprintf('%s/%s/gis_osm_roads_free_1.shp',       country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  # assign(paste(shapefile,"roads",sep="_"),       drop_na(select(read_sf(sprintf('%s/%s/gis_osm_roads_free_1.shp',       country,shapefile)),"fclass","geometry","ref")), envir = .GlobalEnv)
  assign(paste(shapefile,"traffic_1",sep="_"),   drop_na(select(read_sf(sprintf('%s/%s/gis_osm_traffic_a_free_1.shp',   country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"traffic_2",sep="_"),   drop_na(select(read_sf(sprintf('%s/%s/gis_osm_traffic_free_1.shp',     country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"transport_1",sep="_"), drop_na(select(read_sf(sprintf('%s/%s/gis_osm_transport_a_free_1.shp', country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"transport_2",sep="_"), drop_na(select(read_sf(sprintf('%s/%s/gis_osm_transport_free_1.shp',   country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"water",sep="_"),       drop_na(select(read_sf(sprintf('%s/%s/gis_osm_water_a_free_1.shp',     country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  assign(paste(shapefile,"waterways",sep="_"),   drop_na(select(read_sf(sprintf('%s/%s/gis_osm_waterways_free_1.shp',   country,shapefile)),"fclass","geometry")), envir = .GlobalEnv)
  
  print(sprintf("#### Finished R import at %s", Sys.time()))
}

OSM_merge_datasets <- function(country,layer)
{
  print(sprintf("Merging dataframes. Starting at: %s", Sys.time()))
  result <- get(paste(shapefile_list[1],layer,sep="_"))
  for (i in 2:length(shapefile_list))
  {
    result <- bind_rows(result,get(paste(shapefile_list[i],layer,sep="_")))
  }
  
  print(sprintf("Deleting state-level dataframes. Starting at: %s", Sys.time()))
  for (i in 1:length(shapefile_list))
  {
    rm(list = c(paste(shapefile_list[i],layer,sep="_")), envir = .GlobalEnv)
  }
  
  print(sprintf("Saving merged dataframe to file. Starting at: %s", Sys.time()))
  saveRDS(result, file = sprintf("%s/OSM_%s.RDS", country, layer))
}

OSM_prepare_datasets <- function(country,layer)
{
  print(sprintf("Preparing: %s", layer))
  print("==========")
  print(sprintf("Stage 1: Importing Dataset. Starting at %s", Sys.time()))
  dataset <- readRDS(sprintf("%s/OSM_%s",country, paste(layer,"RDS",sep=".")))
  print(sprintf("----> %s shapefile imported", layer))
  
  print("==========")
  print(sprintf("Stage 2: Matching localities' fclass to corresponding catalogue index. Starting at %s", Sys.time()))
  dataset["catalogue_index"] <- OSM_index_features(dataset,gsub("_[1-2]","",layer))
  print("----> Catalogue indices matched.")
  
  print("==========")
  print(sprintf("Stage 3: Removing undesired localities. Starting at %s", Sys.time()))
  counter <- length(dataset$geometry)
  dataset <- drop_na(dataset)
  counter <- counter - length(dataset$geometry)
  print(sprintf("----> %s undesired localities removed.", counter))
  
  if(!is_empty(dataset$fclass))
  {
    print("==========")
    print(sprintf("Stage 4: Specify appropriate Coordinate Reference System. Starting at %s", Sys.time()))
    dataset$geometry <- st_sfc(dataset$geometry, crs = 4326)  ## Assign default World Geodetic System. Directly setting 4839 produces incorrect results, because the data is in fact given in 4326!
    dataset$geometry <- st_transform(dataset$geometry,4839)   ## Transform to proper CRS.
    print("----> Coordinate Reference System changed to: European Terrestrial Reference System 1989 (EPSG:4839)")
    
    print("==========")
    print(sprintf("Stage 5: Check geometries for validity. Starting at %s", Sys.time()))
    counter <- length(dataset$geometry)
    dataset$geometry <- st_make_valid(dataset$geometry)
    dataset <- drop_na(dataset)
    counter <- counter - length(dataset$geometry)
    print("----> Validated geometries for further analysis.")
    
    print("==========")
    print(sprintf("Stage 6: Simplify geometries. Starting at %s", Sys.time()))
    # dataset <- OSM_simplify_geometry(dataset)
    print(sprintf("----> Stage skipped."))
    
    print("==========")
    print(sprintf("Stage 7: Remove duplicate geometries. Starting at %s", Sys.time()))
    dataset <- OSM_remove_duplicates(dataset)
    
    print("==========")
    print(sprintf("Stage 8: Does the shapefile have a corresponding polygon shapefile?"))
    if(isTRUE(grepl("_2", layer, fixed = TRUE)))  ## Does shapefile contain "_2" in its name? If so it's the point shapefile to a polygon shapefile.
    {
      print(sprintf("----> Corresponding polygon shapefile found."))
      print(sprintf("## Importing polygon shapefile. Starting at %s", Sys.time()))
      dataset1 <- readRDS(sprintf("%s/OSM_%s",country, paste(gsub("2","1",layer),"RDS",sep=".")))
      dataset2 <- OSM_remove_labels(dataset1,dataset)
      rm(dataset1)
    }
    else
    {
      print(sprintf("----> No corresponding polygon shapefile found. Skipping."))
    }
  }
  else
  {
    print("==========")
    print("Dataset is empty. Skipping further preparation steps.")
  }
  
  print("==========")
  print(sprintf("Stage 9: Saving dataset to file. Starting at %s", Sys.time()))
  saveRDS(dataset, file = sprintf("%s/OSM_%s",country, paste(layer,"RDS",sep=".")))
  print("----> Dataset saved")
  rm(dataset)
  print("----> Dataset removed")
  
  print("==========")
  print(sprintf("Finished preparing %s at %s", layer, Sys.time()))
  print("==========")
}

OSM_index_features <- function(dataset,layer)
{
  long_name       <- paste(layer,dataset$fclass,sep="_")                            ## Generate long names for each fclass that corresponds to a long name in the feature catalogue.
  catalogue_index <- match(long_name,feature_catalogue$long_name)                   ## Create initial catalogue index by matching concatenated fclass.
  catalogue_index <- feature_catalogue$catalogue_index[as.integer(catalogue_index)] ## Replace catalogue index with the corresponding value of the 'catalogue_index' column.
  
  return(catalogue_index)
}

OSM_simplify_geometry <- function(dataset) ## Trying to simplify the entire dataframe at once may exceed storeage limits in R and crash the session. The dataframe is therefore first split into 4 sections which are then simplified and merged in the end.
{
  Z <- split(dataset, factor(sort(rank(row.names(dataset))%%4)))  ## REFERENCE: https://stackoverflow.com/questions/3302356/how-to-split-a-data-frame
  
  ## Simplify geometries with a 75 m tolerance.
  Z$`0`$geometry <- st_simplify(Z$`0`$geometry, preserveTopology = TRUE, dTolerance = 75)
  Z$`1`$geometry <- st_simplify(Z$`1`$geometry, preserveTopology = TRUE, dTolerance = 75)
  Z$`2`$geometry <- st_simplify(Z$`2`$geometry, preserveTopology = TRUE, dTolerance = 75)
  Z$`3`$geometry <- st_simplify(Z$`3`$geometry, preserveTopology = TRUE, dTolerance = 75)
  
  result <- rbind(Z$`0`, Z$`1`, Z$`2`, Z$`3`)
  return(result)
}

OSM_remove_duplicates <- function(dataset)
{
  counter <- length(dataset$geometry)                                                               ## Remember how many localities where in the dataframe at the start.
  
  print(sprintf("## Generating list of duplicate geometries. Starting at: %s", Sys.time()))
  match <- st_equals(dataset$geometry)                                                              ## Match geometries against themselves to find duplicates.
  
  print(sprintf("## Structuring the results. Starting at: %s", Sys.time()))
  match <- lapply(match, function(temp) temp[!length(temp) == 1])                                   ## Remove all sublists that only contain the geometry itself from the list.
  match <- compact(match)                                                                           ## Remove empty list elements. Indices are preserved as each geometry is equal to itself.
  index <- lapply(seq_along(match), function(i){dataset$catalogue_index[match[[i]]]})               ## Replace OSM index with respective catalogue_index to check for semantic duplicates. 
  duplicates <- lapply(seq_along(index), function(i){duplicated(index[[i]])})                       ## Mark which catalogue indices are duplicates for each geometry.
  remove_me <- lapply(seq_along(match), function(i){match[[i]][which(duplicates[[i]] == TRUE)]})    ## Only keep those indices that were marked as duplicates.
  remove_me <- as.vector(unique(unlist(remove_me)))                                                 ## Get all unique indices that need to be removed due to being duplicate.
  
  print(sprintf("## Removing duplicate geometries from dataset. Starting at: %s", Sys.time()))
  # dataset <- dataset[-which(rownames(dataset) %in% remove_me),]                                   ## Remove those localities whose index has been marked as duplicate.
  dataset <- dataset[-remove_me,]             ##PROBABLY THIS ONE; BUT CHECK!                       ## Remove those localities whose index has been marked as duplicate.
  counter <- counter - length(dataset$geometry)                                                     ## Calculate the difference of locality sum to print how many were removed.
  print(sprintf("----> %s duplicate localities removed.", counter))
  
  return(dataset)
}

OSM_remove_labels <- function(dataset1,dataset2) 
{
  counter <- length(dataset2$geometry)                                                                              ## Remember how many localities where in the dataframe at the start.
  
  print(sprintf("## Generating list of redundant localities Starting at: %s", Sys.time()))
  dataset2_match <- st_intersects(dataset1$geometry,dataset2$geometry)                                              ## Find all points from dataset2 that intersect with each polygon from dataset1.
  
  print(sprintf("## Structuring the results. Starting at: %s", Sys.time()))
  dataset2_index <- lapply(seq_along(dataset2_match), function(i){dataset2$catalogue_index[dataset2_match[[i]]]})   ## Replace OSM index with respective catalogue_index to check for semantic duplicates.
  dataset1_match <- lapply(seq_along(dataset1$fclass), function(i){i})                                              ## Create list of OSM indices for dataset1.
  dataset1_index <- lapply(seq_along(dataset1_match), function(i){dataset1$catalogue_index[dataset1_match[[i]]]})   ## Replace OSM index with respective catalogue_index to check for semantic duplicates.
  
  remove_me <- lapply(seq_along(dataset2_index), function(i){which(dataset2_index[[i]] == dataset1_index[[i]])})    ## Mark which catalogue indices are duplicates for each geometry.
  remove_me <- lapply(seq_along(remove_me), function(i){dataset2_match[[i]][remove_me[[i]]]})                       ## Merge lists to achieve the same format as OSM_remove_shapefile_duplicates.
  remove_me <- as.vector(unique(unlist(remove_me)))                                                                 ## Get all unique indices that need to be removed due to being duplicate.
  
  print(sprintf("## Removing redundant localities from dataset. Starting at: %s", Sys.time()))
  # dataset2 <- dataset2[-which(rownames(dataset2) %in% remove_me),]                                                ## Remove those localities whose index has been marked as duplicate.
  dataset2 <- dataset2[-remove_me,]             ##PROBABLY THIS ONE; BUT CHECK!                                     ## Remove those localities whose index has been marked as duplicate. 
  counter <- counter - length(dataset2$geometry)                                                                    ## Calculate the difference of locality sum to print how many were removed.
  print(sprintf("----> %s redundant localities removed.", counter))
  
  return(dataset2)
}

OSM_prepare_matching <- function(country)
{
  print("==========")
  print(sprintf("Importing OCM dataset. Starting at %s", Sys.time()))
  assign("OCM", readRDS(sprintf("%s/OCM.RDS", country)), envir = .GlobalEnv)
  
  ## Create placeholder lists for all walking distances.
  assign("matched_200", vector(mode = "list", length = length(OCM$geometry)), envir = .GlobalEnv)
  assign("matched_400", vector(mode = "list", length = length(OCM$geometry)), envir = .GlobalEnv)
  assign("matched_600", vector(mode = "list", length = length(OCM$geometry)), envir = .GlobalEnv)
  
  print("==========")
  print(sprintf("Matching of OSM to OCM data. Starting at %s", Sys.time()))
  OSM_match_to_OCM(country,"OSM_building")
  OSM_match_to_OCM(country,"OSM_landuse")
  OSM_match_to_OCM(country,"OSM_natural_1")
  OSM_match_to_OCM(country,"OSM_natural_2")
  OSM_match_to_OCM(country,"OSM_places_1")
  OSM_match_to_OCM(country,"OSM_places_2")
  OSM_match_to_OCM(country,"OSM_pofw_1")
  OSM_match_to_OCM(country,"OSM_pofw_2")
  OSM_match_to_OCM(country,"OSM_pois_1")
  OSM_match_to_OCM(country,"OSM_pois_2")
  # OSM_match_to_OCM(country,"OSM_railways",country)  ## Dataframe is empty due to filtering in catalogue.
  OSM_match_to_OCM(country,"OSM_roads")
  OSM_match_to_OCM(country,"OSM_traffic_1")
  OSM_match_to_OCM(country,"OSM_traffic_2")
  OSM_match_to_OCM(country,"OSM_transport_1")
  OSM_match_to_OCM(country,"OSM_transport_2")
  OSM_match_to_OCM(country,"OSM_water")
  # OSM_match_to_OCM(country,"OSM_waterways") ## Dataframe is empty due to filtering in catalogue.
  
  ## Create dataframe to hold all matched information.
  matches <- data.frame("id" = OCM$id,
                        "distance_200" = numeric(length(OCM$geometry)),
                        "distance_400" = numeric(length(OCM$geometry)),
                        "distance_600" = numeric(length(OCM$geometry)))
  
  ## Fill dataframe with all matched information.
  matches$distance_200 <- matched_200
  matches$distance_400 <- matched_400
  matches$distance_600 <- matched_600
  
  print("==========")
  print(sprintf("Saving matched information to file. Starting at %s", Sys.time()))
  saveRDS(matches, file = sprintf("%s/matches.RDS",country))
  rm(list = c("OCM","matched_200","matched_400","matched_600"), envir = .GlobalEnv)
}

OSM_match_to_OCM <- function(country,dataset)
{
  print("==========")
  print(dataset)
  print("==========")
  
  print(sprintf("## Importing shape file. Starting at %s", Sys.time()))
  dataset <- readRDS(sprintf("%s/%s.RDS",country,dataset))
  
  print("==========")
  print(sprintf("## Calculating intersecting localities. Starting at %s", Sys.time()))
  print(sprintf("#### Maximum convenient walking distance. Starting at %s", Sys.time()))
  intersections_200 <- st_intersects(OCM$distance_200,dataset$geometry, sparse = TRUE, prepared = TRUE)
  print(sprintf("#### Maximum desirable walking distance. Starting at %s", Sys.time()))
  intersections_400 <- st_intersects(OCM$distance_400,dataset$geometry, sparse = TRUE, prepared = TRUE)
  print(sprintf("#### Maximum acceptable walking distance. Starting at %s", Sys.time()))
  intersections_600 <- st_intersects(OCM$distance_600,dataset$geometry, sparse = TRUE, prepared = TRUE)
  
  print("==========")
  print(sprintf("## Structuring the result. Starting at %s", Sys.time()))
  print(sprintf("#### Maximum convenient walking distance. Starting at %s", Sys.time()))
  intersections_200 <- lapply(seq_along(intersections_200),function(i){                                                   ## Iterate through the list of intersections.
    lapply(seq_along(intersections_200[[i]]), function(j){                                            ## Iterate through the sublist for each CS.
      intersections_200[[i]][j] = dataset$catalogue_index[as.integer(intersections_200[[i]][j])]})})  ## Replace matched locality with corresponding catalogue_index.
  print(sprintf("#### Maximum desirable walking distance. Starting at %s", Sys.time()))
  intersections_400 <- lapply(seq_along(intersections_400),function(i){                                                   ## Iterate through the list of intersections.
    lapply(seq_along(intersections_400[[i]]), function(j){                                            ## Iterate through the sublist for each CS.
      intersections_400[[i]][j] = dataset$catalogue_index[as.integer(intersections_400[[i]][j])]})})  ## Replace matched locality with corresponding catalogue_index.
  print(sprintf("#### Maximum acceptable walking distance. Starting at %s", Sys.time()))
  intersections_600 <- lapply(seq_along(intersections_600),function(i){                                                   ## Iterate through the list of intersections.
    lapply(seq_along(intersections_600[[i]]), function(j){                                            ## Iterate through the sublist for each CS.
      intersections_600[[i]][j] = dataset$catalogue_index[as.integer(intersections_600[[i]][j])]})})  ## Replace matched locality with corresponding catalogue_index.
  
  print("==========")
  print(sprintf("## Concatenate results to per-country list. Starting at %s", Sys.time()))
  assign("matched_200", lapply(seq_along(intersections_200), function(i){matched_200[[i]] <- c(matched_200[[i]], intersections_200[[i]])}), envir = .GlobalEnv)
  assign("matched_400", lapply(seq_along(intersections_400), function(i){matched_400[[i]] <- c(matched_400[[i]], intersections_400[[i]])}), envir = .GlobalEnv)
  assign("matched_600", lapply(seq_along(intersections_600), function(i){matched_600[[i]] <- c(matched_600[[i]], intersections_600[[i]])}), envir = .GlobalEnv)
}

LDA_get_DTM <- function(country)
{
  print("==========")
  print(country)
  dataset <- readRDS(sprintf("%s/matches.RDS",country))
  print("==========")
  print(sprintf("Concatenating fclasses to string. Starting at %s", Sys.time()))
  distance_200 <- lapply(seq_along(dataset$distance_200),function(i){dataset$distance_200[[i]] <- paste(na.omit(dataset$distance_200[[i]]), collapse = " ")})
  distance_400 <- lapply(seq_along(dataset$distance_400),function(i){dataset$distance_400[[i]] <- paste(na.omit(dataset$distance_400[[i]]), collapse = " ")})
  distance_600 <- lapply(seq_along(dataset$distance_600),function(i){dataset$distance_600[[i]] <- paste(na.omit(dataset$distance_600[[i]]), collapse = " ")})
  
  print(sprintf("Interpreting each element/row as a separate document. Starting at %s", Sys.time()))
  distance_200 <- VectorSource(distance_200)
  distance_400 <- VectorSource(distance_400)
  distance_600 <- VectorSource(distance_600)
  
  print(sprintf("Compiling documents to a corpus. Starting at %s", Sys.time()))
  distance_200 <- SimpleCorpus(distance_200)
  distance_400 <- SimpleCorpus(distance_400)
  distance_600 <- SimpleCorpus(distance_600)
  
  print(sprintf("Generating Document Term Matrices. Starting at %s", Sys.time()))
  distance_200 <- DocumentTermMatrix(distance_200)
  distance_400 <- DocumentTermMatrix(distance_400)
  distance_600 <- DocumentTermMatrix(distance_600)
  
  print(sprintf("Saving DTMs to file. Starting at %s", Sys.time()))
  saveRDS(distance_200, file = sprintf("%s/distance_200.RDS",country))
  saveRDS(distance_400, file = sprintf("%s/distance_400.RDS",country))
  saveRDS(distance_600, file = sprintf("%s/distance_600.RDS",country))
}

LDA_preparation <- function(country)
{
  print("==========")
  print(country)
  print("==========")
  print(sprintf("Importing datasets. Starting at %s", Sys.time()))
  distance_200 <- readRDS(sprintf("%s/distance_200.RDS",country))
  distance_400 <- readRDS(sprintf("%s/distance_400.RDS",country))
  distance_600 <- readRDS(sprintf("%s/distance_600.RDS",country))
  OCM <- readRDS(sprintf("%s/OCM.RDS",country))
  
  print(sprintf("Storing indices of unmatched CS. Starting at %s", Sys.time()))
  empty_rows_200 <- which(rowSums(as.matrix(distance_200)) == 0)
  empty_rows_400 <- which(rowSums(as.matrix(distance_400)) == 0)
  empty_rows_600 <- which(rowSums(as.matrix(distance_600)) == 0)
  
  print(sprintf("Assigning category '0' to all. Starting at %s", Sys.time()))
  OCM <- add_column(OCM,"category_200" = 0,"category_400" = 0,"category_600" = 0)
  
  print(sprintf("Replacing category of unmatched CS with 'NA'. Starting at %s", Sys.time()))
  OCM[empty_rows_200,"category_200"] <- NA
  OCM[empty_rows_400,"category_400"] <- NA
  OCM[empty_rows_600,"category_600"] <- NA
  
  print(sprintf("Saving categorised OCM to file. Starting at %s", Sys.time()))
  saveRDS(OCM, file = sprintf("%s/OCM.RDS",country))
  
  print(sprintf("Removing unmatched CS from DTMs. Starting at %s", Sys.time()))
  distance_200 <- distance_200[apply(distance_200,1,sum) != 0,]
  distance_400 <- distance_400[apply(distance_400,1,sum) != 0,]
  distance_600 <- distance_600[apply(distance_600,1,sum) != 0,]
  
  print(sprintf("Saving DTMs to file. Starting at %s", Sys.time()))
  saveRDS(distance_200, file = sprintf("%s/distance_200.RDS",country))
  saveRDS(distance_400, file = sprintf("%s/distance_400.RDS",country))
  saveRDS(distance_600, file = sprintf("%s/distance_600.RDS",country))
}

LDA_number_of_topics <- function(country,distance)
{
  print("==========")
  print(country)
  print("==========")
  
  set.seed(1234)
  dtm <- readRDS(sprintf("%s/%s.RDS",country,distance))
  
  print(sprintf("Generating LDAs for 2-25 topics. This will take a while! Starting at %s", Sys.time()))
  LDAs <- lapply(seq(2,25, by=1), function(k){print(sprintf("Generating LDA for %s topics. Starting at %s", k, Sys.time()))
    LDA(dtm, k = k, control = list(seed = 1234))})
  
  print(sprintf("Saving LDAs to file. Starting at %s", Sys.time()))
  saveRDS(LDAs, file = sprintf("%s/LDA_%s_total.RDS",country,distance))
  
  print(sprintf("Extracting log likelihoods of all iterations. Starting at %s", Sys.time()))
  LDAs_log_likelihood <- as.data.frame(as.matrix(lapply(LDAs, logLik)))
  LDAs_log_likelihood <- data.frame(topics=c(2:25), LL=as.numeric(as.matrix(LDAs_log_likelihood)))
  
  print(sprintf("Saving log likelihoods to file. Starting at %s", Sys.time()))
  saveRDS(LDAs_log_likelihood, file = sprintf("%s/LDA_%s_logLik.RDS",country,distance))
}

LDA_finalise <- function(country, numOfTopics, distance)
{
  numOfTopics <- numOfTopics - 1 ## LDAs are done for 2-25 topics. Therefore, the number of LDA is always one increment lower than the topic number included.
  
  print("==========")
  print(sprintf("LDA for %s with %s topics and a distance of %s metres. Starting at %s",country,numOfTopics+1,distance,Sys.time()))
  print("==========")
  
  print(sprintf("Importing necessary data. Starting at %s", Sys.time()))
  OCM <- readRDS(sprintf("%s/OCM.RDS",country))
  LDA <- readRDS(sprintf("%s/LDA_distance_%s_total.RDS",country,distance))
  DTM <- readRDS(sprintf("%s/distance_%s.RDS",country,distance))
  
  print(sprintf("Extracting appropriate LDA. Starting at %s", Sys.time()))
  LDA <- LDA[[numOfTopics]]
  
  print(sprintf("Extracting dominant category for each CS. Starting at %s", Sys.time()))
  topics <- data.frame("topics" = topicmodels::topics(LDA, 1), stringsAsFactors = FALSE)
  
  print(sprintf("Adding dominant CS category to OCM. Starting at %s", Sys.time()))
  if(distance == "200")
  {
    OCM$category_200[which(OCM$category_200 == 0)] <- topics$topics
  }
  else if(distance == "400")
  {
    OCM$category_400[which(OCM$category_400 == 0)] <- topics$topics
  }
  else if(distance == "600")
  {
    OCM$category_600[which(OCM$category_600 == 0)] <- topics$topics
  }
  else
  {
    print("how?")
  }
  
  print(sprintf("Extracting Top10 fclasses per category. Starting at %s", Sys.time()))
  terms <- as.data.frame(topicmodels::terms(LDA, 5), stringsAsFactors = FALSE)
  
  print(sprintf("Replacing catalogue indices with fclasses in categories' Top10. Starting at %s", Sys.time()))
  terms <- as.data.frame(lapply(seq_along(terms),function(i){feature_catalogue$generalisation[match(terms[,i], feature_catalogue$catalogue_index)]}))
  colnames(terms) <- as.vector(lapply(seq_along(rep("Topic",numOfTopics + 1)),function(i){sprintf("Topic%s",i)}))
  
  print(sprintf("Saving categories' Top10 to file. Starting at %s", Sys.time()))
  saveRDS(terms, file = sprintf("%s/categories_%s.RDS",country,distance))
  
  print(sprintf("Saving extracted LDA to file. Starting at %s", Sys.time()))
  saveRDS(LDA, file = sprintf("%s/LDA_%s.RDS",country,distance))
  
  print(sprintf("Saving OCM to file. Starting at %s", Sys.time()))
  saveRDS(OCM, file = sprintf("%s/OCM.RDS",country))
}

LDA_visualise <- function(country, distance)
{
  set.seed(1234)
  print("==========")
  print(sprintf("Importing datasets for %s and a distance of %sm. Started at: %s", country, distance, Sys.time()))
  print("==========")
  OCM <- readRDS(sprintf("%s/OCM.RDS",country))
  OCM <- OCM[-which(is.na(eval(parse(text=sprintf("OCM$category_%s",distance))))),]
  LDA <- readRDS(sprintf("%s/LDA_%s.RDS",country, distance))
  DTM <- readRDS(sprintf("%s/distance_%s.RDS",country, distance))
  terms <- readRDS(sprintf("%s/categories_%s.RDS",country, distance))
  numOfTopics <- length(terms)
  
  print(sprintf("Calculating membership probabilities. Started at: %s", Sys.time()))
  categories <- tidy(LDA, matrix = "gamma")
  categories <- spread(categories, topic, gamma) ## transform from long data frame to wide dateframe
  colnames(categories) <- c("row_id",colnames(terms))
  
  print(sprintf("Preparing scatterpie chart. Started at: %s", Sys.time()))
  tsne <- Rtsne(categories,dims=2,perplexity=30,verbose=T,max_iter=1500,check_duplicates=F,partial_pca=T)
  topic <- t(as.data.frame(lapply(seq_along(categories$row_id), function(i){max(categories[i,-1])})))
  label <- t(as.data.frame(lapply(seq_along(categories$row_id), function(i){colnames(categories[,-1])[which(categories[i,-1] == topic[i])]})))
  categories <- add_column(categories,"x_tsne" = tsne$Y[,1])
  categories <- add_column(categories,"y_tsne" = tsne$Y[,2])
  categories <- add_column(categories,"dominant_topic" = topic)
  categories <- add_column(categories,"label" = label)
  
  labels <- lapply(split(categories, categories$label), function(x) {x[which.max(x$dominant_topic), c(length(categories)-3, length(categories)-2, length(categories))]})
  labels <- as.data.frame(do.call(rbind, labels))
  
  print(sprintf("Computing scatterpie chart. Started at: %s", Sys.time()))
  scatterpie_plot <- ggplot() +
    geom_scatterpie(aes(x=x_tsne, y=y_tsne, group=row_id, r=dominant_topic), data=categories[-which(categories$dominant_topic < 0.34),], cols=colnames(terms), color=NA, alpha=0.7) +
    geom_label(data = labels, aes(x=x_tsne, y=y_tsne,label = label), fontface = "bold", alpha=0.7) +
    coord_equal() +
    xlab("") + ylab("") +
    scale_fill_manual(values=rainbow(numOfTopics)) +
    theme(text = element_text(color="white"),
          legend.position = "none",
          panel.background = element_rect(fill = "gray17", colour = "gray17"),
          plot.background = element_rect(fill = "gray17"),
          panel.grid.major = element_line(color = "gray25"),
          panel.grid.minor = element_line(color = "gray25"),
          axis.text = element_text(color="white"))
  ggsave(sprintf("%s/%s_%s_scatterpie.png",country,country,distance),units="in", width=9, height=9, dpi=500)
  print(sprintf("Scatterpie chart saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print(sprintf("Computing correlation plot. Started at: %s", Sys.time()))
  png(filename=sprintf("%s/%s_%s_correlation.png",country,country,distance),units="in", width=9, height=9, res=500)
  corrplot(cor(topicmodels::posterior(LDA)$topics), method = "square", tl.cex = 2, cl.cex = 2)
  dev.off()
  print(sprintf("Correlation plot saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print(sprintf("Computing Time Series for annual CI expansion. Started at: %s", Sys.time()))
  timeseries1 <- ggplot(OCM[,c("DateCreated",sprintf("category_%s",distance))], aes(x = format(as.Date(DateCreated, format="%d/%m/%Y"),"%Y"), fill = as.factor(eval(parse(text=sprintf("category_%s",distance)))))) +
    geom_bar(colour="black") +
    scale_fill_manual(values=rainbow(numOfTopics),name = "Topics") +
    theme_classic()+
    theme(legend.key.size =  unit(0.45, "in"),
          legend.text = element_text(size=22),
          legend.title=element_text(size=18),
          axis.text = element_text(size = 18),
          axis.title = element_text(size = rel(2.5))) +
    labs(x="Years",y="Number of CS")+
    # ggtitle(sprintf("Annual expansion of charging infrastructure (%s - %s m)",country, distance))
    ggsave(sprintf("%s/%s_%s_annual.png",country,country,distance),units="in", width=9, height=9, dpi=500)
  print(sprintf("Time Series for CS saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print(sprintf("Time series for aggregated CI development. Started at: %s", Sys.time()))
  aggregated <- data.frame("category" = as.factor(eval(parse(text=sprintf("OCM$category_%s",distance)))), "DateCreated" = format(as.Date(OCM$DateCreated, format="%d/%m/%Y"),"%Y"),"quantities" = 1)
  aggregated <- aggregate(quantities ~ DateCreated + category, data = aggregated, sum)
  aggregated <- add_column(aggregated, "cummulative" = NA)
  for (i in 1:length(unique(aggregated$category)))
  {
    temp <- aggregated[which(aggregated$category == i),]
    aggregated[which(aggregated$category == i),]$cummulative <- lapply(seq_along(temp$quantities), function(j){sum(temp$quantities[seq(0, j-1, by = 1)],temp$quantities[j])})
  }
  
  timeseries2 <- ggplot(aggregated, aes(x = DateCreated, y = cummulative, fill = category, label = cummulative)) +
    geom_bar(colour="black",stat = "identity") +
    scale_fill_manual(values=rainbow(numOfTopics),name = "Topics") +
    theme_classic()+
    theme(legend.key.size =  unit(0.45, "in"),
          legend.text = element_text(size=22),
          legend.title=element_text(size=18),
          axis.text = element_text(size = 18),
          axis.title = element_text(size = rel(2.5))) +
    labs(x="Years",y="Number of CS")+
    # ggtitle(sprintf("Aggregated expansion of charging infrastructure over time (%s - %s m)",country, distance))
    ggsave(sprintf("%s/%s_%s_aggregated.png",country,country,distance),units="in", width=9, height=9, dpi=500)
  print(sprintf("Time Series for charging infrastructure saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print(sprintf("Time series for relative category development. Started at: %s", Sys.time()))
  timeseries3 <- ggplot(drop_na(OCM[,c("DateCreated",sprintf("category_%s",distance))]), aes(x = as.factor(eval(parse(text=sprintf("category_%s",distance)))), y = DateCreated, fill = as.factor(eval(parse(text=sprintf("category_%s",distance)))))) + 
    geom_violin(colour="black") + 
    coord_flip() +
    scale_fill_manual(values=rainbow(numOfTopics),name = "Topics",guide = guide_legend(reverse = TRUE)) +
    theme_classic()+
    theme(legend.key.size =  unit(0.45, "in"),
          legend.text = element_text(size=22),
          legend.title=element_text(size=18),
          axis.text = element_text(size = 18),
          axis.title = element_text(size = rel(2.5))) +
    labs(x="Topics",y="Years")+
    # ggtitle(sprintf("Relative development of each topic (%s - %s m)",country,distance))
    ggsave(sprintf("%s/%s_%s_relative.png",country,country,distance),units="in", width=9, height=9, dpi=500)
  print(sprintf("Time Series for connection types saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print(sprintf("Time series for connection types. Started at: %s", Sys.time()))
  connections <- drop_na(data.frame("connections" = unlist(OCM$connections),
                                    "DateCreated" = format(as.Date(rep(OCM$DateCreated, sapply(OCM$connections, length)), format="%d/%m/%Y"),"%Y"),
                                    "quantities" = unlist(OCM$quantities)))
  
  timeseries4 <- ggplot(connections[,c("DateCreated","connections")], aes(x = DateCreated, fill = as.factor(connections))) +
    geom_bar(colour="black") +
    scale_fill_manual(values=rainbow(length(unique(connections$connections))),name = "Connections") +
    theme_classic()+
    theme(legend.key.size =  unit(0.45, "in"),
          legend.text = element_text(size=14),
          axis.text = element_text(size = 14),
          axis.title = element_text(size = rel(1.75))) +
    labs(x="Years",y="Number of connections")+
    # ggtitle("Annual expansion of connection types")
    ggsave(sprintf("%s/%s_connections.png",country,country),units="in", width=9, height=9, dpi=500)
  print(sprintf("Time Series for connection types saved to file. Finished at: %s", Sys.time()))
  ## ===================================
  print("==========")
  print(sprintf("FACT: There are %s charging stations in %s for a distance of %s metres.",length(OCM$id), country, distance))
  print(sprintf("FACT: Across these, there is a total of %s supply points.",sum(OCM$NumberOfPoints,na.rm = TRUE)))
  print(sprintf("FACT: As well as a total of %s connections allowing simultaneous charging.",sum(OCM$sumOfQuantities,na.rm = TRUE)))
  print(sprintf("FACT: The mean degree of membership for the dominant topic is: %s percent (%s m distance)",mean(topic),distance))
}

build_final_table <- function(country)
{
  print(sprintf("Importing datasets. Starting at %s", Sys.time()))
  OCM <- readRDS(sprintf("%s/OCM.RDS",country))
  terms_200 <- readRDS(sprintf("%s/categories_200.RDS",country))
  terms_400 <- readRDS(sprintf("%s/categories_400.RDS",country))
  terms_600 <- readRDS(sprintf("%s/categories_600.RDS",country))
  LDA_200 <- readRDS(sprintf("%s/LDA_200.RDS",country))
  LDA_400 <- readRDS(sprintf("%s/LDA_400.RDS",country))
  LDA_600 <- readRDS(sprintf("%s/LDA_600.RDS",country))
  
  print(sprintf("Adding number of CS per category. Starting at %s", Sys.time()))
  frequency_200 <- as.vector(as.data.frame(table(OCM$category_200))[,2])
  frequency_400 <- as.vector(as.data.frame(table(OCM$category_400))[,2])
  frequency_600 <- as.vector(as.data.frame(table(OCM$category_600))[,2])
  final_200 <- as.data.frame(lapply(seq_along(terms_200),function(i){c(as.character(terms_200[,i]),frequency_200[i])}))
  final_400 <- as.data.frame(lapply(seq_along(terms_400),function(i){c(as.character(terms_400[,i]),frequency_400[i])}))
  final_600 <- as.data.frame(lapply(seq_along(terms_600),function(i){c(as.character(terms_600[,i]),frequency_600[i])}))
  
  print(sprintf("Renaming columns and rows. Starting at %s", Sys.time()))
  colnames(final_200) <- colnames(terms_200)
  colnames(final_400) <- colnames(terms_400)
  colnames(final_600) <- colnames(terms_600)
  row.names(final_200) <- c("Locality Feature 1", "Locality Feature 2", "Locality Feature 3", "Locality Feature 4", "Locality Feature 5", "Sum of CS/topic")
  row.names(final_400) <- c("Locality Feature 1", "Locality Feature 2", "Locality Feature 3", "Locality Feature 4", "Locality Feature 5", "Sum of CS/topic")
  row.names(final_600) <- c("Locality Feature 1", "Locality Feature 2", "Locality Feature 3", "Locality Feature 4", "Locality Feature 5", "Sum of CS/topic")
  
  print(sprintf("Transpose dataframes. Starting at %s", Sys.time()))
  final_200 <- as.data.frame(t(final_200))
  final_400 <- as.data.frame(t(final_400))
  final_600 <- as.data.frame(t(final_600))
  
  print(sprintf("Adding percentage of importance for each fclass and topic. Starting at %s", Sys.time()))
  top_terms_200 <- tidy(LDA_200, matrix = "beta") %>% group_by(topic) %>% top_n(5, beta) %>% ungroup() %>% arrange(topic, -beta)
  top_terms_400 <- tidy(LDA_400, matrix = "beta") %>% group_by(topic) %>% top_n(5, beta) %>% ungroup() %>% arrange(topic, -beta)
  top_terms_600 <- tidy(LDA_600, matrix = "beta") %>% group_by(topic) %>% top_n(5, beta) %>% ungroup() %>% arrange(topic, -beta)
  top_terms_200$term <- t(as.data.frame(lapply(seq_along(top_terms_200$term),function(i){feature_catalogue$generalisation[match(top_terms_200$term[i], feature_catalogue$catalogue_index)]})))
  top_terms_400$term <- t(as.data.frame(lapply(seq_along(top_terms_400$term),function(i){feature_catalogue$generalisation[match(top_terms_400$term[i], feature_catalogue$catalogue_index)]})))
  top_terms_600$term <- t(as.data.frame(lapply(seq_along(top_terms_600$term),function(i){feature_catalogue$generalisation[match(top_terms_600$term[i], feature_catalogue$catalogue_index)]})))
  
  print(sprintf("Adding placeholder colums for importance values. Starting at %s", Sys.time()))
  for (i in 0:5)
  {
    final_200 <- add_column(final_200, "%" = NA, .after = i+i)
    final_400 <- add_column(final_400, "%" = NA, .after = i+i)
    final_600 <- add_column(final_600, "%" = NA, .after = i+i)
  }
  final_200 <- final_200 %>%  select(c(2:12), 1)
  final_400 <- final_400 %>%  select(c(2:12), 1)
  final_600 <- final_600 %>%  select(c(2:12), 1)
  
  print(sprintf("Filling in importance values. Starting at %s", Sys.time()))
  for (i in 1:length(final_200[,1]))
  {
    prob <- round(top_terms_200[which(top_terms_200$topic == i),]$beta,2) * 100
    count <- round(as.integer(as.character(final_200[i,11]))/length(OCM$id),2) * 100
    prob <- c(prob,count)
    for (j in 1:length(prob))
    {
      final_200[i,j*2] <- prob[j]
    }
  }
  
  for (i in 1:length(final_400[,1]))
  {
    prob <- round(top_terms_400[which(top_terms_400$topic == i),]$beta,2) * 100
    count <- round(as.integer(as.character(final_400[i,11]))/length(OCM$id),2) * 100
    prob <- c(prob,count)
    for (j in 1:length(prob))
    {
      final_400[i,j*2] <- prob[j]
    }
  }
  
  for (i in 1:length(final_600[,1]))
  {
    prob <- round(top_terms_600[which(top_terms_600$topic == i),]$beta,2) * 100
    count <- round(as.integer(as.character(final_600[i,11]))/length(OCM$id),2) * 100
    prob <- c(prob,count)
    for (j in 1:length(prob))
    {
      final_600[i,j*2] <- prob[j]
    }
  }
  
  result <- as.data.frame(bind_rows(final_200, final_400, final_600))
  
  assign(sprintf("%s_final_200",country), final_200, envir = .GlobalEnv)
  assign(sprintf("%s_final_400",country), final_400, envir = .GlobalEnv)
  assign(sprintf("%s_final_600",country), final_600, envir = .GlobalEnv)
  saveRDS(result, file = sprintf("%s/final_overview.RDS",country))
  write.csv(result,sprintf("%s/final_overview.csv",country))
}
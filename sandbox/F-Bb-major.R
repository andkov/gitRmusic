# The purpose of this script is to create a data object (dto) 
# (dto) which will hold all data and metadata from each candidate study of the exercise
# Run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/0-ellis-island.R", output="./manipulation/stitched-output/0-ellis-island.md")
# These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 

# ---- declare-globals ---------------------------------------------------------
filePath <- "./data/shared/raw/musical-notes-frequencies.csv"

# ---- load-data ---------------------------------------------------------------
ds0 <- read.csv(filePath, stringsAsFactors = F)
head(ds0)
# ---- inspect-data -------------------------------------------------------------

# ---- tweak-data ----------------------------------------------


# ---- define-scales ------------------------------------------------------------
ds <- ds0 %>% 
  dplyr::filter(880 >= frequency_hz, frequency_hz >= 82.41) %>% 
  dplyr::mutate(
    string_6 = (82.41  <= frequency_hz & frequency_hz <= 196.00),
    string_5 = (110.00 <= frequency_hz & frequency_hz <= 261.63),
    string_4 = (146.83 <= frequency_hz & frequency_hz <= 349.23 ),
    string_3 = (196.00 <= frequency_hz & frequency_hz <= 466.16 ),
    string_2 = (246.94 <= frequency_hz & frequency_hz <= 587.33 ),
    string_1 = (329.63 <= frequency_hz & frequency_hz <= 783.99  )
  ) %>% 
  dplyr::select(-note_id, -wavelength_cm, -note2)
ds

# ---- define-function-print-on-fret ---------------------
view_fret <- function(ds,object=Fmaj7){
  ds2 <- ds %>%  
    dplyr::mutate( 
      selector = note %in% object, 
      s6 = ifelse(string_6 & selector,note,"."),
      s5 = ifelse(string_5 & selector,note,"."),
      s4 = ifelse(string_4 & selector,note,"."),
      s3 = ifelse(string_3 & selector,note,"."),
      s2 = ifelse(string_2 & selector,note,"."),
      s1 = ifelse(string_1 & selector,note,".") 
    )
  # play = factor(C_major, levels = c(T,F), labels = c("X",".")))    
  ds2
  
  frets <- data.frame("fret" = c("o","I","","","","V","","VII","","","","","XII","","",""))
  
  s6 <- ds2 %>% dplyr::filter(string_6) %>% dplyr::select(s6)
  s5 <- ds2 %>% dplyr::filter(string_5) %>% dplyr::select(s5)
  s4 <- ds2 %>% dplyr::filter(string_4) %>% dplyr::select(s4)
  s3 <- ds2 %>% dplyr::filter(string_3) %>% dplyr::select(s3)
  s2 <- ds2 %>% dplyr::filter(string_2) %>% dplyr::select(s2)
  s1 <- ds2 %>% dplyr::filter(string_1) %>% dplyr::select(s1)
  
  fretboard <- as.data.frame(dplyr::bind_cols(frets, s6, s5, s4,s3, s2, s1, frets))
  # print(fretboard)
  return(fretboard)
  
}

Fmaj7 <- c("F","E", "A", "C")
Gm7 <- c("G", "F", "A-B", "D")
accord <- Fmaj7
knitr::kable(view_fret(ds,accord))





s6 <- ds %>% dplyr::filter(string_6) %>% dplyr::select(note)fretboard



biomarker_name <- paste0(measure_name,"_HIGH")
biomarker_name_wave <- paste0(biomarker_name,"_wave")

a <- lazyeval::interp(~ round(mean(var, na.rm=T),2) , var = as.name(measure_name))
b <- lazyeval::interp(~ var > threashold, var = as.name("person_mean"))
c <- lazyeval::interp(~ var > threashold, var = as.name(measure_name))
dots <- list (a,b,c)

data <- data %>% 
  # dplyr::filter(id %in% ids) %>%
  # dplyr::select_("id", "cholesterol") %>%
  dplyr::group_by(id) %>% 
  dplyr::mutate_(.dots = setNames(dots, c("person_mean", biomarker_name, biomarker_name_wave))) %>% 
  dplyr::ungroup() %>% 
  dplyr::select(-person_mean)
if(!keep_wave){
  data[,biomarker_name_wave] <- NULL
}
return(data)

  
# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------


# ---- collect-meta-data -----------------------------------------
## we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
nl <- names_labels(ds0)
readr::write_csv(nl,"./data/shared/meta/meta-data-live.csv")

# ----- import-meta-data-dead -----------------------------------------
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
meta <- read.csv("./data/shared/meta/meta-data-dead.csv")
meta <- meta %>% dplyr::filter(select==TRUE)
variable_names <- as.character(meta[,"name"])

ds <- ds0 %>% 
  dplyr::select_(.dots = variable_names)
names(ds) <- as.character(meta[,"name_new"])
names(ds) 

# ---- tweak-data --------------------------------------------------------------


# ---- save-to-disk ------------------------------------------------------------

dto <- list()
dto[["UnitData"]] <- ds
dto[['MetaData']] <- meta
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")






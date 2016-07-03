# The purpose of this script is to create a data object (dto) 
# (dto) which will hold all data and metadata from each candidate study of the exercise
# Run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/0-ellis-island.R", output="./manipulation/stitched-output/0-ellis-island.md")
# These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

library(magrittr) # enables piping : %>% 
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.

strings <- structure(list(note_id = c("C0", " C#0/Db0 ", "D0", " D#0/Eb0 ", 
"E0", "F0", " F#0/Gb0 ", "G0", " G#0/Ab0 ", "A0", " A#0/Bb0 ", 
"B0", "C1", " C#1/Db1 ", "D1", " D#1/Eb1 ", "E1", "F1", " F#1/Gb1 ", 
"G1", " G#1/Ab1 ", "A1", " A#1/Bb1 ", "B1", "C2", " C#2/Db2 ", 
"D2", " D#2/Eb2 ", "E2", "F2", " F#2/Gb2 ", "G2", " G#2/Ab2 ", 
"A2", " A#2/Bb2 ", "B2", "C3", " C#3/Db3 ", "D3", " D#3/Eb3 ", 
"E3", "F3", " F#3/Gb3 ", "G3", " G#3/Ab3 ", "A3", " A#3/Bb3 ", 
"B3", "C4", " C#4/Db4 ", "D4", " D#4/Eb4 ", "E4", "F4", " F#4/Gb4 ", 
"G4", " G#4/Ab4 ", "A4", " A#4/Bb4 ", "B4", "C5", " C#5/Db5 ", 
"D5", " D#5/Eb5 ", "E5", "F5", " F#5/Gb5 ", "G5", " G#5/Ab5 ", 
"A5", " A#5/Bb5 ", "B5", "C6", " C#6/Db6 ", "D6", " D#6/Eb6 ", 
"E6", "F6", " F#6/Gb6 ", "G6", " G#6/Ab6 ", "A6", " A#6/Bb6 ", 
"B6", "C7", " C#7/Db7 ", "D7", " D#7/Eb7 ", "E7", "F7", " F#7/Gb7 ", 
"G7", " G#7/Ab7 ", "A7", " A#7/Bb7 ", "B7", "C8", " C#8/Db8 ", 
"D8", " D#8/Eb8 ", "E8", "F8", " F#8/Gb8 ", "G8", " G#8/Ab8 ", 
"A8", " A#8/Bb8 ", "B8"), 
frequency_hz = c(16.35, 17.32, 18.35, 
19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87, 32.7, 
34.65, 36.71, 38.89, 41.2, 43.65, 46.25, 49, 51.91, 55, 58.27, 
61.74, 65.41, 69.3, 73.42, 77.78, 82.41, 87.31, 92.5, 98, 103.83, 
110, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 
174.61, 185, 196, 207.65, 220, 233.08, 246.94, 261.63, 277.18, 
293.66, 311.13, 329.63, 349.23, 369.99, 392, 415.3, 440, 466.16, 
493.88, 523.25, 554.37, 587.33, 622.25, 659.25, 698.46, 739.99, 
783.99, 830.61, 880, 932.33, 987.77, 1046.5, 1108.73, 1174.66, 
1244.51, 1318.51, 1396.91, 1479.98, 1567.98, 1661.22, 1760, 1864.66, 
1975.53, 2093, 2217.46, 2349.32, 2489.02, 2637.02, 2793.83, 2959.96, 
3135.96, 3322.44, 3520, 3729.31, 3951.07, 4186.01, 4434.92, 4698.63, 
4978.03, 5274.04, 5587.65, 5919.91, 6271.93, 6644.88, 7040, 7458.62, 
7902.13), 
wavelength_cm = c(2109.89, 1991.47, 1879.69, 1774.2, 
1674.62, 1580.63, 1491.91, 1408.18, 1329.14, 1254.55, 1184.13, 
1117.67, 1054.94, 995.73, 939.85, 887.1, 837.31, 790.31, 745.96, 
704.09, 664.57, 627.27, 592.07, 558.84, 527.47, 497.87, 469.92, 
443.55, 418.65, 395.16, 372.98, 352.04, 332.29, 313.64, 296.03, 
279.42, 263.74, 248.93, 234.96, 221.77, 209.33, 197.58, 186.49, 
176.02, 166.14, 156.82, 148.02, 139.71, 131.87, 124.47, 117.48, 
110.89, 104.66, 98.79, 93.24, 88.01, 83.07, 78.41, 74.01, 69.85, 
65.93, 62.23, 58.74, 55.44, 52.33, 49.39, 46.62, 44.01, 41.54, 
39.2, 37, 34.93, 32.97, 31.12, 29.37, 27.72, 26.17, 24.7, 23.31, 
22, 20.77, 19.6, 18.5, 17.46, 16.48, 15.56, 14.69, 13.86, 13.08, 
12.35, 11.66, 11, 10.38, 9.8, 9.25, 8.73, 8.24, 7.78, 7.34, 6.93, 
6.54, 6.17, 5.83, 5.5, 5.19, 4.9, 4.63, 4.37), 
note = c("C", 
"C-D", "D", "D-E", "E", "F", "F-G", "G", "G-A", "A", "A-B", "B", 
"C", "C-D", "D", "D-E", "E", "F", "F-G", "G", "G-A", "A", "A-B", 
"B", "C", "C-D", "D", "D-E", "E", "F", "F-G", "G", "G-A", "A", 
"A-B", "B", "C", "C-D", "D", "D-E", "E", "F", "F-G", "G", "G-A", 
"A", "A-B", "B", "C", "C-D", "D", "D-E", "E", "F", "F-G", "G", 
"G-A", "A", "A-B", "B", "C", "C-D", "D", "D-E", "E", "F", "F-G", 
"G", "G-A", "A", "A-B", "B", "C", "C-D", "D", "D-E", "E", "F", 
"F-G", "G", "G-A", "A", "A-B", "B", "C", "C-D", "D", "D-E", "E", 
"F", "F-G", "G", "G-A", "A", "A-B", "B", "C", "C-D", "D", "D-E", 
"E", "F", "F-G", "G", "G-A", "A", "A-B", "B"), 
octave = c(0L, 
0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 
1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
2L, 2L, 2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 4L, 4L, 
4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 4L, 5L, 5L, 5L, 5L, 5L, 
5L, 5L, 5L, 5L, 5L, 5L, 5L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 6L, 
6L, 6L, 6L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 7L, 8L, 
8L, 8L, 8L, 8L, 8L, 8L, 8L, 8L, 8L, 8L, 8L), 
note2 = c("C", "C#/Db", 
"D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", 
"B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", 
"A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", 
"G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", 
"E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", 
"D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", 
"B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", 
"A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", 
"G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", 
"E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B", "C", "C#/Db", 
"D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", 
"B")), 
.Names = c("note_id", "frequency_hz", "wavelength_cm", 
"note", "octave", "note2"), 
class = "data.frame", 
row.names = c(NA,-108L)) 

head(strings)
# ---- define-scales ------------------------------------------------------------
ds <- strings %>% 
  # keep only guitar's range (16 frets)
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
  
  # frets <- data.frame("fret" = c("o","--I--","","","","--V--","","--VII--","","","","","--XII--","","",""))
  # 
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

# Fmaj7 <- c("F","E", "A", "C")
# Gm7 <- c("G", "F", "A-B", "D")
# accord <- Fmaj7
# view_fret(ds,accord)





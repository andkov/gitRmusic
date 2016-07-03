Study of harmony on guitar using data graphics
===

To use [Fret Printer](https://github.com/andkov/gitRmusic/blob/master/print-fret.R) paste the script below into in a [markdown simulator](https://opencpu.ocpu.io/markdownapp/www/).

```r
Print on Fret
=======================

```{r block1, echo=F}
library(dplyr)
source("https://raw.githubusercontent.com/andkov/gitRmusic/master/print-fret.R")
Fmaj7 <- c("F","E", "A", "C")
accord <- Fmaj7
print(view_fret(ds,accord))
```
```


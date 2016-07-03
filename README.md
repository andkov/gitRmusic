Study of harmony on guitar using data graphics
===

To use [Fret Printer](https://github.com/andkov/gitRmusic/blob/master/print-fret.R) paste the script below into in a [markdown simulator](https://opencpu.ocpu.io/markdownapp/www/).

```r

```{r block1, echo=F, message=F}
library(dplyr)
source("https://raw.githubusercontent.com/andkov/gitRmusic/master/print-fret.R")
```

## Fmaj7
```{r, echo=F}
Fmaj7 <- c("F","E", "A", "C")
accord <- Fmaj7
knitr::kable(view_fret(ds,accord), format="markdown",align="c")
```

## Gm7
```{r, echo=F}
Gm7 <- c("G", "F", "A-B", "D")
accord <- Gm7
knitr::kable(view_fret(ds,accord), format="markdown",align="c")
```

```
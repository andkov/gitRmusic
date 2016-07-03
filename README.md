Study of harmony on guitar using data graphics
===

To use [Fret Printer](https://github.com/andkov/gitRmusic/blob/master/print-fret.R) paste the script below into in a [markdown simulator](https://opencpu.ocpu.io/markdownapp/www/).

```

Print on Fret
=======================

```{r block1, echo=F, message=F}
library(dplyr)
source("https://raw.githubusercontent.com/andkov/gitRmusic/master/print-fret.R")
```

```{r block2, echo=T}
Fmaj7 <- c("F","E", "A", "C")
accord <- Fmaj7
knitr::kable(view_fret(ds,accord), format="markdown",align="c")
```


```


---
layout: page
title: Practical 9
permalink: /practical9/
---

# Objectives

The learning objectives for this practical are:

  * Writing R scripts.
  * How to manipulate dates in data.

# Setup and background

To do this practical you need an installation of R and RStudio. You can find
the instructions in the [setup](/setup/) link on how to install R and RStudio
in your system. For a smooth development of this practical, it is strongly
recommended that you follow and finish the previous [practical 8](/practical8/).

We will download some COVID19 data to illustrate the use of R and RStudio.
Please follow the next two steps:

1. Go to the Catalan Health Departament COVID19 data portal at
   [https://dadescovid.cat](https://dadescovid.cat) and switch the language to
   "ENGLISH" using the pull-down menu on the top-right corner of the page.
2. Follow the downloads link and on the next page click and download the file
   corresponding to the "7 DAY AGGREGATION" for "CATALUNYA".
   Make sure you know exactly where in your filesystem this file
   has been downloaded. **Tip:** some browsers automatically download files
   into a folder called "Downloads" or under a name corresponding to the
   translation of "Downloads" to the default language of your operating system.
3. Make a directory in your filesystem, for instance at your _home_ directory,
   called `practical9` and copy in it the downloaded file.
4. Since the downloaded file is a ZIP file, uncompress as you did in
   [practical 1](/practical1/) so that you finally have a file called
   `catalunya_setmanal.csv` in the directory `practical8`.

If you are using the UPF _myapps_ cloud to run RStudio, then you need to
either use an internet browser in _myapps_ to download the data file directly
in the _myapps_ cloud or upload to the _myapps_ cloud the file that you have
downloaded in your own computer.

# Writing R scripts

We may often use an interactive R session to quickly examine data or make some
straightforward calculations. In such an interactive session, we can also recover
previous instructions in the R shell by pressing the `upwards arrow` key. However,
if we really want to keep track of the R commands we are using, we should write
them in a text file with filename extension `.R`, which we shall refer hereafter
as an _R script_. 

There are two main ways to create an R script: (1) openining a new file with a
text editor and saving it with filename that includes the `.R` extension, or (2)
if we are working with RStudio, then we click on the `File` menu and select
the options `New File` -> `R Script`. When we do that we should be getting the
RStudio window splitted in four panes, the default three ones and one additional
one for the newly created R script, as shown in the captured window below.

![](RStudioNewScript.png)

Type in the newly created R script (either with a text editor or with RStudio)
the following two lines to read the CSV file downloaded in the previous section.
The first line is a comment. Lines starting with the `#` symbol are comments in R.

```
## read COVID19 data
dat <- read.csv("catalunya_setmanal.csv")
```

Now save the R script in the directory `practical9` under the filename
`covid19analysis.R`.

To execute a specific line of an R script in RStudio you should move the cursor
to that line in the pane with the script file and press the key combination
`Ctrl+Enter`. Alternatively, you can also copy and paste the line from the script
to the R shell, specially if you are not working with RStudio.

The previous line may produce an error if the current working directory of
R is not pointing to the directory where the file `catalunya_setmanal.csv` is;
see previous [practical 8](/practical8/) if you need to find out how to change
the working directory in R and RStudio. In general, changing the working directory
should be always performed in the R shell and never include the instruction that
changes the working directory in an R script. The reason is because you or somebody
else may want to run that script in a different computer where the directory with
the data may be called differently.

Add to the script `covid19analysis.R` the necessary code to obtain a new `data.frame`
object including only data from the general population, i.e., excluding data from
geriatric residences.

# Date-data management

These are the first 6 rows of the previously loaded CSV file:

```
> head(dat)
        NOM      CODI   DATA_INI    DATA_FI RESIDENCIA IEPG_CONFIRMAT
1 CATALUNYA CATALUNYA 2020-11-01 2020-11-07         --             NA
2 CATALUNYA CATALUNYA 2020-11-01 2020-11-07         Si             NA
3 CATALUNYA CATALUNYA 2020-11-01 2020-11-07         No        611.099
4 CATALUNYA CATALUNYA 2020-10-31 2020-11-06         --             NA
5 CATALUNYA CATALUNYA 2020-10-31 2020-11-06         Si             NA
6 CATALUNYA CATALUNYA 2020-10-31 2020-11-06         No        641.672
  R0_CONFIRMAT_M      IA14 TAXA_CASOS_CONFIRMAT CASOS_CONFIRMAT TAXA_PCR_TAR
1             NA    0.0000               0.0000             529        0.000
2             NA 2798.2745            1396.7672             884    16680.624
3       0.880132  694.3272             306.0293           23372     3137.612
4             NA    0.0000               0.0000             546        0.000
5             NA 2844.0961            1439.4286             911    17522.792
6       0.906287  708.0233             317.5911           24255     3213.137
     PCR   TAR PERC_PCR_TAR_POSITIVES INGRESSOS_TOTAL INGRESSOS_CRITIC EXITUS
1   3582   166                 7.3237              68               15      0
2   8469  2088                10.4550             114                5    139
3 178471 61154                10.7314            1512              295    312
4   3890   164                 7.0030              71               14      0
5   8937  2153                10.1535             114                6    153
6 184715 60678                10.8609            1578              279    315
```

It has two columns with date information (`DATA_INI` and `DATA_FI`), but which
are stored as string characters (more specifically _factors_). However, R
provides a way to store dates as such and this has the advantage that
facilitates manipulating them for analysis purposes.

For instance, to two transform the two columns containing date data we should
use the function `as.Date()` as follows:

```
> startdate <- as.Date(dat$DATA_INI)
> enddate <- as.Date(dat$DATA_FI)
```

While R displays these objects as vectors of character strings, they do belong to
a different class of objects, the class _Date_.

```
> head(startdate)
[1] "2020-11-01" "2020-11-01" "2020-11-01" "2020-10-31" "2020-10-31" "2020-10-31"
> class(startdate)
[1] "Date"
> head(enddate)
[1] "2020-11-07" "2020-11-07" "2020-11-07" "2020-11-06" "2020-11-06" "2020-11-06"
> class(enddate)
[1] "Date"
```

Having dates stored as _Date_-class objects facilitates operations on dates such
as calculating time differences:

```
> head(enddate - startdate + 1)
Time differences in days
[1] 7 7 7 7 7 7
```
or extracting the month of each date:

```
> month <- months.Date(startdate))
> head(month)
[1] "November" "November" "November" "October"  "October"  "October" 
> class(month)
[1] "character"
```

# Factors

Factors in R are a class of objects that serves the purpose of storing what
is known in statistics as a
[categorical variable](https://en.wikipedia.org/wiki/Categorical_variable),
which is a variable that takes values from a limited number of _categories_,
also known as _levels_. So factors are pretty much like vectors of character
strings, but with additional information about what are the different values
that may ocurr on those vectors.

Not all vectors of character strings are suitable to become factors. For
instance, a vector of character strings corresponding to gene identifiers
tipically should not become a factor in R, because those identifiers do not
represent any kind of _category_ grouping observations.

Factors are useful, however, in the context of a statistical analysis and
data visualization, involving categorical variables. To create a factor
object we should call the function `factor()` giving a vector of character
strings as argument. Let's consider converting the previous vector `month`
of character strings to a factor.

```
> monthf <- factor(month)
> head(monthf)
[1] November November November October  October  October 
10 Levels: April August February July June March May November ... September
```
We can see that R displays factors differently to character strings, by
showing the values without double quotes (`"`) and providing additional
information about the possible _levels_ of that factor. We can access the
level information from a factor object with the functions `levels()` and
`nlevels()`.

```
> levels(monthf)
 [1] "April"     "August"    "February"  "July"      "June"      "March"    
 [7] "May"       "November"  "October"   "September"
> nlevels(monthf)
[1] 10
```

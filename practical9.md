---
layout: page
title: Practical 9
permalink: /practical9/
---

# Objectives

The learning objectives for this practical are:

  * Writing R scripts.
  * How to manipulate dates in data.
  * How to create and use factor objects.
  * How to create and use list objects.
  * How to perform implicit looping through lists.
  * Learn visualizing data in different ways.

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
> m <- months(startdate, abbreviate=TRUE))
> head(m)
[1] "Nov" "Nov" "Nov" "Oct" "Oct" "Oct"
> class(m)
[1] "character"
```
where we have use the argument `abbreviate=TRUE` in the `months()` function
to obtain a vector of equally sized character strings, which may be useful
for visualization purposes.

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
strings as argument. Let's consider converting the previous vector `m`
of character strings to a factor.

```
> mf <- factor(m)
> head(mf)
[1] Nov Nov Nov Oct Oct Oct
Levels: Apr Aug Feb Jul Jun Mar May Nov Oct Sep
```
We can see that R displays factors differently to character strings, by
showing the values without double quotes (`"`) and providing additional
information about the possible _levels_ of that factor. We can access the
level information from a factor object with the functions `levels()` and
`nlevels()`.

```
> levels(mf)
 [1] "Apr" "Aug" "Feb" "Jul" "Jun" "Mar" "May" "Nov" "Oct" "Sep"
> nlevels(mf)
[1] 10
```
Sometimes, we may want the levels of a factor to comprise a set of specific
values or to be ordered in a specific way. This could be the case of the
previous factor `mf`, where we would like for instance to have the
levels corresponding to the months of the year. We can do that as follows:

```
> mf <- factor(m, levels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
> head(mf)
[1] Nov Nov Nov Oct Oct Oct
Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
> levels(mf)
 [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"
> nlevels(mf)
[1] 12
```
We can build a contingency table of the level occurrences of a factor
using the function `table()`.

```
> table(mf)
mf
Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec 
  0  18  93  90  93  90  93  93  90  93   3   0
```
We can see, there is no data in 2020 for the months of January (because
data was not yet recorded) and December (because it was November at the
time of elaborating this practical). We can remove levels of a factor
for which there is no data with the function `droplevels()`.

```
> mf <- droplevels(mf)
> levels(mf)
 [1] "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov"
> table(mf)
mf
Feb Mar Apr May Jun Jul Aug Sep Oct Nov 
 18  93  90  93  90  93  93  90  93   3 
```

Add the necessary lines of code to the script `covid19analysis.R` to
create a factor object with the months in which each data row was
recorded in the general population, i.e., excluding data from geriatric
residences. Using this factor we can easily visualize the distribution
of the columns `R0_CONFIRMAT_M` (R0 basic reproduction number) and
`IEPG_CONFIRMAT` (risk of outbreak) in the general population, as
function of the month, calling plot with the formula notation `x ~ y`:

```
> plot(datg$R0_CONFIRMAT_M ~ mf)
```
where here `datg` refers to the subset of the original `data.frame`
object `dat`, excluding data from geriatric residences, and `mf` refers
to the factor object with the months from that subset of data. The resulting
plot contains so-called [box plots](https://en.wikipedia.org/wiki/Box_plot)
for each month, which allow to visualize the location of the data in terms
of [quartiles](https://en.wikipedia.org/wiki/Quartile).

Once you have obtained the plot, look up in the help page of the `plot()`
function, how can you change the labels for the `x` and `y` axes to a more
readable label. The resulting plot should be similar to the one below.

![](R0byMonth.png)

We can see that February has no data points for the column `R0_CONFIRMAT_M`
despite there are data rows for that month. To find out why we do not see
any data on the plot we can inspect the values of `R0_CONFIRMAT_M` for
the month of February as follows:

```
> datg$R0_CONFIRMAT_M[mf == "Feb"]
[1] NA NA NA NA NA NA
```
The value `NA` in R means _not available_ and R treats it in a special
way depending on the operation that is performing. In the case of plots, `NA`
values are ignored.

Plot now the risk of outbreak as function of the month, can you
identify the month in which this risk has increased the most? Add the two
plotting instructions to the `covid19analysis.R` script.

# Lists and implicit looping

Lists allow one to group values through their elements. Let's say we want
to group the values of the risk of outbreak in the previous data, by the
month in which the data belongs to. We can do that using the function
`split()` to which we should give a first argument of the values we want
to group and a second argument with the grouping factor.

```
> iepgbymonth <- split(datg$IEPG_CONFIRMAT, mf)
> class(iepgbymonth)
[1] "list"
> length(iepgbymonth)
[1] 10
> names(iepgbymonth)
 [1] "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov"
> head(iepgbymonth, n=3)
$Feb
[1] NA NA NA NA NA NA

$Mar
 [1] 154.523 168.052 176.403 188.101 206.879 225.887 245.803 263.842 275.744
[10] 289.553 309.236 349.668 374.001 392.650 410.941 411.181 445.455 452.179
[19] 398.809 346.643 284.823 225.282 144.230 107.113      NA      NA      NA
[28]      NA      NA      NA      NA

$Apr
 [1]  24.1050  26.1615  28.3733  31.1514  33.6115  36.4087  42.9276  46.9114
 [9]  51.8729  57.1702  61.3704  64.4527  68.6624  71.0281  76.4523  78.9826
[17]  82.4250  86.9431  87.4165  86.3060  87.9184  92.1927  98.2542 105.1500
[25] 118.3170 121.8560 124.6690 130.1430 136.0640 144.0100
```

Grouping values can be useful in data analysis when we want to examine the
data separately by groups. Let's say we want to visualize the distribution
of values of the risk of outbreak for the month of April and June, next to
each other. We can use the function `hist()` for that purpose, creating a
grid of two plotting panes using the `par()` function, as follows:

```
> par(mfrow=c(1, 2))
> hist(iepgbymonth$Apr, xlab="Risk of outbreak", main="April")
> hist(iepgbymonth$Jun, xlab="Risk of outbreak", main="June")
```

![](IEPGAprilJune.png)

Now, let's calculate the mean of the risk of outbreak for the month of April.
Having built the previous `list` object, we can make that calculation applying
the function `mean()` to the corresponding element of the list:

```
> mean(iepgbymonth$Apr)
[1] 76.71023
```
Let's say we want to compare this value with the mean value for the month of
March:

```
> mean(iepgbymonth$Mar)
[1] NA
```
Here we got an `NA` value because the month of March has missing values for
some weeks and, by default, the function `mean()` propagates that `NA` value
to the result. We can ask the `mean()` function to exclude `NA` values and
do the calculation on the non-missing ones using the argument `na.rm=TRUE`:

```
> mean(iepgbymonth$Mar, na.rm=TRUE)
[1] 285.2916
```
It would be tedious to do that calculation for each different month by
writing one such function call for each element of the list. As an alternative,
we could use a `while` or `for` loop that would iterate over the elements of
the list. However, R provides a more compact way to iterating over lists,
and other objects, by using functions for _implicit_
[looping](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#Looping)
such as `lapply()` or `sapply()`. These functions take a list as a first argument,
iterate through each element of that list, and at each iteration apply the function
given in the second argument. Additional arguments can be given and will be passed
to the _applied_ function.

The function `lapply()` returns again the input list with its elements replaced
by the result given by the function on each corresponding element, while the
function `sapply()` attempts to simplify the resulting data structure in that if
each element of the resulting list has length 1, then it return an atomic vector.

We can calculate the mean of the risk of outbreak per month with the following
call to the `sapply()` function:

```
> sapply(iepgbymonth, mean, na.rm=TRUE)
      Feb       Mar       Apr       May       Jun       Jul       Aug       Sep 
      NaN 285.29158  76.71023  25.66524  20.77437 153.58826 190.42042 207.93477 
      Oct       Nov 
702.40661 607.29200 
```
where here the argument `na.rm=TRUE` is passed by `sapply()` to each call to
the `mean()` function. Try the same call using the `lapply()` function and
notice the difference in the output.

Plot the distribution of the number of deaths (column `EXITUS`) per month in
the general population (using box plots). Calculate the mean of the number of
deaths per month in the general population and plot it over the previous box
plots using the function `points()`. Check the help page of `point()` to find
out how to use it, figure out how make the plotted point to be a solid diamond
(**hint:** look at the argument `pch`).

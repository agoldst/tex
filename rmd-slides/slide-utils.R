# ---- dark-plot-theme ----
plot_theme <- function(base_size=9, base_family="",
                       dark="gray10", light="white") {
  theme_grey(base_size=base_size, base_family=base_family) %+replace%
    theme(
      # Specify axis options
      axis.line=element_blank(), 
      axis.text.x=element_text(size=base_size*0.8, color=light,
                               lineheight=0.9, vjust=1), 
      axis.text.y=element_text(size=base_size*0.8, color=light,
                               lineheight=0.9, hjust=1), 
      axis.ticks=element_line(color=light, size = 0.2), 
      axis.title.x=element_text(size=base_size, color=light, vjust=0),
      axis.title.y=element_text(size=base_size, color=light, angle=90,
                                vjust=0.5), 
      axis.ticks.length=grid::unit(0.3, "lines"), 
      axis.ticks.margin=grid::unit(0.5, "lines"),
      # Specify legend options
      legend.background=element_rect(color=NA, fill=dark), 
      legend.key=element_rect(color=light, fill=dark), 
      legend.key.size=grid::unit(1.2, "lines"), 
      legend.key.height=NULL, 
      legend.key.width=NULL,     
      legend.text=element_text(size=base_size * 0.8, color=light), 
      legend.title=element_text(size=base_size * 0.8, color=light), 
      legend.text.align=NULL, 
      legend.title.align=NULL, 
      legend.position="bottom",
      legend.box=NULL,
      # Specify panel options
      panel.background=element_rect(fill=dark, color = NA), 
      panel.border=element_rect(fill=NA, color=light), 
      panel.grid.major=element_line(color="gray20"), 
      panel.grid.minor=element_blank(), 
      panel.margin=grid::unit(0.25, "lines"),  
      # Specify facetting options
      # TODO color mixing instead of hard-coding here
      strip.background=element_rect(fill="gray40",color="gray20"), 
      strip.background=element_rect(fill=dark,color=light), 
      strip.text.x=element_text(size=base_size * 0.8, color=light), 
      strip.text.y=element_text(size=base_size * 0.8, color=light,
                                angle=-90), 
      # Specify plot options
      plot.background=element_rect(color=dark,fill=dark), 
      plot.title=element_text(size=base_size*1.2,color=light), 
      plot.margin=grid::unit(c(1,1,0.5,0.5),"lines")
    )
}


# ---- print-tabular ----

# print LaTeX commands for typesetting a data frame as a table
#
# x: a data frame. Convert matrices and contingency tables yourself.
#
# digits: the number of digits after the decimal point.
#
# alignment: a single-element character vector giving the sequence of   
# column alignments according to the `tabular` syntax (`l`, `c`, `r`    
# for left, center, right, and `p{dim}` for text wrapped in a box of    
# width `dim`---for example `p{2 in}`). By default numeric columns are  
# right aligned and the rest are left aligned.                          
#
# include.colnames: whether to print the data frame column names
# as column headers. It often makes sense to assign something
# human-friendly to the column names first (in `dplyr` syntax, ``frm
# %>% rename(`length in words`=len)``). This function assumes you never
# want to print rownames. Keeping anything interesting in the rownames
# of a data frame is a bad idea anyway. If you want rownames, add a data
# column on the front instead.
#
# floating, caption: whether just to drop the table in the flow of text
# or to put it in a LaTeX environment like `table`. `floating=T` is
# probably what you want, with a `caption` specified; beamer centers
# floating tables on slides as you'd hope.
#
# label: the LaTeX label of the table (if `floating=T`), so that you can
# refer to the table number---but why do that in a talk?
#
# ...: the rest of the parameters are passed on to `print.xtable`.

print_tabular <- function (x, digits=0,
                           alignment=paste(ifelse(sapply(x, is.numeric),
                                                  "r", "l"),
                                           collapse=""),
                           include.colnames=T,
                           floating=F, caption=NULL, label=NULL,
                           ...) {
    if (length(alignment) != 1 || !is.character(alignment)) {
        stop("alignment must be a character vector of length 1")
    }
    if (nchar(alignment) == 1) {
        alignment <- paste(rep(alignment, length(x)), collapse="")
    }
    if (!is.data.frame(x)) {
        stop("x is not a data frame")
    }

    # xtable always wants an alignment char for the rownames
    alignment <- paste("l", alignment, sep="")
    xt <- xtable(x, digits=digits, align=alignment,
                 caption=caption, label=label)
    print(xt, comment=F, include.rownames=F,    # no row names, ever
          include.colnames=include.colnames,
          floating=floating, booktabs=T,
          tabular.environment=ifelse(floating, "tabular", "longtable"),
          ...)
}


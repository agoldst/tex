## ---- code-hook ----
 
# code output environment hook
knit_hooks$set(output=function (x, options) {
    paste(c("\\begin{ROutput}",
            sub("\n$", "", x),
            "\\end{ROutput}",
            ""),
          collapse="\n")
})

## ---- plot-placement-hook ----
 
# Plot placement and resizing hook
#
# Allows you to use the textpos grid for placing and sizing plots on
# slides. Example usage below.
#
# This gives us some new options and changes the meaning of two others:
#
# out.width, out.height: reinterpreted as units on the textpos grid.
# N.B. this sets the scaling by pdflatex of an image file whose
# generated dimensions are set by fig.width and fig.height (always
# inches).
#
# textblock_width: width of the block in textpos grid units
#
# textblock_pos: 2-element vector of grid coordinates of the textblock
#
# center: Boolean: enclose graphic within center environment?
#
# inside_textblock: don't generate textblock environment, just the
# \includegraphics line (useful if, e.g., you write out the environment
# \begin and \end yourself and stick the code chunk between them)
#
# Grid positioning only happens if inside_textblock=T or textblock_width
# is specified. Otherwise we revert to knitr's normal behavior. Grid
# positioning also always makes graphics inline. Use inside_textblock=T
# and enclose it in a figure environment yourself if you want to combine
# the textblock and the figure environment (you probably don't).
#
# The main use for this is probably to place a single figure on the grid
# instead of in the normal flow of elements.
#
# N.B. the default knitr plot output hook for LaTeX responds to many
# more options than this does. But in my workflow we are knitting to
# markdown, not LaTeX. That's a simplifying decision in some ways but
# with some costs in flexibility.

plot_hook_default <- knit_hooks$get("plot")
knit_hooks$set(plot=function (x, options) {
    inside <- options$inside_textblock
    pos <- options$textblock_pos
    b <- ""
    e <- ""
    if (is.null(inside)) {
        inside <- F
    }
    if (is.numeric(options$textblock_width) || inside) {
        if(!inside && is.numeric(pos) && length(pos) == 2) {
            b <- paste0(
                "\\begin{textblock}{", options$textblock_width, "}(",
                pos[1], ",", pos[2], ")\n"
            )
            e <- "\\end{textblock}\n"
        }

        if (!is.null(options$center) && options$center) {
            b <- paste0(b, "\\begin{center}\n")
            e <- paste0("\n\\end{center}", e)
        }

        if (is.null(options$out.width) && is.null(options$out.height)) {
            opt <- ""
        } else if (is.null(options$out.width)) {
            opt <- paste0("[height=", options$out.height, "\\TPVertModule]")
        } else if (is.null(options$out.height)) {
            opt <- paste0("[width=", options$out.width, "\\TPHorizModule]")
        } else {
            opt <- paste0("[width=", options$out.width, "\\TPHorizModule],",
                          "[height=", options$out.height, "\\TPVertModule]")
        }

        # filename munging here taken from knitr:::hook_plot_md_base
        # just in case this will help with rmarkdown's file management
        base_url <-opts_knit$get("base.url")
        if (is.null(base_url)) {
            base_url <- ""
        }
        gfx <- paste0("\\includegraphics", opt, "{", base_url, x, "}\n")
        paste0(b, gfx, e)
    }
    else {
        plot_hook_default(x, options)
    }
})


## ---- dark-plot-theme ----

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


## ---- print-tabular ----

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
    ll <- print(xt, comment=F, include.rownames=F,    # no row names, ever
                include.colnames=include.colnames,
                floating=floating, booktabs=T,
                tabular.environment=ifelse(floating, "tabular", "longtable"),
                print.results=F,
                ...)
    # xtable latex captured and returned this way so that you don't need to
    # set results="asis" in the chunk options
    knitr::asis_output(paste(ll, collapse="\n"))
}




# ---- print-lm ----

# a shortcut for printing out linear models as tables

print_lm <- function (...) {
    p <- list(dep.var.caption="",
              omit.stat=c("ser"),   # no residual SE, but keep F
              omit.table.layout="n",
              table.placement="H",
              single.row=T,
              header=F,
              report="vscp")
    dots <- list(...)
    p[names(dots)] <- dots

    # stargazer is irresponsible and directly `cat`s its output
    sgz <- capture.output(do.call(stargazer, p))
    # this function, from knitr, shortcuts the need to set `results="asis"`
    knitr::asis_output(paste(sgz, collapse="\n"))
}


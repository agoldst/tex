% mythesis.cls, modified from yalephd.cls
%
% By Andrew Goldstone http://andrewgoldstone.com
% This file may be freely used and modified by anyone.
%
% Last change: March 10, 2012:
% These introductory comments added.
%
% ORIGINAL HEADER FOLLOWS
%
% LaTeX2e document class that meets format requirements (as of March
% 2000) for a doctoral dissertation to be submitted to Yale University,
% Graduate School of Arts and Sciences.
%
% Version 1.0   1996/03/15  Initial release (as yalethesis.cls)
%
%   James Szinger, Yale ACS/SECF, March 1996
%   James.Szinger@Yale.Edu
%
% Version 2.0   2000/03/15      Minor changes in Yale GS requirements.
%
%   Una Smith, Dept. of Ecology and Evolutionary Biology, March 2000
%   una.smith@yale.edu
%
% END OF ORIGINAL HEADER
%
% My modifications 2009/06/03
% Cleaned up the layout code by using the geometry package.
% Added correct footnote format.
% Changed \makecopyright to take one argument, the year; fall           
% dissertations should have be copyright next year, not this year.      
% Layout should be in conformity with the October 2006 Yale GSAS        
% "Preparation and Submission of the Doctoral Dissertation."            
%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% User documentation:
%
% First, get a copy of the booklet "Preparation and submission of the
% Doctoral Dissertation" from the Graduate School.  Then, ask your
% department and advisor if there any other requirements.
%
% This class conforms to the Graduate School's current requirements
% (as of March 2000), in the sense that it was accepted without any
% quibbles.  However, requirements change, so check the fine print.
% Also, some departments may have additional requirements which are
% not included in this class.
%
% Since ultimate responsibility rests with you, the candidate, you
% should verify that the resulting dissertation meets requirements of
% your department and the Graduate School.
%
% 12pt type is easiest to read.  Please be kind to your readers.
%
% Here's an outline of how to use this class in the file example.tex:
%
% The preamble should use the \author command to set the author's
% name, the \date command to set the month and year the degree will be
% awarded, and the \advisor command to set the name of the dissertation
% advisor.
%
% The front matter should have (in this order):
%   abstract
%   title page
%   copyright notice page
%   table of contents
%   list of figures, if any (order of lists is optional)
%       list of tables, if any
%       acknowledgments (optional)
%       glossary (optional)
%
% A dedication may also be included in the front matter, presumably
% after the copyright notice page and before the table of contents.
%
% The abstract environment and the \maketitle command of the standard
% LaTeX book class are redefined to meet Graduate School requirements.
% A \makecopyright command is provide to create the copright notice.
%
% The body is standard LaTeX stuff.
%
% The appendices (if any) and bibliography are the end matter.  The
% style of the bibliography is left to you.
%
% There is a new class option 'draft' which you may find useful.  It
% places on the title page and in the page headings the current date
% and a message indicating that the copy is a draft.  This is helpful
% when you're editing and have several drafts scattered about.
%
% Summary:
%
% Just like the book document class but
%
% class options: draft adds `draft of \today' to page heading
%                      and title page
%                twopage, twocolumn, landscape and papersize
%                      options are ignored
%
% abstract environment redefined to have Yale heading.
%
% \maketitle produces Yale title page
%
% \mainmatter resets paging for the body.
%
% \advisor command to set the name of the dissertation advisor
%
% \makecopyright{YEAR} command to produce the copyright page.
%
% The standard \date command should be used to set the month and year
% the degree is to be awarded.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{mythesis}[2009/06/01 Yale doctoral dissertation
class, modified by AG]

% Warn user that the following options are ignored because they
% are disallowed by the Yale Graduate School:
%
\DeclareOption{legalpaper}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `letterpaper'.}}
\DeclareOption{executivepaper}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `letterpaper'.}}
\DeclareOption{a4paper}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `letterpaper'.}}
\DeclareOption{a5paper}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `letterpaper'.}}
\DeclareOption{b5paper}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `letterpaper'.}}
\DeclareOption{twoside}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `oneside'.}}
\DeclareOption{twocolumn}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `onecolumn'.}}
\DeclareOption{landscape}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `portrait'.}}
\DeclareOption{notitlepage}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `titlepage'.}}
\DeclareOption{openright}{\PackageWarning{yalephd}%
{Option `\CurrentOption' ignored.  Must use `openany'.}}

% Class option for draft mode -- Puts Date on page headings.
\newif\ifdraft\draftfalse
\DeclareOption{draft}{\drafttrue}

% What to do with other options?  Pass them on to book.cls.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\PassOptionsToClass{onecolumn}{book}
\PassOptionsToClass{oneside}{book}
\PassOptionsToClass{letterpaper}{book}
\PassOptionsToClass{openany}{book}

\ProcessOptions\relax

\LoadClass{book}


%--------------------------------------------------------------------
% Physical layout of the page: 1.5" left margin, all others 1".
% Double spacing, including between (but not within) footnotes.
% Chicago-style footnote format: the number within the note is
% not superscript.
%--------------------------------------------------------------------

% In the book class, first pages of chapters and title pages            
% automatically invoke the plain page style. But actually I'm fine with 
% those pages and the rest of the body having the same page style, with 
% the number at bottom center.                                          

\pagestyle{plain}

\RequirePackage{geometry}
\geometry{left=1.5 in, right=1 in, top=1 in,bottom=1.0 in,nohead,footskip=0.5 in}


\RequirePackage{setspace}
\doublespacing

\renewcommand\@makefntext[1]{% 
    \parindent 1em% 
    \@thefnmark.~#1%
    \vspace{1em}} 

% All section headings at normal size font, with spacing copied from the
% book.cls defaults for subsubsection

%\renewcommand\section{\@startsection{section}%
	%{1}{0 in}%
	%{-3.25ex\@plus -1ex \@minus -.2ex}%
	%{1.5ex \@plus .2ex}%
	%{\normalfont\normalsize\bfseries}}



%--------------------------------------------------------------------
% Define abstract environment, because book class doesn't have one.
%--------------------------------------------------------------------

\newenvironment{abstract}{%
  \begin{titlepage}%
    \pagestyle{empty}%
    \begin{center}
      {\bf Abstract}\par\bigskip
      {\Large \bf \@title}\par\bigskip
      \@author \\
      \the\year
      \end{center}%
  }{\end{titlepage}}


%--------------------------------------------------------------------
% \advisor{}
%--------------------------------------------------------------------

\newcommand{\advisorline}[1]{\gdef\@advisorline{#1}}
\def\advisor#1{\gdef\@dvisor{#1}}
\def\@dvisor{\@latex@warning@no@line{No \noexpand\advisor given}}


%--------------------------------------------------------------------
% Customize \maketitle
%--------------------------------------------------------------------

\renewcommand\maketitle{\begin{titlepage}%
  \null \vskip 40\p@
  \begin{center}%
    {\LARGE\bf \@title \par}%
    \vfil
    \begin{singlespace}
    {\large
               A Dissertation\\
      Presented to the Faculty of the Graduate School\\
                 of\\
              Yale University\\
           in Candidacy for the Degree of\\
         Doctor of Philosophy\par\vfil\vskip 6ex%
                 by\\
              \@author\par\vskip 1.5em%
         \@advisorline\par
    }\vskip 1.5em%
    {\large \@date \par
    \ifdraft Draft of \today\par\fi
    }%
  \end{singlespace}
  \end{center}
  \end{titlepage}%
  \global\let\maketitle\relax
  \global\let\title\relax
  \global\let\author\relax
  \global\let\advisor\relax
  \global\let\date\relax
  \global\let\and\relax
\pagestyle{plain}      % Page numbers at bottom center.
\pagenumbering{roman}  % roman numerals.
\addtocounter{page}{1} %This is page i, but not shown -- Next page is ii.
}


%--------------------------------------------------------------------
% \makecopyright
%--------------------------------------------------------------------

\newcommand{\makecopyright}[1]{%
  \hbox{\hfil}\vspace{4in}\begin{center}
  Copyright \copyright\ #1 by \@author \\
  All rights reserved.
  \end{center}
  \clearpage
}%


% EOF

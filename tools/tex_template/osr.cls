\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{osr}[2023/06/12 class For my own RPG publication]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[10pt, a5paper]{report}
% force correct page layout : small margins
\RequirePackage[]{geometry}
\geometry{
  a5paper,
  left=7mm,
  right=7mm,
  top=7mm,
  bottom=9mm,
  footskip=15pt
}
\RequirePackage{parskip}

%% check that xelatex is used (for font definition)
\RequirePackage{iftex}
\RequireXeTeX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FONTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{fontspec}
\RequirePackage{PTSansNarrow}
\renewcommand*\familydefault{\sfdefault}
\RequirePackage[T1]{fontenc}

\newfontfamily\ButchSundanceExp{ButchSundanceExpanded}[
Path = fonts/butchSundance/,
Extension      = .ttf,
UprightFont    = butchsundanceexpand,
]

\newfontfamily\ButchSundance{ButchSundance}[
Path = fonts/butchSundance/,
Extension      = .ttf,
UprightFont    = butchsundance,
BoldFont = butchsundancebold,
ItalicFont = butchsundanceital,
BoldItalicFont = butchsundanceboldital,
]

\newfontfamily\ButchSundancePlat{ButchSundancePlatinum}[
Path = fonts/butchSundance/,
Extension      = .ttf,
UprightFont    = butchsundanceplat,
]

\let\titlefont\ButchSundancePlat
\let\chapterfont\ButchSundanceExp
\let\sectionfont\ButchSundanceExp


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COLORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\PassOptionsToPackage{usenames,dvipsnames,x11names,table}{xcolor} % required to avoid option clash in color and table
\RequirePackage{xcolor}

\definecolor{osrBlue}{HTML}{809bce}
\definecolor{osrLightBlue}{HTML}{95b8d1}
\definecolor{osrGreen}{HTML}{b8e0d2}
\definecolor{osrLightGreen}{HTML}{d6eadf}
\definecolor{osrRed}{HTML}{eac4d5}

\definecolor{marron}{RGB}{60,30,10}
\definecolor{darkblue}{RGB}{0,0,80}
\definecolor{lightblue}{RGB}{80,80,80}
\definecolor{darkgreen}{RGB}{0,80,0}
\definecolor{darkgray}{RGB}{0,80,0}
\definecolor{darkred}{RGB}{80,0,0}
\definecolor{shadecolor}{rgb}{0.97,0.97,0.97}

\definecolor{primarycolor}{named}{osrBlue}
\definecolor{secondarycolor}{named}{osrLightBlue}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% HEADER/FOOTER FORMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{fancyhdr}
\RequirePackage{fourier-orns}

\newcommand*\circled[1]{\tikz[baseline=(char.base)]{
    \node[shape=circle,draw,inner sep=2pt] (char) {#1};}}

\fancyhf{}

\fancyfoot[C]{
  \noindent \textcolor{secondarycolor}{%
    \raisebox{-2.2pt}[10pt][10pt]{\decoone \floweroneright \decotwo \aldineleft \decothreeright \decofourright \leafleft}%
    \hrulefill\raisebox{-3pt}[10pt][10pt]{\small{\circled{\textcolor{primarycolor}\thepage}}}\hrulefill%
    \raisebox{-2.2pt}[10pt][10pt]{\leafright \decofourleft \decothreeleft  \aldineright \decotwo \floweroneleft \decoone}%
  }
}

% Redefine the plain page style
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{
    \noindent \textcolor{secondarycolor}{%
      \raisebox{-2.2pt}[10pt][10pt]{\decoone \floweroneright \decotwo \aldineleft \decothreeright \decofourright \leafleft}%
      \hrulefill\raisebox{-3pt}[10pt][10pt]{\small{\circled{\textcolor{primarycolor}\thepage}}}\hrulefill%
      \raisebox{-2.2pt}[10pt][10pt]{\leafright \decofourleft \decothreeleft  \aldineright \decotwo \floweroneleft \decoone}%
    }
  }
}

\pagestyle{fancy}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SECTION FORMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[compact,explicit]{titlesec}
\RequirePackage{tikz}
\usetikzlibrary{calc, positioning}
\RequirePackage[export]{adjustbox}
\RequirePackage{multicol}
\RequirePackage{etoolbox}

\newcommand{\ifmulticolEnd}{%
  \def\test{multicols}%
  \ifx\@currenvir\test
    \end{multicols}%
  \else
  \fi
}

\newcommand{\ifmulticolStart}{%
  \def\test{multicols}%
  \ifx\@currenvir\test
  \else
    \begin{multicols}{2}
  \fi
}

\AtEndDocument{\ifmulticolEnd}

\titleformat{\chapter}[hang]%
{
  {\color{secondarycolor}\titlerule[3pt]}%
  \filcenter\color{primarycolor}\chapterfont\fontsize{50pt}{60pt}\selectfont
}% format
{}% label
{0pt}% sep
{#1}% before code
[%
  {\color{secondarycolor}\titlerule[3pt]}%
]% after code

\titlespacing{\chapter}
{0pt}% left
{-5pt}% before sep
{-10pt}% after sep

\let\oldchapter\chapter
%\makeatletter
\def\chapter{\@ifnextchar*{\oldchapter}\customchapter}% handle \chapter*

\newcommand{\customchapter}[1]{
  \ifmulticolEnd
  \oldchapter{#1}
  \begin{multicols}{2}
}
%\makeatother

\newcommand{\colorsection}[2]{%
  \colorbox{#1}{\parbox{\dimexpr\columnwidth-2\fboxsep}{#2}}}

\titleformat{\section}[hang]
{\sectionfont\LARGE\color{white}}
{}
{0pt}
{\colorsection{primarycolor}{\hspace*{10pt}#1}}

\titlespacing{\section}
{0pt}% left
{0pt}% before sep
{0pt}% after sep

\let\oldsection\section
%\makeatletter
\def\section{\@ifnextchar*\oldsection\customsection}% handle \section*
\newcommand{\customsection}[1]{
  \ifmulticolEnd
  \begin{multicols}{2}[\oldsection{#1}]%
}
%\makeatother
\def\vhrulefill{\leavevmode{\unskip
    \leaders\hrule height.5ex depth\dimexpr-.5ex+0.7pt\hfill\hbox{}%
    \parfillskip=0pt\endgraf}}

\titleformat{\subsection}[hang]%
{\color{secondarycolor}\titlerule[2pt]\vspace{-1ex}\sectionfont\Large\color{primarycolor}}%
{% no numbering
}{0em}{#1}



\titleformat{\subsubsection}[hang]%
{\raggedright\sectionfont\large\color{primarycolor}}%
{% no numbering
}{1em}{#1}

\titleformat{\paragraph}[runin]%
{\bfseries\color{primarycolor}}%
{% no numbering
}{0em}{#1}

\titlespacing\subsection{0pt}{*2}{*0}
\titlespacing\subsubsection{0pt}{5pt plus 4pt minus 2pt}{0pt plus 2pt minus 2pt}
\titlespacing\paragraph{0pt}{2pt plus 4pt minus 2pt}{0pt plus 2pt minus 2pt}[0pt plus 2pt minus 2pt]

%% TOC formatting
\RequirePackage{titletoc}
\renewcommand{\tableofcontents}{%
  \ifmulticolEnd
  \chapter*{\contentsname}%
  \vspace*{\baselineskip}
  \begin{multicols}{2}
    \@starttoc{toc}%
}
\setcounter{tocdepth}{1}

\titlecontents{chapter}[0pt]% adjust left margin
{\sectionfont\bfseries\large}% font formatting above-code
{}
{}
{\titlerule*{~}\contentspage}
[\color{primarycolor}\vspace*{-3pt}\hrule\vspace*{10pt}]

\titlecontents{section}[2em]% adjust left margin
{}% font formatting above-code
{}
{}
{\titlerule*[5pt]{.}\contentspage}
[]

\titlecontents{subsection}[4em]% adjust left margin
{}% font formatting above-code
{}
{}
{\titlerule*[5pt]{.}\contentspage}
[]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%	LIST style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{enumitem}
\RequirePackage{amssymb}    % for items symbols
\newlength{\osritemindent}
\setlength{\osritemindent}{0.5\parindent}
\setlength{\parindent}{0pt}

\setlist{nosep, partopsep=0pt}
\setlist[itemize,1]{wide = 0pt, label=\color{primarycolor}$\blacktriangleright$}
\setlist[itemize,2]{label=\color{primarycolor}$\circ$}
\setlist[itemize,3]{leftmargin=\osritemindent, itemindent=\osritemindent, label=\color{primarycolor}$\diamond$}
\setlist[itemize,4]{leftmargin=\osritemindent, itemindent=\osritemindent, label=\color{primarycolor}$\ast$}

\setlist[enumerate,1]{wide = 0pt, label=\color{primarycolor}\textbf{\arabic*}.}
\setlist[enumerate,2]{label=\color{primarycolor}\textbf{\alph*}.}
\setlist[enumerate,3]{leftmargin=\osritemindent, itemindent=\osritemindent,label=\color{primarycolor}\textbf{\roman*}.}
\setlist[enumerate,4]{leftmargin=\osritemindent, itemindent=\osritemindent,label=\color{primarycolor}\textbf{\roman{enumiii}}.\textbf{\arabic*}.}

\setlist[description]{font=\color{primarycolor}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%	LINKS style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{hyperref}   % for hyperlink customization
\hypersetup{
  colorlinks=true,
  urlcolor=blue,
  linkcolor=black,
  citecolor=red,
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%	highlight box style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[most]{tcolorbox}
\tcbuselibrary{breakable}

\tcbset{flatset/.style={
    breakable,
    enhanced,
    colback=secondarycolor!30,
    %opacityfill=0.7,
    colbacktitle=primarycolor,
    coltitle=white,
    center title,
    valign=center,
    fonttitle=\sectionfont\bfseries\large,
    bottomrule=0pt,
    toprule=0pt,
    leftrule=0pt,
    rightrule=0pt,
    titlerule=0pt,
    arc=0pt,
    outer arc=0pt,
    left=2pt,right=2pt,top=0pt,bottom=0pt
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fancy highlight boxes.
%%% code grabbed without shame from https://gitlab.com/bindrpg/core (GPL licence)
%% Fancier borders
\usetikzlibrary{calc,mindmap,trees}% calc for fancy borders
\usetikzlibrary{intersections}% for very fancy borders with intersecting lines
\usetikzlibrary{decorations.text}% for text along circle paths in cs
\usetikzlibrary{shapes.misc}% for very fancy \section
\usetikzlibrary{shapes.callouts}% for labels on the cs
\usetikzlibrary{patterns}% for the pattern 'gridspecks'
\tcbuselibrary{breakable,raster,vignette}
\tcbuselibrary{skins} % used for wiggly-border boxes

\pgfdeclarepatternformonly{gridspecks}{\pgfqpoint{-1pt}{-1pt}}{\pgfqpoint{1pt}{1pt}}{\pgfqpoint{26pt}{26pt}}
{%
  \pgfpathcircle{\pgfqpoint{0pt}{0pt}}{.5pt}%
  \pgfusepath{fill}%
}%
% Define the 'ornamentedbox' environment

% Wiggly Borders
\tikzset{
  use path for main/.code={%
    \tikz@addmode{%
      \expandafter\pgfsyssoftpath@setcurrentpath\csname tikz@intersect@path@name@#1\endcsname
    }%
  },
  use path for actions/.code={%
    \expandafter\def\expandafter\tikz@preactions\expandafter{\tikz@preactions\expandafter\let\expandafter\tikz@actions@path\csname tikz@intersect@path@name@#1\endcsname}%
  },
  use path/.style={%
    use path for main=#1,
    use path for actions=#1,
  }
}
\tikzset{
  ornamented frame inner/.style={color=primarycolor, line width=2pt},
  ornamented frame outer/.style={color=primarycolor, line width=3pt}
}

\tcbsubskin{ornamented}{empty}{
  skin first=ornamented,  skin last=ornamented,
  title engine=standard,
  colbacktitle=white,
  frame code={
    % Account for the line widths in order not to draw beyond the bounding
    % box---except for a few very small details for which this is intentional.
    \coordinate (north west) at ([shift={(1.5pt,-1.5pt)}]frame.north west);
    \coordinate (north east) at ([shift={(-1.5pt,-1.5pt)}]frame.north east);
    \coordinate (south east) at ([shift={(-1.5pt,1.5pt)}]frame.south east);
    \coordinate (south west) at ([shift={(1.5pt,1.5pt)}]frame.south west);
    %
    \foreach \xoffset/\point in {34pt/north west, -34pt/north east,
      34pt/south west, -34pt/south east} {
      \fill[color=primarycolor]
      ([xshift=\xoffset]\point) circle[radius=2.5pt];
    }
    %
    \path[name path=ornament 1]
    ([yshift=-4pt]north west)
    [rounded corners=0.5pt] -- ++(23pt,0)
    [rounded corners=2pt]   -- ++(3pt,-4pt)
    -- ([shift={(-26pt,-8pt)}]north east)
    [rounded corners=0.5pt] -- ++(3pt,4pt)
    [rounded corners=4pt]   -- ([yshift=-4pt]north east)
    -- ([yshift=4pt]south east)
    [rounded corners=0.5pt] -- ++(-23pt,0)
    [rounded corners=2pt]   -- ++(-3pt,4pt)
    -- ([shift={(26pt,8pt)}]south west)
    [rounded corners=0.5pt] -- ++(-3pt,-4pt)
    [rounded corners=4pt]   -- ([yshift=4pt]south west)
    -- cycle;
    %
    \path[rounded corners=0.5pt, name path=ornament 2]
    ([yshift=-20pt]north west)
    -- ++(-4pt,3pt)
    -- ++(0,4pt)
    to[out=0, in=-90] ([shift={(8pt,0pt)}]north west)
    -- ([shift={(34pt,0pt)}]north west)
    -- ([shift={(-8pt,0pt)}]north east)
    to[out=-90, in=180] ([shift={(4pt,-13pt)}]north east)
    -- ++(0,-4pt)
    -- ++(-4pt,-3pt)
    -- ([yshift=20pt]south east)
    -- ++(4pt,-3pt)
    -- ++(0,-4pt)
    to[out=180, in=90] ([shift={(-8pt,0pt)}]south east)
    -- ([shift={(8pt,0pt)}]south west)
    to[out=90, in=0] ([shift={(-4pt,13pt)}]south west)
    -- ++(0,4pt)
    -- ++(4pt,3pt)
    -- cycle;
    %
    \draw[ornamented frame outer, use path=ornament 1,fill=secondarycolor!30];
    \draw[ornamented frame outer, use path=ornament 2];
    \draw[ornamented frame inner, use path=ornament 1];
    \draw[ornamented frame inner, use path=ornament 2];
  }
}

% These parameters---especially those related to geometry---are better located
% here in a style than in the subskin definition (see the Subskins section of
% the tcolorbox manual).
\tcbset{
  ornamented/.style={
    toptitle=14.5pt,
    top=15pt,
    bottom=15pt,
    coltitle=primarycolor,
    colframe=primarycolor,
    left=3pt,
    right=3pt,
    attach boxed title to top center ={
      yshift=-0.45mm-\tcboxedtitleheight/2,
      yshifttext=-2mm-\tcboxedtitleheight/2
    },
    boxed title style={
      boxrule=-0.5mm,
      frame code={ \path[tcb fill frame] ([xshift=-4mm]frame.west)
        -- ([yshift=-0.4mm]frame.north west) -- ([yshift=-0.4mm]frame.north east) -- ([xshift=4mm]frame.east)
        -- ([yshift=0.6mm]frame.south east) -- ([yshift=0.6mm]frame.south west) -- cycle; },
      interior code={ \path[tcb fill interior] ([xshift=-2mm]interior.west)
        -- ([yshift=-0.6mm]interior.north west) -- ([yshift=-0.6mm]interior.north east)
        -- ([xshift=2mm]interior.east) -- ([yshift=1.1mm]interior.south east) -- ([yshift=1.1mm]interior.south west)
        -- cycle;}
    },
    fonttitle=\sectionfont\bfseries\large,
    skin=ornamented,
  }
}

\newtcolorbox{highlight}[1][]{
  ornamented,
  title=#1,
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%	TITLE PAGE style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[]{contour}
\RequirePackage{etoolbox}

\renewcommand\maketitle{\hypersetup{pageanchor=false}% No internal links to title page allowed
  \begin{titlepage}
   \begin{tikzpicture}[overlay, remember picture]
     \node at (current page.center)
     {\includegraphics[width=\paperwidth,height=0.45\paperheight,keepaspectratio]{\@coverimg}};
      \node[inner sep=0pt, fill=secondarycolor, anchor=north, minimum  width=\paperwidth] (toprule) at (current page.north) { \includegraphics[width=0.25\textwidth]{img/Designed_For_Use_With_Old-School_Essentials.png}};
      \node[anchor=north] (title) at (toprule.south) {
        \parbox{0.9\paperwidth}{\centering\color{primarycolor}\titlefont\fontsize{50pt}{60pt}\selectfont \@title}
      };
      \node[anchor=north] (author) at (title.south) {\color{primarycolor}\LARGE \contour[128]{white}{\@author}};
      %\node[below of=author, anchor=north, inner sep=0pt]
      \node[inner sep=0pt, fill=secondarycolor, anchor=south, minimum  width=\paperwidth, , minimum  height=20pt] (bottom) at (current page.south) {};
    \end{tikzpicture}%
    \vfill
    \ifsubtitle
      \begin{highlight}[{\@subtitle}]%
    \else
      \begin{highlight}
    \fi
      \@abstract
    \end{highlight}
  \end{titlepage}
}

\newcommand\@subtitle{\empty}
\newcommand\@coverimg{\relax}
\newcommand\@abstract{\relax}

\newif\ifsubtitle\subtitlefalse % Set default value of conditional to false


\newcommand{\subtitle}[1]{\subtitletrue\gdef\@subtitle{#1}}
\newcommand{\coverimage}[1]{\gdef\@coverimg{#1}}
\renewcommand{\abstract}[1]{\gdef\@abstract{#1}}

%% warning fixes
% Underfull \vbox (badness XXX) has occurred while \output is active []
\def\@textbottom{\vskip \z@ \@plus 8pt}
\let\@texttop\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%	Table style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{etoolbox}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{tabularray}
\UseTblrLibrary{diagbox}

\SetTblrInner{rowsep=2pt}% for the vertical padding
\SetTblrInner{colsep=3pt}% for the vertical padding

\NewTblrTheme{osr}{
  \SetTblrStyle{firsthead}{font=\bfseries}
}

\newenvironment{osrtable}[2]
{
  \ifstrequal{#2}{0}{
    \tblr[theme=osr]{
      colspec = {#1},
      row{even}=secondarycolor!30,
      row{odd}=secondarycolor!15,
    }
  }{%
    \tblr[theme=osr]{
      colspec = {#1},
      row{even}=secondarycolor!30,
      row{odd}=secondarycolor!15,
      row{1-#2} = {
        primarycolor,
        font=\bfseries\small,
        fg=white
      },
    }
  }
}{\endtblr}

\newcommand{\goOneColumns}{\ifmulticolEnd}
\newcommand{\goTwoColumns}{\begin{multicols}{2}}

%%%%%%%	caption style
\RequirePackage{caption}    % for customized caption
\DeclareCaptionFont{osrcaption}{\large\sectionfont}
\captionsetup[table]{
  singlelinecheck=false,
  aboveskip=4pt,
  belowskip=-2pt,
  position=below,
  box=colorbox,
  boxcolor=primarycolor,
  labelformat=empty,
  font = {
    osrcaption,
    color=white
  },
  justification=centerlast
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% for HP squares in monster description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcount\my@repeat@count
\newcommand{\repeatit}[3]{%
  % #1 = number of repetition
  % #2 = text to repeat
  % #3 = text in between
  \begingroup%
  #2%
  \my@repeat@count=\@ne%
  \@whilenum\my@repeat@count<#1\do{#2#3\advance\my@repeat@count\@ne}%
  \endgroup%
}
\newcommand{\oneHD}{{\large $\square$$\square$$\square$$\square$$\square$$\square$$\square$$\square$ }}
\newcommand{\hdsquares}[1]{\repeatit{#1}{\oneHD}{}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\covercolor}[1]{
  \colorlet{primarycolor}{#1}
  \colorlet{secondarycolor}{primarycolor!50}
}
\newcommand{\titlecolor}[1]{
}
\newcommand{\chapterbackground}[1]{}
\newcommand{\forcenewpage}{~\newpage}

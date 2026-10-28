%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Classe "setup/obnzip2.cls"
% NÃO MODIFICAR
%
% Autor: Vitor G. P. Curtarelli
%
% Data: 24/10/2026
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\makeatletter
%%%%%
% Pacotes e classe
%%%%%

\ProvidesClass{setup/obnzip2}[2026/03/02 Template do OBNZip II]

\ExplSyntaxOn
\let\printfigures\relax
\let\printtables\relax
\let\printtoc\relax
\let\printglossaries\relax
\let\datahora\relax

\DeclareOption{figuras}{
	\def\printfigures{\listoffigures}
}
\DeclareOption{tabelas}{
	\def\printtables{\listoftables}
}
\DeclareOption{sumario}{
	\def\printtoc{\tableofcontents}
}
\DeclareOption{glossarios}{
	\def\printglossaries{\glossarios}
}
\DeclareOption{glossarios*}{
	\def\printglossaries{\glossarios*}
}
\DeclareOption{datahora}{
	\def\datahora{\DTMnow{}~[UTC]}
}

\ProcessOptions\relax

\ExplSyntaxOff

\LoadClass{article}

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[brazilian]{babel}  % Loads Portuguese settings (dates, titles)
\RequirePackage{amsmath, amsfonts, amsthm}
\RequirePackage{geometry}
\RequirePackage[colorlinks]{hyperref}
\def\@hypersetup{\hypersetup{
		linkcolor=blue,
		citecolor=black}}
\@hypersetup
\RequirePackage[nameinlink,brazilian,capitalize,]{cleveref}
\RequirePackage[
style=ieee,
doi=false,
isbn=false,
url=false,
citestyle=numeric-comp,
sorting=none,
sortcites=true]{biblatex}
\usepackage{xcolor}
\RequirePackage{enumitem}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{csquotes}
\RequirePackage{lipsum}
\RequirePackage{ragged2e}
\RequirePackage{expl3}
\RequirePackage{tikz}
\RequirePackage{siunitx}
\RequirePackage{subcaption}
\RequirePackage[showzone=false]{datetime2}
\RequirePackage{booktabs}
\RequirePackage{float}
\RequirePackage{longtable}
%%%%%
%
% Comandos-base
%
%%%%%

\geometry{margin=1in}
\NewDocumentCommand{\IfEmpty}{m m G{}}{\ifthenelse{\equal{#1}{}}{#2}{#3}}
\NewDocumentCommand{\IfEqual}{m m m G{}}{\ifthenelse{\equal{#1}{#2}}{#3}{#4}}
\NewDocumentCommand{\IfNotEmpty}{m m G{}}{\ifthenelse{\equal{#1}{}}{#3}{#2}}
\NewDocumentCommand{\itemcabecalho}{m m}{\IfNotEmpty{#2}{\item[\textsl{#1}:] #2}}
\NewDocumentCommand{\@updatecommand}{m m G{} O{, }}{\edef#1{\IfNotEmpty{#1}{#1#4}#2}\IfNotEmpty{#3}{\csname#3\endcsname{#2}}}

%%%%%
%
% Construção do cabeçalho e elementos dele
%
%%%%%

\def\@projeto{}
\def\@titulo{}
\def\@shorttitulo{}
\def\@subtitulo{}
\def\@autor{}
\def\@revisor{}
\def\@resumo{}
\def\@data{\today}
\def\@entregavel{}
\def\@entregavelcodigo{}
\def\@comentario{}
\newcounter{autores}
\newcounter{revisores}
\newcounter{entregaveis}
\def\@status{}
\def\@iniciado{Iniciado}
\def\@andamento{Em andamento}
\def\@concluido{Concluído}

\NewDocumentCommand{\addautor}{m}{\stepcounter{autores}}
\NewDocumentCommand{\contaautores}{>{\SplitList{,}}m}{\ProcessList{#1}{\addautor}}
\NewDocumentCommand{\addrevisor}{m}{\stepcounter{revisores}}
\NewDocumentCommand{\contarevisores}{>{\SplitList{,}}m}{\ProcessList{#1}{\addrevisor}}
\NewDocumentCommand{\addentregavel}{m}{\stepcounter{entregaveis}}
\NewDocumentCommand{\contaentregaveis}{>{\SplitList{,}}m}{\ProcessList{#1}{\addentregavel}}

\definecolor{statusRedOn}{HTML}{FF0000}
\definecolor{statusYlwOn}{HTML}{FF9000}
\definecolor{statusGrnOn}{HTML}{00FF00}
\definecolor{statusRed}{HTML}{400000}
\definecolor{statusYlw}{HTML}{402400}
\definecolor{statusGrn}{HTML}{004000}
\tikzstyle{iniciado} = [statusRed, line width=0pt]
\tikzstyle{andamento} = [statusYlw, line width=0pt]
\tikzstyle{concluido} = [statusGrn, line width=0pt]
\tikzstyle{megathick} = [line width=3pt]
\NewDocumentCommand{\status}{m}{#1}
\NewDocumentCommand{\iniciado}{}{
	\let\@status\@iniciado
	\colorlet{statusRed}{statusRedOn}
	\tikzset{iniciado/.append style={megathick}}
}
\NewDocumentCommand{\andamento}{}{
	\let\@status\@andamento
	\colorlet{statusYlw}{statusYlwOn}
	\tikzset{andamento/.append style={megathick}}
}
\NewDocumentCommand{\concluido}{}{
	\let\@status\@concluido
	\colorlet{statusGrn}{statusGrnOn}
	\tikzset{concluido/.append style={megathick}}
}

\DeclareDocumentCommand{\projeto}{m}{\def\@projeto{#1}}
\DeclareDocumentCommand{\titulo}{o m}{\def\@titulo{#2}\IfValueTF{#1}{\def\@shorttitulo{#1}}{\def\@shorttitulo{#2}}}
\DeclareDocumentCommand{\subtitulo}{m}{\def\@subtitulo{#1}}
\DeclareDocumentCommand{\autor}{m}{\@updatecommand{\@autor}{#1}{contaautores}}
\DeclareDocumentCommand{\revisor}{m}{\@updatecommand{\@revisor}{#1}{contarevisores}}
\DeclareDocumentCommand{\resumo}{m}{\def\@resumo{#1}}
\DeclareDocumentCommand{\data}{m}{\def\@data{#1}}
\DeclareDocumentCommand{\entregavel}{m m}{\@updatecommand{\@entregavel}{#1~-~#2}{contaentregaveis}[\\]\@updatecommand{\@entregavelcodigo}{#1}[~$\vert$~]}
\DeclareDocumentCommand{\comentario}{m}{\def\@comentario{#1}}

\DeclareDocumentCommand{\formarcabecalho}{}{
	\thispagestyle{firstpage}
	\IfEmpty{\@titulo}{\errmessage{Título vazio}}
	\IfEmpty{\@autor}{\errmessage{Autor vazio}}
	\IfEmpty{\@entregavel}{\errmessage{Atividade do projeto vazia}}
	\begin{center}
		\begin{minipage}{0.9\linewidth}
			\centering{
				{\bfseries\huge \@titulo}
				\IfEmpty{\@subtitulo}{\\[0.5cm]}{\\[0.25cm]{\bfseries\large \@subtitulo} \\[0.5cm]}
			}
			{
				\begin{itemize}[itemsep=0pt,
					leftmargin=\widthof{Entregável}+2ex]
					\small
					\itemcabecalho{Autor\ifthenelse{\value{autores}>1}{es}{}}{\@autor}
					\itemcabecalho{Revisor\ifthenelse{\value{revisores}>1}{es}{}}{\@revisor}
					\itemcabecalho{Data}{\@data}
					\itemcabecalho{\ifthenelse{\value{entregaveis}>1}{Entregáveis}{Entregável}}{\@entregavel}
					\itemcabecalho{Resumo}{\@resumo}
				\end{itemize}
			}
			\hrule
			\IfEmpty{\@comentario}{}{\vspace*{1em}\noindent\justifying\@comentario}
		\end{minipage}
	\end{center}
	\printtoc
	\printfigures
	\printtables
	\printglossaries
	\vspace*{0mm}
	% \linebreak
	\setcounter{table}{0}
}

\input{setup/A.Cabecalho}

%%%%%
%
% Formatação do header no topo de cada página
%
%%%%%

\def\@headercenter{%
	\parbox{0.7\linewidth}{%
		\centering%
		\small{OBNZip II~-~\textsl{\@entregavelcodigo~-~\@shorttitulo}}%
		\vspace*{1pt}%
	}%
}

\def\@first@headercenter{%
	\parbox{0.7\linewidth}{%
		\centering%
		\small{\@projeto}%
		\vspace*{1pt}%
	}%
}

\def\@headerleft{%
	\parbox{0.15\linewidth}{\raggedright%
		\includegraphics[height=0.5cm]{setup/logos/ufsc}%
		\includegraphics[height=0.5cm]{setup/logos/obnzip}%
		\includegraphics[height=0.5cm]{setup/logos/petrobras}%
		\vspace*{1pt}%
	}%
}

\def\@headerright{%
	\parbox{0.15\linewidth}{%
		%\@status{} {\color{statusRed}O}{\color{statusYlw}O}{\color{statusGrn}O} %
		\raisebox{-1pt}{\begin{tikzpicture}[x={(7pt,0pt)}, y={(0pt,7pt)}]
				% 1. Simple outline circle (Center at x=0, y=0 with a 1cm radius)
				\filldraw[iniciado] (0,0) circle (2pt);
				
				% 2. Filled circle (Center at x=3, y=0 with a 1cm radius)
				\filldraw[andamento] (1,0) circle (2pt);
				
				% 3. Circle with both a thick red border and a yellow fill
				\filldraw[concluido] (2,0) circle (2pt);
		\end{tikzpicture}}~
		\raggedleft\small{\thepage}\vspace*{1pt}%
	}%
}

\setlength{\headheight}{18pt}%
\fancyhead{}%
\fancyhead[L]{%
	\@headerleft%
}
\fancyhead[C]{%
	\@headercenter%
}%
\fancyhead[R]{%
	\@headerright%
}%
\fancyfoot{}%

\fancypagestyle{firstpage}{%
	\setlength{\headheight}{18pt}%
	\fancyhead{}%
	\fancyhead[L]{%
		\@headerleft%
		\hspace{0pt-\widthof{\@headerleft}}\raisebox{-16pt}[0pt][0pt]{\datahora}
	}
	\fancyhead[C]{%
		\@first@headercenter%
	}%
	\fancyhead[R]{%
		\@headerright%
		\hspace{0pt-\widthof{\@status}}\raisebox{-16pt}[0pt][0pt]{\@status}
	}%
	\fancyfoot{}%
}

%%%%%
%
% Comandos finais da formatação do template
%
%%%%%

\projeto{OBNZip II - Inteligência Artificial Embarcada e Sensoriamento em OBNs}
\AtBeginDocument{\formarcabecalho}
\pagestyle{fancy}

%%%%%
%
% Modificações e configurações no BibLaTeX e no Cleveref
%
%%%%%

\DefineBibliographyStrings{brazilian}{
	presentedat = {apresentado em~}
}
\renewcommand*{\bibfont}{\small}
\bibliography{setup/RelatorioReferencias.bib}


%%%%%
%
% Erros e avisos da não-edição dos dados do cabeçalho
%
%%%%%

\let\@lw\@ClassWarningNoLine
\NewDocumentCommand{\@AvisoTemplate}{m m G{#2}}{%
	\protected@edef\AvisoTemplateComando{\csname #3\endcsname}
	\IfEqual{\csname @#2\endcsname}{\csname @template#2\endcsname}{\@lw{obnzip2.cls}{Campo "#1" do cabeçalho não editado. Altere o argumento do comando \AvisoTemplateComando no arquivo "setup/A.Cabecalho.tex"}}
}

\def\@templatetitulo{Modelo em \LaTeX~para relatório de atividade}
\def\@templateshorttitulo{Template em \LaTeX}
\def\@templatesubtitulo{Para manter padrões no projeto}
\def\@templateautor{}
\def\@templaterevisor{}
\def\@templateentregavel{}
\@updatecommand{\@templateautor}{Vitor Curtarelli, Ciclano Silva}
\@updatecommand{\@templaterevisor}{Beltrano Souza}
\@updatecommand{\@templateentregavel}{7.1.1~-~Elaboração de template de relatório técnico em LaTeX}[\\]
\def\@templateresumo{Esse documento é um modelo a ser usado nos relatórios de atividades dentro do projeto OBNZip II, bem como para outros documentos em geral.}    
\def\@templatecomentario{Atente-se a todos os comandos presentes nesse template.}


\@AvisoTemplate{Título}{titulo}
\@AvisoTemplate{Título-curto}{shorttitulo}{titulo}
\@AvisoTemplate{Subtítulo}{subtitulo}
\@AvisoTemplate{Autor(es)}{autor}
\@AvisoTemplate{Revisor(es)}{revisor}
\@AvisoTemplate{Entregável}{entregavel}
\@AvisoTemplate{Resumo}{resumo}
\@AvisoTemplate{Comentário}{comentario}

%%%%%%%%%%%%%%%%%%%%%%
%
% Modificações para o pacote SiUnitX
%
%%%%%%%%%%%%%%%%%%%%%%

\sisetup{
	range-phrase  = {\text{--}},     % Uses an en-dash (–) as the symbol
	range-units   = single,    % Avoids repeating the unit (e.g., "10–20 m" instead of "10 m – 20 m")
	detect-weight = true,
	output-decimal-marker = {,}
}

%%%%%
%
% Glossários para lista de símbolos e lista de siglas
%
%%%%%
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}

\ExplSyntaxOn

% 1. Declare Counters, Property Lists & Booleans
\newcounter{glossario}

\prop_new:N \g_gls_siglas_dict  % Stores entries
\prop_new:N \g_gls_siglas_desc_dict  % Stores descriptions
\prop_new:N \g_gls_siglas_desc_fl_dict  % Stores foreign language descriptions
\prop_new:N \g_gls_siglas_used_dict  % Stores which were used
\prop_new:N \g_gls_simbolos_dict  % Stores entries
\prop_new:N \g_gls_simbolos_desc_dict  % Stores descriptions
\prop_new:N \g_gls_simbolos_un_dict  % Stores units
\prop_new:N \g_gls_simbolos_used_dict  % Stores which were used
\prop_new:N \l_gls_gls_dict
\prop_new:N \l_gls_gls_desc_dict
\prop_new:N \l_gls_gls_descb_dict
\prop_new:N \l_gls_gls_used_dict

\bool_new:N \g_gls_found_bool  % Check if repeated glossary entry
\bool_new:N \l_siglas_is_empty_bool  % Check if dictionary is empty
\bool_new:N \l_simbolos_is_empty_bool  % Check if dictionary is empty

\iow_new:N \g_siglas_iow  %In-out write file
\iow_new:N \g_simbolos_iow  %In-out write file

\tl_new:N  \l_siglas_saved_contents_tl  % Contents of in-out write
\tl_new:N  \l_simbolos_saved_contents_tl  % Contents of in-out write

% Scratch variables for sorting and string formatting
\seq_new:N \l_gls_keys_seq
\tl_new:N \l_gls_tl
\tl_new:N \l_desc_tl
\tl_new:N \l_extra_tl
\tl_new:N \l_check_tl
\tl_new:N \l_fl_tl
\tl_new:N \l_pag_tl


% 2. Safe File Inspector Macro
\NewDocumentCommand{\checkglsfile}{m m m}{
	\file_if_exist:nTF {#1}{
		\file_get:nnN {#1} { \char_set_catcode_space:N \  } #2
		\tl_if_empty:NTF #2
		{
			\bool_set_true:N #3
			\iow_term:n {#1~-~Empty}
		}
		{
			\bool_set_false:N #3
			\iow_term:n {#1~-~Not~empty}
		}
	}{
		\bool_set_true:N #3
		\iow_term:n {#1~-~Does~not~exist}
		\tl_clear:N #2
	}
}

% READ files BEFORE opening them for writing!
\checkglsfile{siglas.aux}{\l_siglas_saved_contents_tl}{\l_siglas_is_empty_bool}
\checkglsfile{simbolos.aux}{\l_simbolos_saved_contents_tl}{\l_simbolos_is_empty_bool}

% Open for writing
\iow_open:Nn \g_siglas_iow {siglas.aux}
\iow_open:Nn \g_simbolos_iow {simbolos.aux}

% 3. Updated \sigla and \simbolo
\NewDocumentCommand{\addglossario}{m m m o m m m}{
	\bool_gset_false:N \g_gls_found_bool
	\tl_set:Nn \l_tmpa_tl {Entrada~no~glossário~já~definida!~``#1''}
	\prop_if_in:NnTF \g_gls_siglas_dict {#1} {
		\errmessage{\l_tmpa_tl}
		\bool_gset_true:N \g_gls_found_bool
	}{
		
	}
	\prop_if_in:NnTF \g_gls_simbolos_dict {#1} {
		\errmessage{\l_tmpa_tl}
		\bool_gset_true:N \g_gls_found_bool
	}{
		
	}
	\bool_if:NTF \g_gls_found_bool {} {
		\prop_gput:Nnn #5 {#1} {#2}
		\prop_gput:Nnn #6 {#1} {#3}
		\IfValueT{#4}{
			\prop_gput:Nnn #7 {#1} {#4}
		}
	}
}

\NewDocumentCommand{\sigla}{m m m o}{%
	\addglossario{#1}{#2}{#3}[#4]{\g_gls_siglas_dict}{\g_gls_siglas_desc_dict}{\g_gls_siglas_desc_fl_dict}
}

\NewDocumentCommand{\simbolo}{m m m o}{%
	\addglossario{#1}{\ensuremath{#2}}{#3}[#4]{\g_gls_simbolos_dict}{\g_gls_simbolos_desc_dict}{\g_gls_simbolos_un_dict}
}

% 4. Streamlined \@write and \@gls Definition

\NewDocumentCommand{\@write}{s m m m m m}{%
	\seq_clear:N \l_gls_keys_seq
	\prop_map_inline:Nn #4
	{
		\seq_put_right:Nn \l_gls_keys_seq {##1}
	}
	
	\IfBooleanTF{#1}{
		%
	}{%
		% Sort keys alphabetically
		\seq_sort:Nn \l_gls_keys_seq {%
			\str_compare:nNnTF {##1} {>} {##2} { \sort_return_swapped: } { \sort_return_same: }
		}%
	}%
	
	\seq_map_inline:Nn \l_gls_keys_seq {%
		\prop_get:NnN #2 {##1} \l_gls_tl
		\prop_get:NnN #3 {##1} \l_tmpa_tl
		\tl_set:Nx \l_desc_tl {\MakeTitlecase{\l_tmpa_tl}}
		\prop_get:NnNTF #5 {##1} \l_tmpa_tl {\tl_set:Nn \l_fl_tl {(\exp_not:N \textsl {\exp_not:V \l_tmpa_tl})}} {\tl_set:Nn \l_fl_tl {}}
		\iow_now:Nx #6 {%
			\exp_not:N \hyperref [gls:##1] {\exp_not:V \l_gls_tl} ~%
			\char_generate:nn {38}{12} ~%
			\exp_not:N \hyperref [gls:##1] {\exp_not:V \l_desc_tl{}~\l_fl_tl} ~%
			\char_generate:nn {38}{12} ~%
			\exp_not:N \pageref{gls:##1} ~ \token_to_str:N \\
		}
	}
}

\NewDocumentCommand{\Gls}{}{
	
}
\NewDocumentCommand{\@gls}{s o o o m O{inglês}}{%
	\IfBooleanTF{#1}{
		\prop_set_eq:NN \l_gls_gls_dict \g_gls_simbolos_dict
		\prop_set_eq:NN \l_gls_gls_desc_dict \g_gls_simbolos_desc_dict
		\prop_set_eq:NN \l_gls_gls_descb_dict \g_gls_simbolos_un_dict
		\prop_set_eq:NN \l_gls_gls_used_dict \g_gls_simbolos_used_dict
	}{
		\prop_set_eq:NN \l_gls_gls_dict \g_gls_siglas_dict
		\prop_set_eq:NN \l_gls_gls_desc_dict \g_gls_siglas_desc_dict
		\prop_set_eq:NN \l_gls_gls_descb_dict \g_gls_siglas_desc_fl_dict
		\prop_set_eq:NN \l_gls_gls_used_dict \g_gls_siglas_used_dict
	}
	\hypersetup{linkcolor=teal}
	
	\prop_get:NnNTF {\l_gls_gls_dict} {#5} \l_gls_tl {%
		\IfValueT{#2}{\tl_set:Nx \l_gls_tl {#2}}
		\prop_get:NnNTF {\l_gls_gls_used_dict} {#5} \l_check_tl {%
			\hyperref[gls:#5]{\l_gls_tl}
		}{
			\refstepcounter{glossario}\label{gls:#5}
			\prop_gput:Nnn {\l_gls_gls_used_dict} {#5} {\l_gls_tl}
			\IfBooleanF{#1}{
				\prop_get:NnN {\l_gls_gls_desc_dict} {#5} {\l_desc_tl}
				\IfValueT{#3}{\tl_set:Nx \l_desc_tl {#3}}
			}
			
			\prop_get:NnNTF {\l_gls_gls_descb_dict} {#5} \l_fl_tl {
				\IfValueT{#4}{\tl_set:Nx \l_fl_tl {#4}}
				\tl_set:Nx \l_extra_tl {(\exp_not:V \l_gls_tl,~do~#6{}~\exp_not:N \textsl { \exp_not:V \l_fl_tl }) } 
			}
			{ 
				\tl_set:Nx \l_extra_tl {(\l_gls_tl)}
			}
			
			\IfBooleanTF{#1}{
				\prop_item:Nn {\l_gls_gls_dict} {#5}
			}{
				\l_desc_tl{}~\l_extra_tl
			}
		}
		\bool_gset_true:N \g_gls_found_bool
	}{
		
	}
	\@hypersetup
	\IfBooleanTF{#1}{
		\prop_gset_eq:NN \g_gls_simbolos_used_dict \l_gls_gls_used_dict
	}{
		\prop_gset_eq:NN \g_gls_siglas_used_dict \l_gls_gls_used_dict
	}
}

\NewDocumentCommand{\gls}{o o o m O{inglês}}{%
	\@gls[#1][#2][#3]{#4}[#5]
	\@gls*{#4}
	\bool_if:NF \g_gls_found_bool
	{ 
		\errmessage{Não~foi~encontrada~entrada~#1}
	}
}

\AtEndDocument{
	\@write{\g_gls_siglas_dict}{\g_gls_siglas_desc_dict}{\g_gls_siglas_used_dict}{\g_gls_siglas_desc_fl_dict}{\g_siglas_iow}
	\@write*{\g_gls_simbolos_dict}{\g_gls_simbolos_desc_dict}{\g_gls_simbolos_used_dict}{\g_gls_simbolos_un_dict}{\g_simbolos_iow}
	
	\iow_close:N \g_siglas_iow
	\iow_close:N \g_simbolos_iow
}

\tl_set_rescan:NnV \l_simbolos_saved_contents_tl
{
	\char_set_catcode_space:N \ 
	\char_set_catcode_math_subscript:N \_
}
\l_simbolos_saved_contents_tl

\newlength\glscolsep
\setlength\glscolsep{1em}
\newlength\glsdescwidth
\setlength\glsdescwidth{\textwidth-1cm-1.1cm-4\glscolsep}

% 5. Streamlined Glossary Printer with Alphabetical Sorting
\NewDocumentCommand{\printglossary}{s m m o m m}{%
	\IfBooleanTF{#1}{
		\prop_if_empty:NF #2 {
			\subsection*{Lista~de~#6s}
			\addcontentsline{toc}{subsection}{Lista~de~#6s}
			\setlength\tabcolsep{\glscolsep}
			\begin{longtable}{@{} #5 @{}}
				\textbf{#6} & \textbf{Descrição} & \\[0.5em]
				
				% Extract keys cleanly using \prop_get_keys:NV
				\seq_clear:N \l_gls_keys_seq
				\prop_map_inline:Nn #2
				{
					\seq_put_right:Nn \l_gls_keys_seq {##1}
				}
				
				% Sort keys alphabetically
				\seq_sort:Nn \l_gls_keys_seq {
					\str_compare:nNnTF {##1} {>} {##2} { \sort_return_swapped: } { \sort_return_same: }
				}
				
				% Iterate over sorted keys
				\tl_set:Nn \l_tmpa_tl {}
				\seq_map_inline:Nn \l_gls_keys_seq {
					\l_tmpa_tl
					\prop_item:Nn #2 {##1} & 
					\prop_item:Nn #3 {##1} 
					\IfValueT{#4}{%
						\prop_get:NnNTF {#4} {##1} \l_tmpc_tl {~(\textsl {\l_tmpc_tl})} {}%
					}
					\tl_set:Nn \l_tmpa_tl {\\}
				}
			\end{longtable}
		}
	}{
		\bool_if:NF #2 {
			\subsection*{Lista~de~#6s}
			\addcontentsline{toc}{subsection}{Lista~de~#6s}
			\setlength\tabcolsep{\glscolsep}
			\begin{longtable}{@{} #5 @{}}
				\textbf{#6} & \textbf{Descrição} & \textbf{Pág.}\\[0.5em]
				#3
			\end{longtable}
		}
	}
}

\def\limparglossario{
	\prop_gclear:N \g_gls_siglas_dict
	\prop_gclear:N \g_gls_siglas_desc_dict
	\prop_gclear:N \g_gls_simbolos_dict
	\prop_gclear:N \g_gls_simbolos_desc_dict
}

\NewDocumentCommand{\listadesiglas}{s}{%
	\IfBooleanTF{#1}{
		\printglossary*{\g_gls_siglas_dict}{\g_gls_siglas_desc_dict}[\g_gls_siglas_desc_fl_dict]{L{1.1cm} L{\glsdescwidth} R{1cm}}{Sigla}
	}{
		\printglossary{\l_siglas_is_empty_bool}{\l_siglas_saved_contents_tl}{L{1.1cm} L{\glsdescwidth} R{1cm}}{Sigla}
	}
}

\NewDocumentCommand{\listadesimbolos}{s}{%
	\IfBooleanTF{#1}{
		\printglossary*{\g_gls_simbolos_dict}{\g_gls_simbolos_desc_dict}[\g_gls_simbolos_un_dict]{L{1.1cm} L{\glsdescwidth} R{1cm}}{Símbolo}
	}{
		\printglossary{\l_simbolos_is_empty_bool}{\l_simbolos_saved_contents_tl}[]{L{1.1cm} L{\glsdescwidth} R{1cm}}{Símbolo}
	}
}

\NewDocumentCommand{\glossarios}{s}{%
	\IfBooleanTF{#1}{
		\bool_if:nF { \prop_if_empty_p:N \g_gls_siglas_dict && \prop_if_empty_p:N \g_gls_simbolos_dict } {
			\section*{Glossários}
			\addcontentsline{toc}{section}{Glossários}
			\listadesiglas*
			\listadesimbolos*
		}
	}{
		\bool_if:nF { \l_siglas_is_empty_bool && \l_simbolos_is_empty_bool } {
			\section*{Glossários}
			\addcontentsline{toc}{section}{Glossários}
			\listadesiglas
			\listadesimbolos
		}
	}
}

\ExplSyntaxOff


\input{setup/B.Glossario}
%%%%%
% Apêndices e anexos
%%%%%
\crefname{annex}{Anexo}{Anexos}
\Crefname{annex}{Anexo}{Anexos}
\crefname{appendix}{App.}{Apps.}
\Crefname{appendix}{Apêndice}{Apêndices}

\def\apendices{
	\appendix
	\section*{Apêndices}
	\crefalias{section}{appendix}
	\addtocontents{toc}{\protect\contentsline{section}{Apêndices}{}{}{}}
}
\def\anexos{
	\setcounter{section}{0}
	\crefalias{section}{annex}
	\section*{Anexos}
	\addtocontents{toc}{\protect\contentsline{section}{Anexos}{}{}{}}
}
\makeatother

%%%%%
%
% Símbolos matemáticos
%
%%%%%
\def\e{\mathrm{e}}
\def\j{\mathrm{j}}
\def\d{\mathrm{d}}
\let\ingles\textsl
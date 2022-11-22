local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --

-- local myFirstSnippet = s("myFirstSnippet", {
--   t("This is the first! "),
--   i(1, "placeholder_text"),
--   t( "", " another text node")
-- })
-- table.insert(snippets, myFirstSnippet)
--
-- local mySecondSnippet = s("mySecondSnippet", fmt([[
-- local {} = function({})
--   {}
-- end
-- ]],
--   {
--     i(1, "myVar"),
--     i(2, "myArg"),
--     i(3, "-- TODO: something"),
--     }
--   )
-- )
-- table.insert(snippets, mySecondSnippet)






-- %%% --



-- # -- SNIPPETS --
--
-- # new glossary entry
-- snippet gloss "Glossary Entry" b
-- 	\newglossaryentry{${1:entry}}{
-- 			name = {${2:name}},
-- 			symbol = {\ensuremath{${3:symbol}}},
-- 			description = {${4:description}}
-- 	}
-- endsnippet
--
-- # custom theorem enviornment
-- snippet customthm "Custom Theorem" b
-- 	\vspace{.1in}
-- 	\begin{customthm}{(${1:label})}
-- 		${2:claim}
-- 	\end{customthm}
--
-- 	\begin{Answer}
-- 		${0}
-- 	\end{Answer}
-- endsnippet
--
-- # framed text enviornment
-- snippet textbox "Text Box" b
-- 	\begin{tcolorbox}
-- 		${0}
-- 	\end{tcolorbox}
-- endsnippet
--
-- # new command
-- snippet nc "New Command" b
-- 	\newcommand{${1:cmd}}[${2:opt}]{${3:realcmd}} ${0}
-- endsnippet
--
-- #usepackage
-- snippet up "Use Package" b
-- 	\usepackage[${1:options}]{${2:package}} ${0}
-- endsnippet
--
-- # \begin{}...\end{}
-- snippet begin "Begin End"
-- 	\begin{${1:env}}
-- 		${2:${VISUAL}}
-- 	\end{$1}${0}
-- endsnippet
--
-- # Align(ed)
-- snippet align "Align Env" b
-- 	\begin{align${1:ed}}
-- 		\label{${2:name}}
-- 		${0}
-- 	\end{align$1}
-- endsnippet
--
-- # Quote
-- snippet quote "Quotation" b
-- 	\vspace{-.1in}
-- 	\begin{quote}\singlespacing\small
-- 		${0}
-- 		\hfill(p.~${1})
-- 	\end{quote}
-- 	\vspace{.1in}
-- endsnippet
--
-- # Labelalign
-- snippet labelalign "Label Align" b
-- 	\vspace{.05in}
-- 	\begin{labelalign} %\small\onehalfspacing
-- 		\item[${2:\it} ${3:Label:}] ${0}
-- 	\end{labelalign}
-- 	\vspace{.05in}
-- endsnippet
--
-- # Enumerate
-- snippet enum "Enumerate" b
-- 	\begin{enumerate}${1:%}[leftmargin=0in,labelsep=.15in] 
-- 		\item[${2:\it} ${3:Label:}] ${0}
-- 	\end{enumerate}
-- endsnippet
--
-- # Itemize
-- snippet item "Itemize" b
-- 	\begin{itemize}
-- 		\item[${1:\it} ${2:Label:}] ${0}
-- 	\end{itemize}
-- endsnippet
--
-- #Item
-- snippet i "Item"
-- 	\item[${1:\it} ${2:Label:}] ${0}
-- endsnippet
--
-- # Cases
-- snippet case "Cases" 
-- 	${1:LHS}=	
-- 	\begin{cases}
-- 		${2:Value}, &\text{ if } ${3:case}\\
-- 		${4:Value}, &\text{ otherwise.} ${5:otherwise}.
-- 	\end{cases}${0}
-- endsnippet
--
-- # Section
-- snippet sec "Section" b
-- 	\section{${1:Name}}%
-- 		\label{sec:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Section without number
-- # snippet sec* "Section*" b
-- # \section*{${1:Name}}%
-- # 	\label{sec:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- # Sub Section
-- snippet sub "Sub Section" b
-- 	\subsection{${1:Name}}%
-- 		\label{sub:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Sub Section without number
-- # snippet sub* "Sub Section*" b
-- # \subsection*{${1:Name}}%
-- # 	\label{sub:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- # Sub Sub Section
-- snippet ssub "Sub Sub Section" b
-- 	\subsubsection{${1:Name}}%
-- 		\label{sub:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Sub Sub Section without number
-- # snippet ssub* "Sub Sub Section*" b
-- # \subsubsection*{${1:Name}}%
-- # 	\label{sub:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- # Hyper Section
-- snippet hsec "Hyper Section" b
-- 	\hypsection{${1:Name}}%
-- 		\label{sec:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Hyper Section without number
-- # snippet hsec* "Hyper Section*" b
-- # \hypsection*{${1:Name}}%
-- # 	\label{sec:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- # Hyper Sub Section
-- snippet hsub "Hyper Sub Section" b
-- 	\hypsubsection{${1:Name}}%
-- 		\label{sub:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Hyper Sub Section without number
-- # snippet hsub* "Hyper Sub Section*" b
-- # \hypsubsection*{${1:Name}}%
-- # 	\label{sub:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- # Hyper Sub Sub Section
-- snippet hssub "Hyper Sub Sub Section" b
-- 	\hypsubsubsection{${1:Name}}%
-- 		\label{sub:${2:$1}}
-- 		${0}
-- endsnippet
--
-- # # Hyper Sub Sub Section without number
-- # snippet hssub* "Hyper Sub Sub Section*" b
-- # \hypsubsubsection*{${1:Name}}%
-- # 	\label{sub:${2:$1}}
-- # 	${0}
-- # endsnippet
--
-- #Formating text: italic, bold, underline, small capital, emphase ..
-- snippet it "Italics"
-- 	\textit{${1}}${0}
-- endsnippet
--
-- snippet tt "Teletype"
-- 	\texttt{${1}}${0}
-- endsnippet
--
-- snippet bf "Bold"
-- 	\textbf{${1}}${0}
-- endsnippet
--
-- snippet under "Underline"
-- 	\underline{${1}}${0}
-- endsnippet
--
-- snippet over "Overline"
-- 	\overline{${1}}${0}
-- endsnippet
--
-- snippet sc "Small Caps"
-- 	\textsc{${1}}${0}
-- endsnippet
--
-- #Choosing font
-- snippet sf "Sans Serife" 
-- 	\textsf{${1}}${0}
-- endsnippet
--
-- snippet rm "Roman Font" 
-- 	\textrm{${1}}${0}
-- endsnippet
--
-- snippet tsub "Subscripted" 
-- 	\textsubscript{${1}}${0}
-- endsnippet
--
-- snippet tsup "Superscripted" 
-- 	\textsuperscript{${1}}${0}
-- endsnippet
--
-- #Math font
-- snippet mf "Mathfrak"
-- 	\mathfrak{${1}}${0}
-- endsnippet
--
-- snippet mc "Mathcal"
-- 	\mathcal{${1}}${0}
-- endsnippet
--
-- snippet ms "Mathscr"
-- 	\mathscr{${1}}${0}
-- endsnippet
--
-- #misc
-- snippet fproof "Footnote Proof"
-- 	\footnote{\textit{Proof:} ${1:Begin} \qed}${0}
-- endsnippet
--
-- snippet lab "Label"
-- 	\label{${1:LABEL}}${0}
-- endsnippet
--
-- snippet fn "Footnote"
-- 	\footnote{${1:FOOTNOTE}}${0}
-- endsnippet
--
-- snippet fig "Figure environment" b
-- 	\begin{figure}
-- 	\begin{center}
-- 		\includegraphics[scale=${1}]{Figures/${2}}
-- 	\end{center}
-- 	\caption{${3}}
-- 	\label{fig:${4}}
-- 	\end{figure}
-- 	${0}
-- endsnippet
--
-- snippet tikz "Tikz environment" b
-- 	\begin{figure}[htpb]
-- 	\begin{center}
-- 	\begin{tikzpicture}[scale=${1:1}, transform shape]
-- 		${2}
-- 	\end{tikzpicture}
-- 	\end{center}
-- 	\caption{${3}}%
-- 	\label{fig:${4}}
-- 	\end{figure}
-- 	${0}
-- endsnippet









-- End Refactoring --

return snippets, autosnippets

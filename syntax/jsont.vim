" Vim syntax file
" Language:	JSON-Template
" Maintainer:	Jeff Jacobson-Swartfager <jeff.ja@gmail.com>
" URL:		http://changecase.net/vim/syntax/jsont.vim
" Last Change:  2015 Jun 8

" Check if an earlier file has defined a syntax aready. If so, exit.
if exists("b:current_syntax")
  finish
endif

" Check if a main syntax has been declared (by the user or filetype).
" If not, set it to jsont.
if !exists("main_syntax")
  let main_syntax = "jsont"
endif

" Check if a default subtype has already been defined. If not, set it to html
" since Squarespace template files are for webpages.
if !exists("g:jsont_default_subtype")
  let g:jsont_default_subtype = "html"
endif

" Check if other subtypes have been declared (and make sure this is still a
" jsont file). If not, set the subtype to the default subtype.
if !exists("b:jsont_subtype") && main_syntax == "jsont"
  let s:lines = getline(1)."\n".getline(2)."\n".getline(3)."\n".getline(4)."\n".getline(5)."\n".getline("$")
  let b:jsont_subtype = matchstr(s:lines,'jsont_subtype=\zs\w\+')
  if b:jsont_subtype == ''
    let b:jsont_subtype = g:jsont_default_subtype
  endif
endif

" Check if a subtype has been set (and that it isn't empty). If it has, load
" the associated syntax file.
if exists("b:jsont_subtype") && b:jsont_subtype != ''
  exe 'runtime! syntax/'.b:jsont_subtype.'.vim'
  unlet! b:current_syntax
endif

" JSON-T syntax is case sensitive. If it wasn't, we'd use `syn case ignore`
" instead.
syn case match

" [DELETE]
" if !exists('g:jsont_highlight_types')
"   let g:jsont_highlight_types = []
" endif

" Check if a base subtype has been set. If not, set it to the jsont subtype.
" If the jsont subtype is empty, remove the jsont subtype -- otherwise, set
" the jsont subtype to the base subtype. Finally, remove the base subtype. 
if !exists('s:subtype')
  let s:subtype = exists('b:jsont_subtype') ? b:jsont_subtype : ''

  if s:subtype == ''
    unlet! b:jsont_subtype
  else
    let b:jsont_subtype = s:subtype
  endif
  unlet s:subtype
endif

syn match jsontAlert /TODO/

syn region jsontIdentifier matchgroup=jsontDelimiter start="{" end="}" contains=@jsontIdentifier containedin=ALLBUT,@jsontExempt keepend
syn region jsontExpression matchgroup=jsontDelimiter start="{\(\.\)\@=" end="}" contains=@jsontExpression containedin=ALLBUT,@jsontExempt keepend

"syn region jsontSection matchgroup=jsontBlockDelimiter start="{\.section" end="}" contains=@jsontExpression containedin=ALLBUT,@jsontExempt keepend
"syn region jsontRepeatedSection matchgroup=jsontBlockDelimiter start="{\.repeated" end="}" contains=@jsontExpression,jsontScope containedin=ALLBUT,@jsontExempt keepend
"syn region jsontEnd matchgroup=jsontBlockDelimiter start="{\.end" end="}" contains=@jsontExpression containedin=ALLBUT,@jsontExempt keepend

syn cluster jsontExempt contains=@jsontTop
syn cluster jsontIdentifier contains=jsontVariable

syn cluster jsontExpression contains=jsontOperator,jsontString,jsontNumber
syn cluster jsontExpression contains=jsontFloat,jsontBoolean,jsontNull
syn cluster jsontExpression contains=jsontEmpty,jsontPipe,jsontForloop
syn cluster jsontExpression contains=jsontSection,jsontConditional

syn match   jsontVariable ".*" contained
"syn keyword jsontOperator and or not contained

"syn keyword jsontConditional if contained

hi def link jsontDelimiter        PreProc
hi def link jsontConditional      Statement
hi def link jsontOperator         Operator
hi def link jsontScope            Keyword
hi def link jsontIdentifier       Identifier
hi def link jsontVariable         jsontIdentifier
hi def link jsontAlert            Todo
"hi def link jsontBlockDelimiter   jsontDelimiter
"hi def link ???               Comment
"hi def link ???               Constant
"hi def link ???               Identifier
"hi def link ???               Statement
"hi def link ???               Type
"hi def link ???               Underlined
"hi def link ???               Ignore
"hi def link ???               Todo
"hi def link ???               htmlBoldItalic
"hi def link ???               htmlBold
"hi def link ???               Normal

let b:current_syntax = 'jsont'

if exists('main_syntax') && main_syntax == 'jsont'
  unlet main_syntax
endif

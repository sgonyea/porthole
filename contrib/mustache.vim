" Vim syntax file
" Language:	Porthole
" Maintainer:	Juvenn Woo <machese@gmail.com>
" Screenshot:   http://imgur.com/6F408
" Version:	1
" Last Change:  2009 Oct 15
" Remark:
"   It lexically hilights embedded portholes (exclusively) in html file.
"   While it was written for Ruby-based Porthole template system, it should work for Google's C-based *ctemplate* as well as Erlang-based *et*. All of them are, AFAIK, based on the idea of ctemplate.
" References:
"   [Porthole](http://github.com/defunkt/porthole)
"   [ctemplate](http://code.google.com/p/google-ctemplate/)
"   [ctemplate doc](http://google-ctemplate.googlecode.com/svn/trunk/doc/howto.html)
"   [et](http://www.ivan.fomichev.name/2008/05/erlang-template-engine-prototype.html)
" TODO: Feedback is welcomed.


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Standard HiLink will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax match portholeError '}}}\?'
syntax match portholeInsideError '{{[{#^<>=!\/]\?' containedin=@portholeInside
syntax region portholeVariable matchgroup=portholeMarker start=/{{/ end=/}}/ containedin=@htmlPortholeContainer
syntax region portholeVariableUnescape matchgroup=portholeMarker start=/{{{/ end=/}}}/ containedin=@htmlPortholeContainer
syntax region portholeSection matchgroup=portholeMarker start='{{[#^/]' end=/}}/ containedin=@htmlPortholeContainer
syntax region portholePartial matchgroup=portholeMarker start=/{{[<>]/ end=/}}/
syntax region portholeMarkerSet matchgroup=portholeMarker start=/{{=/ end=/=}}/
syntax region portholeComment start=/{{!/ end=/}}/ contains=Todo containedin=htmlHead


" Clustering
syntax cluster portholeInside add=portholeVariable,portholeVariableUnescape,portholeSection,portholePartial,portholeMarkerSet
syntax cluster htmlPortholeContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6


" Hilighting
" portholeInside hilighted as Number, which is rarely used in html
" you might like change it to Function or Identifier
HtmlHiLink portholeVariable Number
HtmlHiLink portholeVariableUnescape Number
HtmlHiLink portholePartial Number
HtmlHiLink portholeSection Number
HtmlHiLink portholeMarkerSet Number

HtmlHiLink portholeComment Comment
HtmlHiLink portholeMarker Identifier
HtmlHiLink portholeError Error
HtmlHiLink portholeInsideError Error

let b:current_syntax = "porthole"
delcommand HtmlHiLink
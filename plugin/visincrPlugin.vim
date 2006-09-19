" visincrPlugin.vim: Visual-block incremented lists
"  Author:      Charles E. Campbell, Jr.  Ph.D.
"  Date:        Jul 18, 2006
"  Public Interface Only
"
"  (James 2:19,20 WEB) You believe that God is one. You do well!
"                      The demons also believe, and shudder.
"                      But do you want to know, vain man, that
"                      faith apart from works is dead?

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_visincrPlugin")
  finish
endif
let g:loaded_visincrPlugin = 1
let s:keepcpo              = &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Methods: {{{1
let s:I     =  0
let s:II    =  1
let s:IMDY  =  2
let s:IYMD  =  3
let s:IDMY  =  4
let s:ID    =  5
let s:IM    =  6
let s:IA    =  7
let s:IX    =  8
let s:IIX   =  9
let s:IO    = 10
let s:IIO   = 11
let s:IR    = 12
let s:IIR   = 13
let s:RI    = 14
let s:RII   = 15
let s:RIMDY = 16
let s:RIYMD = 17
let s:RIDMY = 18
let s:RID   = 19
let s:RIM   = 20

" ------------------------------------------------------------------------------
" Public Interface: {{{1
com! -ra -complete=expression -na=? I    call visincr#VisBlockIncr(s:I     , <f-args>)
com! -ra -complete=expression -na=* II   call visincr#VisBlockIncr(s:II    , <f-args>)
com! -ra -complete=expression -na=* IMDY call visincr#VisBlockIncr(s:IMDY  , <f-args>)
com! -ra -complete=expression -na=* IYMD call visincr#VisBlockIncr(s:IYMD  , <f-args>)
com! -ra -complete=expression -na=* IDMY call visincr#VisBlockIncr(s:IDMY  , <f-args>)
com! -ra -complete=expression -na=? ID   call visincr#VisBlockIncr(s:ID    , <f-args>)
com! -ra -complete=expression -na=? IM   call visincr#VisBlockIncr(s:IM    , <f-args>)
com! -ra -complete=expression -na=? IA	call visincr#VisBlockIncr(s:IA    , <f-args>)
com! -ra -complete=expression -na=? IX   call visincr#VisBlockIncr(s:IX    , <f-args>)
com! -ra -complete=expression -na=? IIX  call visincr#VisBlockIncr(s:IIX   , <f-args>)
com! -ra -complete=expression -na=? IO   call visincr#VisBlockIncr(s:IO    , <f-args>)
com! -ra -complete=expression -na=? IIO  call visincr#VisBlockIncr(s:IIO   , <f-args>)
com! -ra -complete=expression -na=? IR   call visincr#VisBlockIncr(s:IR    , <f-args>)
com! -ra -complete=expression -na=? IIR  call visincr#VisBlockIncr(s:IIR   , <f-args>)

com! -ra -complete=expression -na=? RI    call visincr#VisBlockIncr(s:RI   , <f-args>)
com! -ra -complete=expression -na=* RII   call visincr#VisBlockIncr(s:RII  , <f-args>)
com! -ra -complete=expression -na=* RIMDY call visincr#VisBlockIncr(s:RIMDY, <f-args>)
com! -ra -complete=expression -na=* RIYMD call visincr#VisBlockIncr(s:RIYMD, <f-args>)
com! -ra -complete=expression -na=* RIDMY call visincr#VisBlockIncr(s:RIDMY, <f-args>)
com! -ra -complete=expression -na=? RID   call visincr#VisBlockIncr(s:RID  , <f-args>)
com! -ra -complete=expression -na=? RIM   call visincr#VisBlockIncr(s:RIM  , <f-args>)

" ---------------------------------------------------------------------
"  Restoration And Modelines: {{{1
"  vim: ts=4 fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo

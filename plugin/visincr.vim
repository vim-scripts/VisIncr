" visincr.vim: Visual-block incremented lists
"  Author:      Charles E. Campbell, Jr.  Ph.D.
"  Date:        Aug 24, 2004
"  Version:     11
"
"				Visincr assumes that a block of numbers selected by a
"				ctrl-v (visual block) has been selected for incrementing.
"				This function will transform that block of numbers into
"				an incrementing column starting from that topmost number
"				in the visual block.  Also handles dates, daynames, and
"				monthnames.
"
"  Fancy Stuff:
"				* If the visual block is ragged right (as can happen when "$"
"				  is used to select the right hand side), the block will have
"				  spaces appended to straighten it out
"				* If the strlen of the count exceeds the visual-block
"				  allotment of spaces, then additional spaces will be inserted
"				* Handles leading tabs by using virtual column calculations
"
" GetLatestVimScripts: 670 1 :AutoInstall: visincr.vim

" ---------------------------------------------------------------------
" Exit quickly when VisBlockIncr has already been loaded or when 'compatible' is set {{{1
if exists("loaded_visblockincr") || &cp
  finish
endif
let loaded_visblockincr= "v7"

" ------------------------------------------------------------------------------
" Public Interface: {{{1
com! -ra -na=? I    call <SID>VisBlockIncr(0,<f-args>)
com! -ra -na=* II   call <SID>VisBlockIncr(1,<f-args>)
com! -ra -na=? IMDY call <SID>VisBlockIncr(2,<f-args>)
com! -ra -na=? IYMD call <SID>VisBlockIncr(3,<f-args>)
com! -ra -na=? IDMY call <SID>VisBlockIncr(4,<f-args>)
com! -ra -na=? ID   call <SID>VisBlockIncr(5,<f-args>)
com! -ra -na=? IM   call <SID>VisBlockIncr(6,<f-args>)
com! -ra -na=? IA	call <SID>VisBlockIncr(7,<f-args>)

com! -ra -na=? RI    call <SID>VisBlockIncr(10,<f-args>)
com! -ra -na=* RII   call <SID>VisBlockIncr(11,<f-args>)
com! -ra -na=? RIMDY call <SID>VisBlockIncr(12,<f-args>)
com! -ra -na=? RIYMD call <SID>VisBlockIncr(13,<f-args>)
com! -ra -na=? RIDMY call <SID>VisBlockIncr(14,<f-args>)
com! -ra -na=? RID   call <SID>VisBlockIncr(15,<f-args>)
com! -ra -na=? RIM   call <SID>VisBlockIncr(16,<f-args>)

" ------------------------------------------------------------------------------
" Options:
if !exists("g:visincr_leaddate")
 " choose between dates such as 11/ 5/04 and 11/05/04
 let g:visincr_leaddate = '0'
endif

" ------------------------------------------------------------------------------
" VisBlockIncr:	{{{1
fun! <SID>VisBlockIncr(mode,...)
"  call Dfunc("VisBlockIncr(mode<".a:mode."> a:0=".a:0)

  " save boundary line numbers
  " and set up mode
  let y1   = line("'<")
  let y2   = line("'>")
  let mode = (a:mode >= 10)? a:mode - 10 : a:mode

  " get increment (default=1)
  if a:0 > 0
   let incr= a:1
  else
   let incr= 1
  endif

  " set up restriction pattern
  let leftcol = virtcol("'<")
  let rghtcol = virtcol("'>")
  if leftcol > rghtcol
   let leftcol = virtcol("'>")
   let rghtcol = virtcol("'<")
  endif
  let width= rghtcol - leftcol + 1
"  call Decho("width= [rghtcol=".rghtcol."]-[leftcol=".leftcol."]+1=".width)

  if     a:mode == 10	" :I
   let restrict= '\%'.col(".").'c\d'
"   call Decho(":I restricted<".restrict.">")
  elseif a:mode == 11	" :II
   let restrict= '\%'.col(".").'c\s\{,'.width.'}\d'
"   call Decho(":II restricted<".restrict.">")
  elseif a:mode == 12	" :IMDY
   let restrict= '\%'.col(".").'c\d\{1,2}/\d\{1,2}/\d\{2,4}'
"   call Decho(":IMDY restricted<".restrict.">")
  elseif a:mode == 13	" :IYMD
   let restrict= '\%'.col(".").'c\d\{2,4}/\d\{1,2}/\d\{1,2}'
"   call Decho(":IYMD restricted<".restrict.">")
  elseif a:mode == 14	" :IDMY
   let restrict= '\%'.col(".").'c\d\{1,2}/\d\{1,2}/\d\{2,4}'
"   call Decho(":IDMY restricted<".restrict.">")
  elseif a:mode == 15	" :ID
   let restrict= '\c\%'.col(".").'c\(mon\|tue\|wed\|thu\|fri\|sat\|sun\)'
"   call Decho(":ID restricted<".restrict.">")
  elseif a:mode == 16	" :IM
   let restrict= '\c\%'.col(".").'c\(jan\|feb\|mar\|apr\|may\|jun\|jul\|aug\|sep\|oct\|nov\|dec\)'
"   call Decho(":IM restricted<".restrict.">")
  endif

  if mode >= 2
   " IMDY  IYMD  IDMY  ID  IM
   let rghtcol = rghtcol + 1
   let curline = getline("'<")

   if mode == 5
    " ID
    let pat    = '^.*\%'.leftcol.'v\(\a\+\)\%'.rghtcol.'v.*$'
    let dow    = substitute(substitute(curline,pat,'\1','e'),' ','','ge')
    let dowlen = strlen(dow)
"	call Decho("pat<".pat."> dow<".dow."> dowlen=".dowlen)
	if     dow =~ '\c\<mon'
	 let idow= 0
	elseif dow =~ '\c\<tue'
	 let idow= 1
	elseif dow =~ '\c\<wed'
	 let idow= 2
	elseif dow =~ '\c\<thu'
	 let idow= 3
	elseif dow =~ '\c\<fri'
	 let idow= 4
	elseif dow =~ '\c\<sat'
	 let idow= 5
	elseif dow =~ '\c\<sun'
	 let idow= 6
	else
	 echoerr "***error*** misspelled day-of-week <".dow.">"
	endif
	if strlen(dow) > 3
"	 call Decho("set up long daynames")
	 let dow_0= "Monday"
	 let dow_1= "Tuesday"
	 let dow_2= "Wednesday"
	 let dow_3= "Thursday"
	 let dow_4= "Friday"
	 let dow_5= "Saturday"
	 let dow_6= "Sunday"
	else
"	 call Decho("set up short daynames")
	 let dow_0= "Mon"
	 let dow_1= "Tue"
	 let dow_2= "Wed"
	 let dow_3= "Thu"
	 let dow_4= "Fri"
	 let dow_5= "Sat"
	 let dow_6= "Sun"
	endif
    norm! `<
    let l = y1
    while l < y2
   	 norm! j
"	 call Decho("[l=".l."] still < [y2=".y2."] line=".line(".")." col[".leftcol.",".rghtcol."]")
	 if exists("restrict") && getline(".") !~ restrict
	  let l= l + 1
	  continue
	 endif
	 let idow= (idow + incr)%7
	 exe 's/\%'.leftcol.'v.*\%(\%'.rghtcol.'v\|\>\)/'.dow_{idow}.'/e'
	 let l= l + 1
	endw
	" return from ID
"    call Dret("VisBlockIncr : ID")
   	return
   endif
   if mode == 6
    " IM
    let pat    = '^.*\%'.leftcol.'v\(\a\+\)\%'.rghtcol.'v.*$'
    let mon    = substitute(substitute(curline,pat,'\1','e'),' ','','ge')
    let monlen = strlen(mon)
	if     mon =~ '\cjan'
	 let imon= 0
	elseif mon =~ '\cfeb'
	 let imon= 1
	elseif mon =~ '\cmar'
	 let imon= 2
	elseif mon =~ '\capr'
	 let imon= 3
	elseif mon =~ '\cmay'
	 let imon= 4
	elseif mon =~ '\cjun'
	 let imon= 5
	elseif mon =~ '\cjul'
	 let imon= 6
	elseif mon =~ '\caug'
	 let imon= 7
	elseif mon =~ '\csep'
	 let imon= 8
	elseif mon =~ '\coct'
	 let imon= 9
	elseif mon =~ '\cnov'
	 let imon= 10
	elseif mon =~ '\cdec'
	 let imon= 11
	else
	 echoerr "***error*** misspelled day-of-week <".mon.">"
	endif
	if strlen(mon) > 3
	 let mon_0 = "January"
	 let mon_1 = "February"
	 let mon_2 = "March"
	 let mon_3 = "April"
	 let mon_4 = "May"
	 let mon_5 = "June"
	 let mon_6 = "July"
	 let mon_7 = "August"
	 let mon_8 = "September"
	 let mon_9 = "October"
	 let mon_10= "November"
	 let mon_11= "December"
	else
	 let mon_0 = "Jan"
	 let mon_1 = "Feb"
	 let mon_2 = "Mar"
	 let mon_3 = "Apr"
	 let mon_4 = "May"
	 let mon_5 = "Jun"
	 let mon_6 = "Jul"
	 let mon_7 = "Aug"
	 let mon_8 = "Sep"
	 let mon_9 = "Oct"
	 let mon_10= "Nov"
	 let mon_11= "Dec"
	endif
    norm! `<
    let l = y1
    while l < y2
   	 norm! j
	 if exists("restrict") && getline(".") !~ restrict
	  let l= l + 1
	  continue
	 endif
	 let imon= (imon + incr)%12
	 exe 's/\%'.leftcol.'v.*\%(\%'.rghtcol.'v\|\>\)/'.mon_{imon}.'/e'
	 let l= l + 1
	endw
	" return from IM
"    call Dret("VisBlockIncr : IM")
   	return
   endif
   if mode == 7
   	" IA
	let pat    = '^.*\%'.leftcol.'v\(\a\).*$'
	let letter = substitute(curline,pat,'\1','e')
	if letter !~ '\a'
	 let letter= 'A'
	endif
	if letter =~ '[a-z]'
	 let alphabet='abcdefghijklmnopqrstuvwxyz'
	else
	 let alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	endif
	let ilet= stridx(alphabet,letter)

    norm! `<
    let l = y1
    while l <= y2
"	 call Decho("letter<".letter."> l=".l." ilet=".ilet)
	 exe 's/\%'.leftcol.'v.*\%'.rghtcol.'v/'.letter.'/e'
	 let ilet   = (ilet + incr)%26
	 let letter = strpart(alphabet,ilet,1)
	 if l < y2
   	  silent norm! j
	 endif
	 let l= l + 1
	endw
	" return from IA
"    call Dret("VisBlockIncr : IA")
	return
   endif

   let pat= '^.*\%'.leftcol.'v\( \=[0-9]\{1,4}\)/\( \=[0-9]\{1,2}\)/\( \=[0-9]\{1,4}\)\%'.rghtcol.'v.*$'
   if mode == 2
   	" IMDY
    let m     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let d     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let y     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 2
"    call Decho("IMDY: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)
   elseif mode == 3
   	"  IYMD
    let y     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let m     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let d     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 1
"    call Decho("IYMD: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)
   elseif mode == 4
   	"  IDMY
    let d     = substitute(substitute(curline,pat,'\1',''),' ','','ge')+0
    let m     = substitute(substitute(curline,pat,'\2',''),' ','','ge')+0
    let y     = substitute(substitute(curline,pat,'\3',''),' ','','ge')+0
	let type  = 3
"    call Decho("IDMY: y=".y." m=".m." d=".d." leftcol=".leftcol." rghtcol=".rghtcol)
   else
   	echoerr "***error in <visincr.vim> script"
   endif
   let julday= Cal2Jul(y,m,d)
   norm! `<
   let l = y1
   while l <= y2
	 if exists("restrict") && getline(".") !~ restrict
	  norm! j
	  let l= l + 1
	  continue
	 endif
	let doy   = Jul2Cal(julday,type)
	if type == 1
	 " IYMD
     let doy   = substitute(doy,'^\d/',g:visincr_leaddate.'&','e')
     let doy   = substitute(doy,'/\(\d/\)','/'.g:visincr_leaddate.'\1','e')
     let doy   = substitute(doy,'/\(\d\)$','/'.g:visincr_leaddate.'\1','e')
	else
	 " IMDY IDMY
     let doy   = substitute(doy,'^\d/',' &','e')
     let doy   = substitute(doy,'/\(\d/\)','/'.g:visincr_leaddate.'\1','e')
     let doy   = substitute(doy,'/\(\d\)$','/'.g:visincr_leaddate.'\1','e')
	endif
	let doy   = escape(doy,'/')
	exe 's/\%'.leftcol.'v.*\%'.rghtcol.'v/'.doy.'/e'
    let l     = l + 1
	let julday= julday + incr
	if l <= y2
   	 norm! j
	endif
   endw
"   call Dret("VisBlockIncr : IMDY  IYMD  IDMY  ID  IM")
   return
  endif

  " :I or :II (mode is 0 or 1)
  if a:0 > 1 && mode
   let zfill= a:2
  else
   let zfill= ' '
  endif
"  call Decho("mode=".mode."  y1=".y1."  y2=".y2."  incr=".incr."  zfill<".zfill.">")

  " construct a line from the first line that
  " only has the number in it
  let rml   = rghtcol - leftcol
  let rmlp1 = rml  + 1
  let lm1   = leftcol  - 1
"  call Decho("rghtcol=".rghtcol." leftcol=".leftcol." rmlp1=".rmlp1." lm1=".lm1)
  if lm1 <= 0
   let lm1 = 1
   let pat = '^\([0-9 \t]\{1,'.rmlp1.'}\).*$'
   let cnt = substitute(getline("'<"),pat,'\1',"")
  else
   let pat = '^\(.\{-}\)\%'.leftcol.'v\([0-9 \t]\{1,'.rmlp1.'}\).*$'
   let cnt = substitute(getline("'<"),pat,'\2',"")
  endif
  let cntlen = strlen(cnt)
  let cnt    = substitute(cnt,'\s','',"ge")
  let ocnt   = cnt
  let cnt    = substitute(cnt,'^0*\([1-9]\|0$\)','\1',"ge")
"  call Decho("cnt=".cnt." pat<".pat.">")

  " left-mode with zeros
  " IF  top number is zero-modeded
  " AND we're justified right
  " AND increment is positive
  " AND user didn't specify a modeding character
  if a:0 < 2 && mode > 0 && cnt != ocnt && incr > 0
   let zfill= '0'
  endif

  " determine how much modeding is needed
  let maxcnt   = cnt + incr*(y2 - y1)
  let maxcntlen= strlen(maxcnt)
  if cntlen > maxcntlen
   let maxcntlen= cntlen
  endif
"  call Decho("maxcntlen=".maxcntlen)

  " go through visual block incrementing numbers based
  " on first number (saved in cnt), taking care to
  " avoid issuing "0h" commands.
  norm! `<
  let l = y1
  while l <= y2
"   call Decho("[l=".l."] still <= [y2=".y2."]")
	if exists("restrict") && getline(".") !~ restrict
"	 call Decho("skipping <".getline(".")."> (restrict)")
	 norm! j
	 let l= l + 1
	 continue
	endif
    let cntlen= strlen(cnt)

	" Straighten out ragged-right visual-block selection
	" by appending spaces as needed
	norm! $
	while virtcol("$") <= rghtcol
	 exe "norm! A \<Esc>"
	endwhile
	norm! 0

	" convert visual block line to all spaces
	if virtcol(".") != leftcol
	 exe 'norm! /\%'.leftcol."v\<Esc>"
	endif
    exe "norm! " . rmlp1 . "r "

	" cnt has gotten bigger than the visually-selected
	" area allows.  Will insert spaces to accommodate it.
	if maxcntlen > 0
	 let ins= maxcntlen - rmlp1
	else
	 let ins= strlen(cnt) - rmlp1
	endif
    while ins > 0
     exe "norm! i \<Esc>"
     let ins= ins - 1
    endwhile

	" back up to left-of-block (plus optional left-hand-side modeding)
	norm! 0
	if mode == 0
	 let bkup= leftcol
	elseif maxcntlen > 0
	 let bkup= leftcol + maxcntlen - cntlen
	else
	 let bkup= leftcol
	endif
"	call Decho("cnt=".cnt." bkup= [leftcol=".leftcol."]+[maxcntlen=".maxcntlen."]-[cntlen=".cntlen."]=".bkup)
	if virtcol(".") != bkup
	 exe 'norm! /\%'.bkup."v\<Esc>"
	endif

	" replace with count
	exe "norm! R" . cnt . "\<Esc>"
	if cntlen > 1
	 let cntlenm1= cntlen - 1
	 exe "norm! " . cntlenm1 . "h"
	endif
	if zfill != " "
	 let gdkeep= &gd
	 set nogd
	 silent! exe 's/\%'.leftcol.'v\( \+\)/\=substitute(submatch(1)," ","'.zfill.'","ge")/e'
	 let &gd= gdkeep
	endif

	" set up for next line
	if l != y2
	 norm! j
	endif
    let cnt= cnt + incr
    let l  = l  + 1
  endw

"  call Dret("VisBlockIncr")
endfun

" ------------------------------------------------------------------------------
"  vim: ts=4 fdm=marker
" HelpExtractor:
set lz
let docdir = substitute(expand("<sfile>:r").".txt",'\<plugin[/\\].*$','doc','')
if !isdirectory(docdir)
 if has("win32")
  echoerr 'Please make '.docdir.' directory first'
  unlet docdir
  finish
 elseif !has("mac")
  exe "!mkdir ".docdir
 endif
endif

let curfile = expand("<sfile>:t:r")
let docfile = substitute(expand("<sfile>:r").".txt",'\<plugin\>','doc','')
exe "silent! 1new ".docfile
silent! %d
exe "silent! 0r ".expand("<sfile>:p")
silent! 1,/^" HelpExtractorDoc:$/d
exe 'silent! %s/%FILE%/'.curfile.'/ge'
exe 'silent! %s/%DATE%/'.strftime("%b %d, %Y").'/ge'
norm! Gdd
silent! wq!
exe "helptags ".substitute(docfile,'^\(.*doc.\).*$','\1','e')

exe "silent! 1new ".expand("<sfile>:p")
1
silent! /^" HelpExtractor:$/,$g/.*/d
silent! wq!

set nolz
unlet docdir
unlet curfile
"unlet docfile
finish

" ---------------------------------------------------------------------
" Put the help after the HelpExtractorDoc label...
" HelpExtractorDoc:
*visincr.txt*	The Visual Incrementing Tool		Aug 24, 2004

Author:  Charles E. Campbell, Jr.  <cec@NgrOyphSon.gPsfAc.nMasa.gov>
	  (remove NOSPAM from Campbell's email before using)

==============================================================================
1. Contents				*visincr* *viscinr-contents*

	1. Contents ....................: |visincr|
	2. Quick Usage .................: |visincr-usage|
	3. Increasing/Decreasing Lists..: |viscinr-increase| |viscinr-decrease|
	   :I [#] ......................: |visincr-I|
	   :II [# [zfill]] .............: |visincr-II|
	   :IYMD [#] ...................: |visincr-IYMD|
	   :IMDY [#] ...................: |visincr-IMDY|
	   :IDMY [#] ...................: |visincr-IDMY|
	   :IA [#] .....................: |visincr-IA|
	   :ID [#] .....................: |visincr-ID|
	   :IM [#] .....................: |visincr-IM|
	4. Examples.....................: |visincr-examples|
	   :I ..........................: |ex-viscinr-I|
	   :II .........................: |ex-viscinr-II|
	   :IMDY .......................: |ex-viscinr-IMDY|
	   :IYMD .......................: |ex-viscinr-IYMD|
	   :IDMY .......................: |ex-viscinr-IDMY|
	   :IA .........................: |ex-viscinr-IA|
	   :ID .........................: |ex-viscinr-ID|
	5. History .....................: |visincr-history|

==============================================================================
2. Quick Usage				*visincr-usage*

	Use ctrl-v to visually select a column of numbers.  Then

		:I [#]  will use the first line's number as a starting point
			default increment (#) is 1
			will justify left (pad right)
			For more see |visincr-I|

		:II [# [zfill]]
			will use the first line's number as a starting point
			default increment (#) is 1
			default zfill         is a blank (ex. :II 1 0)
			will justify right (pad left)
			For more see |visincr-II|

			     ORIG      I        II
			     +---+   +----+   +----+
			     | 8 |   | 8  |   |  8 |
			     | 8 |   | 9  |   |  9 |
			     | 8 |   | 10 |   | 10 |
			     | 8 |   | 11 |   | 11 |
			     +---+   +----+   +----+

		The following three commands need <calutil.vim> to do
		their work:

		:IYMD [#] Increment year/month/day dates (by optional # days)
		:IMDY [#] Increment month/day/year dates (by optional # days)
		:IDMY [#] Increment day/month/year dates (by optional # days)
		For more: see |visincr-IYMD|, |visincr-IMDY|, and |visincr-IDMY|

		:ID  Increment days by name (Monday, Tuesday, etc).  If only
		     three or fewer letters are highlighted, then only
		     three-letter abbreviations will be used.
		     For more: see |visincr-ID|

		:IA  Increment alphabetic lists
		     For more: see |visincr-IA|

		:IM  Increment months by name (January, February, etc).
		     Like ID, if three or fewer letters are highlighted,
		     then only three-letter abbreviations will be used.
		     For more: see |visincr-IM|

		:RI RII RIYMD RIMDY RIDMY RID RM
		     Restricted variants of the above commands - requires
		     that the visual block on the current line start with
		     an appropriate pattern (ie. a number for :I, a
		     dayname for :ID, a monthname for :IM, etc).
		     For more, see |visincr-RI|, |visincr-RII|, |visincr-RIYMD|,
		     |visincr-RIMDY|, |visincr-RIDMY|, |visincr-RID|, and
		     |visincr-M|.


==============================================================================
3. Increasing/Decreasing Lists		*visincr-increase* *visincr-decrease*
					*visincr-increment* *visincr-decrement*

The visincr plugin facilitates making a column of increasing or decreasing
numbers, dates, or daynames.

					*I* *viscinr-I* *RI*
	LEFT JUSTIFIED INCREMENTING
	:I [#]  Will use the first line's number as a starting point to build
	        a column of increasing numbers (or decreasing numbers if the
		increment is negative).

		    Default increment: 1
		    Justification    : left (will pad on the right)

		Restricted version (:RI) applies number incrementing only to
		those lines in the visual block that begin with a number.

		See |visincr-raggedright| for a discussion on ragged-right
		handling.


	RIGHT JUSTIFIED INCREMENTING			*II* *visincr-II* *RII*
	:II [# [zfill]]  Will use the first line's number as a starting point
		to build a column of increasing numbers (or decreasing numbers
		if the increment is negative).

		    Default increment: 1
		    Justification    : right (will pad on the left)
		    Zfill            : left padding will be done with the given
		                       character, typically a zero.

		Restricted version (:RII) applies number incrementing only to
		those lines in the visual block that begin with zero or more
		spaces and end with a number.

	RAGGED RIGHT HANDLING FOR I AND II	*visincr-raggedright*
		For :I and :II:

		If the visual block is ragged on the right-hand side (as can
		easily happen when the "$" is used to select the
		right-hand-side), the block will have spaces appended to
		straighten it out.  If the string length of the count exceeds
		the visual-block, then additional spaces will be inserted as
		needed.  Leading tabs are handled by using virtual column
		calculations.

	DATE INCREMENTING
	:IYMD [#]    year/month/day	*IYMD*	*visincr-IYMD* *RIYMD*
	:IMDY [#]    month/day/year	*IMDY*	*visincr-IMDY* *RIMDY*
	:IDMY [#]    day/month/year	*IDMY*	*visincr-IDMY* *RIDMY*
		Will use the starting line's date to construct an increasing
		or decreasing list of dates, depending on the sign of the
		number.

		    Default increment: 1 (in days)

		Restricted versions (:RIYMD, :RIMDY, :RIDMY) applies number
		incrementing only to those lines in the visual block that
		begin with a date (#/#/#).


	SINGLE DIGIT DAYS OR MONTHS

		Single digit days or months are converted into two characters
		by use of
>
			g:visincr_leaddate
<
		which, by default, is '0'.  If you prefer blanks, simply put
>
			let g:visincr_leaddate= ' '
<
		into your <.vimrc> file.


	CALUTIL NEEDED FOR DATE INCREMENTING
		For :IYMD, :IMDY, and IDMY:

		You'll need the <calutil.vim> plugin, available as
		"Calendar Utilities" under the following url:

		http://www.erols.com/astronaut/vim/index.html#VimFuncs

	ALPHABETIC INCREMENTING				*IA* *visincr-IA*
	:IA	Will produce an increasing/decreasing list of alphabetic
		characters.

	DAYNAME INCREMENTING				*ID* *visincr-ID* *RID*
	:ID [#]	Will produce an increasing/decreasing list of daynames.  Three-letter
	        daynames will be used if the first day on the first line is a three
		letter dayname; otherwise, full names will be used.

		Restricted version (:RID) applies number incrementing only
		to those lines in the visual block that begin with a dayname
		(mon tue wed thu fri sat).

	MONTHNAME INCREMENTING		*IM* *visincr-IM* *RIM*
	:IM [#] will produce an increasing/decreasing list of monthnames.  Monthnames
		may be three-letter versions (jan feb etc) or fully-spelled out
		monthnames.

		Restricted version (:RIM) applies number incrementing only
		to those lines in the visual block that begin with a
		monthname (jan feb mar etc).


==============================================================================
4. Examples:						*visincr-examples*


	LEFT JUSTIFIED INCREMENTING EXAMPLES
	:I                              :I 2            *ex-visincr-I*
	            Use ctrl-V to                   Use ctrl-V to
	Original    Select, :I          Original    Select, :I 2
	   8            8                  8            8
	   8            9                  8            10
	   8            10                 8            12
	   8            11                 8            14
	   8            12                 8            16

	:I -1                           :I -2
	            Use ctrl-V to                   Use ctrl-V to
	Original    Select, :I -1       Original    Select, :I -3
	   8            8                  8            8
	   8            7                  8            5
	   8            6                  8            2
	   8            5                  8            -1
	   8            4                  8            -4


	RIGHT JUSTIFIED INCREMENTING EXAMPLES
	:II                             :II 2           *ex-visincr-II*
	            Use ctrl-V to                   Use ctrl-V to
	Original    Select, :II         Original    Select, :II 2
	   8             8                 8             8
	   8             9                 8            10
	   8            10                 8            12
	   8            11                 8            14
	   8            12                 8            16

	:II -1                          :II -2
	            Use ctrl-V to                   Use ctrl-V to
	Original    Select, :II -1      Original    Select, :II -3
	   8            8                  8             8
	   8            7                  8             5
	   8            6                  8             2
	   8            5                  8            -1
	   8            4                  8            -4


	DATE INCREMENTING EXAMPLES
	:IMDY                                   *ex-visincr-IMDY*
	          Use ctrl-V to                   Use ctrl-V to
	Original  Select, :IMDY         Original  Select, :IMDY 7
	06/10/03     6/10/03            06/10/03     6/10/03
	06/10/03     6/11/03            06/10/03     6/11/03
	06/10/03     6/12/03            06/10/03     6/12/03
	06/10/03     6/13/03            06/10/03     6/13/03
	06/10/03     6/14/03            06/10/03     6/14/03


	:IYMD                                   *ex-visincr-IYMD*
	          Use ctrl-V to                   Use ctrl-V to
	Original  Select, :IYMD         Original  Select, :IYMD 7
	03/06/10    03/06/10            03/06/10    03/06/10
	03/06/10    03/06/11            03/06/10    03/06/17
	03/06/10    03/06/12            03/06/10    03/06/24
	03/06/10    03/06/13            03/06/10    03/07/ 1
	03/06/10    03/06/14            03/06/10    03/07/ 8


	:IDMY                                   *ex-visincr-IDMY*
	          Use ctrl-V to                   Use ctrl-V to
	Original  Select, :IDMY         Original  Select, :IDMY 7
	10/06/03    10/06/03            10/06/03    10/06/03
	10/06/03    11/06/03            10/06/03    17/06/03
	10/06/03    12/06/03            10/06/03    24/06/03
	10/06/03    13/06/03            10/06/03     1/07/03
	10/06/03    14/06/03            10/06/03     8/07/03


	ALPHABETIC INCREMENTING EXAMPLES
	:IA                                     *ex-visincr-IA*
	          Use ctrl-V to                 Use ctrl-V to
	Original  Select, :IA         Original  Select, :IA 2
	   a)          a)                A)           A)
	   a)          b)                A)           C)
	   a)          c)                A)           E)
	   a)          d)                A)           G)


	DAYNAME INCREMENTING EXAMPLES
	:ID                                     *ex-visincr-ID*
	          Use ctrl-V to                 Use ctrl-V to
	Original  Select, :ID         Original  Select, :ID 2
	  Sun       Sun                 Sun         Sun
	  Sun       Mon                 Sun         Tue
	  Sun       Tue                 Sun         Thu
	  Sun       Wed                 Sun         Sat
	  Sun       Thu                 Sun         Mon


	:ID
	          Use ctrl-V to                 Use ctrl-V to
	Original  Select, :ID         Original  Select, :ID 2
	 Sunday     Sunday             Sunday     Sunday
	 Sunday     Monday             Sunday     Monday
	 Sunday     Tuesday            Sunday     Tuesday
	 Sunday     Wednesday          Sunday     Wednesday
	 Sunday     Thursday           Sunday     Thursday


	MONTHNAME INCREMENTING EXAMPLES
	:IM                                     *ex-visincr-IM*
	          Use ctrl-V to                 Use ctrl-V to
	Original  Select, :IM         Original  Select, :IM 2
	  Jan       Jan                 Jan       Jan
	  Jan       Feb                 Jan       Mar
	  Jan       Mar                 Jan       May
	  Jan       Apr                 Jan       Jul
	  Jan       May                 Jan       Sep

	:IM
	          Use ctrl-V to                 Use ctrl-V to
	Original  Select, :IM         Original  Select, :IM 2
	 January    January            January    January
	 January    February           January    March
	 January    March              January    May
	 January    April              January    July
	 January    May                January    September


==============================================================================
5. History:						*visincr-history*


	v11: 08/24/04       : g:visincr_leaddate implemented
	v10: 07/26/04       : IM and ID now handle varying length long-names
	                      selected via |linewise-visual| mode
	v9 : 03/05/04       : included IA command
	v8 : 06/24/03       : added IM command
	                      added RI .. RM commands (restricted)
	v7 : 06/09/03       : bug fix -- years now retain leading zero
	v6 : 05/29/03       : bug fix -- pattern for IMDY IDMY IYMD didn't work
	                      with text on the sides of dates; it now does
	v5 : II             : implements 0-filling automatically if
	                      the first number has the format  0000...0#
	     IYMD IMDY IDMY : date incrementing, uses <calutil.vim>
	     ID             : day-of-week incrementing
	v4 : gdefault option bypassed (saved/set nogd/restored)

vim: tw=78:ts=8:ft=help

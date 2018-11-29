# VisIncr

This is a mirror of http://www.vim.org/scripts/script.php?script_id=670

## Function
The visincr plugin facilitates making a column of increasing or decreasing
numbers, dates, or daynames.

## Installation

This plug-in required `isort`.

`pip install isort`

`plug 'fisadev/vim-isort'`

**Vim**

Add the following in your `~/.vimrac` in the plug-in section


if you are using **vim-plug** manager:

```
call plug#begin('~/.vim/plugged')
...

Plug 'vim-scripts/VisIncr'

...
call plug#end()
```

**Neovim**

Add the same in the plug-in section in vim config file `~/.config/nvim/init.vim`

## Usage
First, select a column using visual-block (ctrl-v) and move the cursor.

Second, choose what sort of incremented list you want:


## Commands

| Command                                                                                                                                                       | Description                                                                                                                                                                                                                                                                                                               |
| -----------------------------------                                                                                                                           | ------------------------------------------------------------------                                                                                                                                                                                                                                                        |
| :I [#]                                                                                                                                                        | Will use the first line's number as a starting point to build a column of increasing numbers (or decreasing numbers if the increasement is negative).<br>Default increment: 1<br>Justification: left (will pad on the right)                                                                                              |
| :I [#]                                                                                                                                                        | Will use the first line's number as a starting point to build a column of increasing numbers (or decreasing numbers if the increment is negative).<br>Default increment: 1<br>Justification: left (will pad on the right)                                                                                                 |
| :II [# [zfill]]                                                                                                                                               | Will use the first line's number as a starting point to build a column of increasing numbers (or decreasing numbers if the increment is negative).<br>Default increment: 1<br>Justification    : right (will pad on the left)<br>Zfill            : left padding will be done with the given character, typically a zero. |
| :IYMD [#] year/month/day<br>:IMDY [#] month/day/year<br>:IDMY [#] day/month/year| Will use the starting line's date to construct an increasing or decreasing list of dates, depending on the sign of the number. Default increment: 1 (in days)
| :ID [#] | Will produce an increasing/decreasing list of daynames.  Three-letter daynames will be used if the first day on the first line is a three letter dayname; otherwise, full names will be used.|
|:IO [#]<br>:IIO [#] [zfill] | Like :I and :II, except visincr creates octal numbers.|
|    :IR [#]<br>:IIR [#] [zfill]| Like :I and :II, except visincr uses Roman numerals.  Negative and zero counts are not supported for Roman numerals.|
|    :IX [#]<br>:IIX [#] [zfill]| Like :I and :II, except visincr creates hexadecimal numbers.|

###    EXTRA NOTES
- For `:I :II :IO :IIO :IR :IIR` :

If the visual block is ragged on the right-hand side (as can
easily happen when the "$" is used to select the
right-hand-side), the block will have spaces appended to
straighten it out.  If the string length of the count exceeds
the visual-block, then additional spaces will be inserted as
needed.  Leading tabs are handled by using virtual column
calculations.

- For `:IR and :IIR` :

Since Roman numerals vary considerably in their lengths for
nearby numbers, an additional two spaces will be included.

- For `:IYMD, :IMDY, and IDMY` :

You'll need the <calutil.vim> plugin, available as
"Calendar Utilities" under the following url:

http://mysite.verizon.net/astronaut/vim/index.html#CALUTIL

- Help is included, too -- check out  :he visincr-examples to see
even more examples of each command in action.

## Examples:

Following section provides some samples on each commands.

`:I`: Use ctrl-V to select the original block, `ESC` to Normal mode, use command `:I` to reformat the selected

| Original                | ctrl-V & `:I`              |
| ----------------------- | -------------------------- |
| 8<br>8<br>8<br>8<br>8   | 8<br>9<br>10<br>11<br>12   |


`:I -1`: Decreasing number by 1 from the beginning

| Original                | ctrl-V & `:I -1`        |
| ----------------------- | ----------------------- |
| 8<br>8<br>8<br>8<br>8   | 8<br>7<br>6<br>5<br>4   |


`:II`: Increase the number by 1 (right justification)

| Original                | ctrl-V & `:II`        |
| ----------------------- | ----------------------- |
| 8<br>8<br>8<br>8<br>8   | 8<br>9<br>10<br>11<br>12   |


`:II -1`: Decreasing number by 1 from the beginning (left justification)

| Original                   | ctrl-V & `:I -1`           |
| -----------------------    | -----------------------    |
| 11<br>10<br>9_<br>8_<br>7_ | 11<br>10<br>_9<br>_8<br>_7 |


`:IMDY`: MM/DD/YY Increase the Date by 1

| Original | ctrl-V & `:IMDY` |
|----------|------------------|
| 06/10/03 | 6/10/03          |
| 06/10/03 | 6/11/03          |
| 06/10/03 | 6/12/03          |
| 06/10/03 | 6/13/03          |
| 06/10/03 | 6/14/03          |


`:IYMD`: Increase the Year by 1
| Original | ctrl-V & `:IMDY` |
|----------|------------------|
| 03/06/10 | 03/06/10         |
| 03/06/10 | 03/06/11         |
| 03/06/10 | 03/06/12         |
| 03/06/10 | 03/06/13         |
| 03/06/10 | 03/06/14         |


`:IDMY`: YYMMDD Increase Year by 1

| Original | ctrl-V & `:IDMY` |
|----------|----------------|
| 10/06/03 | 10/06/03         |
| 10/06/03 | 11/06/03         |
| 10/06/03 | 12/06/03         |
| 10/06/03 | 13/06/03         |
| 10/06/03 | 14/06/03         |


`:ID`: Week

| Original | ctrl-V & `:ID` |
|----------|----------------|
| Sun      | Sun            |
| Sun      | Mon            |
| Sun      | Tue            |
| Sun      | Wed            |
| Sun      | Thu            |


`:IA`: Increase with character secquence

| Original | ctrl-V & `:IA` |
|----------|----------------|
| a        | a              |
| a        | b              |
| a        | c              |
| a        | d              |
| a        | e              |


`:IO`: Increate number by 1 (left justification)

| Original | ctrl-V & `:IO` |
|----------|----------------|
| 5        | 5              |
| 5        | 6              |
| 5        | 7              |
| 5        | 10             |
| 5        | 11             |


`:IR`: Increate with Roman numerals.

| Original | ctrl-V & `:IR` |
|----------|----------------|
| II       | II             |
| II       | III            |
| II       | IV             |
| II       | V              |
| II       | VI             |


`:IR`: Increate with Roman numerals.

| Original | ctrl-V & `:IR` |
|----------|----------------|
| 8        | 8              |
| 8        | 9              |
| 8        | a              |
| 8        | b              |
| 8        | c              |


-------------
## SEE ALSO 
-------------
**vis**     : vimscript#1195 : apply any ex command (ex. `:s/../../`) to a visual block

**vissort** : vimtip#588     : how to sort a visual block (or sort based on one)

**visincr** : http://mysite.verizon.net/astronaut/vim/index.html#VISINCR (for the latest, albeit experimental, release)

" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin\vimwiki.vim	[[[1
63
" VimWiki plugin file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 28.11.2008 16:08
" Version:     0.5.1


if exists("loaded_vimwiki") || &cp
  finish
endif
let loaded_vimwiki = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:default(varname,value)
  if !exists('g:vimwiki_'.a:varname)
    let g:vimwiki_{a:varname} = a:value
  endif
endfunction

"" Could be redefined by users
call s:default('home',"")
call s:default('index',"index")
call s:default('ext','.wiki')
call s:default('upper','A-ZА-Я')
call s:default('lower','a-zа-я')
call s:default('maxhi','1')
call s:default('other','0-9_')
call s:default('smartCR',1)
call s:default('stripsym','_')
call s:default('home_html',g:vimwiki_home."html/")
call s:default('syntax','default')

call s:default('history',[])

let upp = g:vimwiki_upper
let low = g:vimwiki_lower
let oth = g:vimwiki_other
let nup = low.oth
let nlo = upp.oth
let any = upp.nup

let g:vimwiki_word1 = '\C\<['.upp.']['.nlo.']*['.low.']['.nup.']*['.upp.']['.any.']*\>'
" let g:vimwiki_word2 = '\[\[['.upp.low.oth.'[:punct:][:space:]]\{-}\]\]'
let g:vimwiki_word2 = '\[\[[^\]]\+\]\]'
let g:vimwiki_rxWikiWord = g:vimwiki_word1.'\|'.g:vimwiki_word2

execute 'autocmd! BufNewFile,BufReadPost,BufEnter *'.g:vimwiki_ext.' set ft=vimwiki'

if !hasmapto('<Plug>VimwikiGoHome')
  map <silent><unique>  <Leader>ww <Plug>VimwikiGoHome
endif
noremap <unique> <script> <Plug>VimwikiGoHome :call vimwiki#WikiGoHome()<CR>

if !hasmapto('<Plug>VimwikiExploreHome')
  map <silent><unique>  <Leader>wh <Plug>VimwikiExploreHome
endif
noremap <unique> <script> <Plug>VimwikiExploreHome :execute "Explore ".g:vimwiki_home<CR>

ftplugin\vimwiki.vim	[[[1
92
" Vim filetype plugin file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 02.12.2008 17:13
" Version:     0.5.1

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1  " Don't load another plugin for this buffer


"" Defaults
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Reset the following options to undo this plugin.
let b:undo_ftplugin = "setl tw< wrap< lbr< fenc< ff< sua< isf< awa< com< fo< fdt< fdm< fde< commentstring<"

setlocal textwidth=0
setlocal wrap
setlocal linebreak
setlocal fileencoding=utf-8
setlocal fileformat=unix
setlocal autowriteall
" for gf
execute 'setlocal suffixesadd='.g:vimwiki_ext
setlocal isfname-=[,]

if g:vimwiki_smartCR>=2
  setlocal comments=b:*,b:#
  setlocal formatoptions=ctnqro
endif

" folding for Headers using syntax fold method.
setlocal fdm=syntax

setlocal commentstring=<!--%s-->


"" keybindings {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <buffer> <Up>   gk
nmap <buffer> k      gk
vmap <buffer> <Up>   gk
vmap <buffer> k      gk

nmap <buffer> <Down> gj
nmap <buffer> j      gj
vmap <buffer> <Down> gj
vmap <buffer> j      gj

imap <buffer> <Down>   <C-o>gj
imap <buffer> <Up>     <C-o>gk

nmap <silent><buffer> <CR> :call vimwiki#WikiFollowWord('nosplit')<CR>
nmap <silent><buffer> <S-CR> :call vimwiki#WikiFollowWord('split')<CR>
nmap <silent><buffer> <C-CR> :call vimwiki#WikiFollowWord('vsplit')<CR>

nmap <buffer> <S-LeftMouse> <NOP>
nmap <buffer> <C-LeftMouse> <NOP>
noremap <silent><buffer> <2-LeftMouse> :call vimwiki#WikiFollowWord('nosplit')<CR>
noremap <silent><buffer> <S-2-LeftMouse> <LeftMouse>:call vimwiki#WikiFollowWord('split')<CR>
noremap <silent><buffer> <C-2-LeftMouse> <LeftMouse>:call vimwiki#WikiFollowWord('vsplit')<CR>

nmap <silent><buffer> <BS> :call vimwiki#WikiGoBackWord()<CR>
"<BS> mapping doesn't work in vim console
nmap <silent><buffer> <C-h> :call vimwiki#WikiGoBackWord()<CR>
nmap <silent><buffer> <RightMouse><LeftMouse> :call vimwiki#WikiGoBackWord()<CR>

nmap <silent><buffer> <TAB> :call vimwiki#WikiNextWord()<CR>
nmap <silent><buffer> <S-TAB> :call vimwiki#WikiPrevWord()<CR>

nmap <silent><buffer> <Leader>wd :call vimwiki#WikiDeleteWord()<CR>
nmap <silent><buffer> <Leader>wr :call vimwiki#WikiRenameWord()<CR>

if g:vimwiki_smartCR==1
  inoremap <silent><buffer><CR> <CR><Space><C-O>:call vimwiki#WikiNewLine('checkup')<CR>
  noremap <silent><buffer>o o<Space><C-O>:call vimwiki#WikiNewLine('checkup')<CR>
  noremap <silent><buffer>O O<Space><C-O>:call vimwiki#WikiNewLine('checkdown')<CR>
endif
" keybindings }}}

"" commands {{{2
" command! -nargs=1 Wiki2HTML call WikiExportHTML(expand(<f-args>))
command! Wiki2HTML call vimwiki#Wiki2HTML(g:vimwiki_home_html, expand('%'))
command! WikiAll2HTML call vimwiki#WikiAll2HTML(g:vimwiki_home_html)

"" commands 2}}}

autoload\vimwiki.vim	[[[1
919
" VimWiki plugin file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 24.11.2008 18:36
" Version:     0.5.1

if exists("g:loaded_vimwiki_auto") || &cp
  finish
endif
let g:loaded_vimwiki_auto = 1

let s:wiki_badsymbols = '[<>|?*/\:"]'

"" vimwiki functions {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:msg(message) "{{{
  echohl WarningMsg
  echomsg 'vimwiki: '.a:message
  echohl None
endfunction "}}}

function! s:getFileNameOnly(filename) "{{{
  let word = substitute(a:filename, '\'.g:vimwiki_ext, "", "g")
  let word = substitute(word, '.*[/\\]', "", "g")
  return word
endfunction "}}}

function! s:editfile(command, filename) "{{{
  let fname = escape(a:filename, '% ')
  execute a:command.' '.fname

  " if fname is new
  " if g:vimwiki_addheading!=0 && glob(fname) == ''
  " execute 'normal I! '.s:getfilename(fname)
  " update
  " endif
endfunction "}}}

function! s:SearchWord(wikiRx,cmd) "{{{
  let hl = &hls
  let lasts = @/
  let @/ = a:wikiRx
  set nohls
  try
    :silent exe 'normal ' a:cmd
  catch /Pattern not found/
    call s:msg('WikiWord not found')
  endt
  let @/ = lasts
  let &hls = hl
endfunction "}}}

function! s:WikiGetWordAtCursor(wikiRX) "{{{
  let col = col('.') - 1
  let line = getline('.')
  let ebeg = -1
  let cont = match(line, a:wikiRX, 0)
  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, a:wikiRX, cont)
    if (cont <= col) && (col < contn)
      let ebeg = match(line, a:wikiRX, cont)
      let elen = contn - ebeg
      break
    else
      let cont = match(line, a:wikiRX, contn)
    endif
  endwh
  if ebeg >= 0
    return strpart(line, ebeg, elen)
  else
    return ""
  endif
endf "}}}

function! s:WikiStripWord(word, sym) "{{{
  function! s:WikiStripWordHelper(word, sym)
    return substitute(a:word, s:wiki_badsymbols, a:sym, 'g')
  endfunction

  let result = a:word
  if strpart(a:word, 0, 2) == "[["
    let result = s:WikiStripWordHelper(strpart(a:word, 2, strlen(a:word)-4), a:sym)
  endif
  return result
endfunction "}}}

function! s:WikiIsLinkToNonWikiFile(word) "{{{
  " Check if word is link to a non-wiki file.
  " The easiest way is to check if it has extension like .txt or .html
  if a:word =~ '\.\w\{1,4}$'
    return 1
  endif
  return 0
endfunction "}}}

"" WikiWord history helper functions {{{
" history is [['WikiWord.wiki', 11], ['AnotherWikiWord', 3] ... etc]
" where numbers are column positions we should return to when coming back.
function! s:GetHistoryWord(historyItem)
  return get(a:historyItem, 0)
endfunction
function! s:GetHistoryColumn(historyItem)
  return get(a:historyItem, 1)
endfunction
"}}}

function! vimwiki#WikiNextWord() "{{{
  call s:SearchWord(g:vimwiki_rxWikiWord, 'n')
endfunction "}}}

function! vimwiki#WikiPrevWord() "{{{
  call s:SearchWord(g:vimwiki_rxWikiWord, 'N')
endfunction "}}}

function! vimwiki#WikiFollowWord(split) "{{{
  if a:split == "split"
    let cmd = ":split "
  elseif a:split == "vsplit"
    let cmd = ":vsplit "
  else
    let cmd = ":e "
  endif
  let word = s:WikiStripWord(s:WikiGetWordAtCursor(g:vimwiki_rxWikiWord), g:vimwiki_stripsym)
  " insert doesn't work properly inside :if. Check :help :if.
  if word == ""
    execute "normal! \n"
    return
  endif
  if s:WikiIsLinkToNonWikiFile(word)
    call s:editfile(cmd, word)
  else
    call insert(g:vimwiki_history, [expand('%:p'), col('.')])
    call s:editfile(cmd, g:vimwiki_home.word.g:vimwiki_ext)
  endif
endfunction "}}}

function! vimwiki#WikiGoBackWord() "{{{
  if !empty(g:vimwiki_history)
    let word = remove(g:vimwiki_history, 0)
    " go back to saved WikiWord
    execute ":e ".s:GetHistoryWord(word)
    call cursor(line('.'), s:GetHistoryColumn(word))
  endif
endfunction "}}}

function! vimwiki#WikiNewLine(direction) "{{{
  "" direction == checkup - use previous line for checking
  "" direction == checkdown - use next line for checking
  function! s:WikiAutoListItemInsert(listSym, dir)
    let sym = escape(a:listSym, '*')
    if a:dir=='checkup'
      let linenum = line('.')-1
    else
      let linenum = line('.')+1
    end
    let prevline = getline(linenum)
    if prevline =~ '^\s\+'.sym
      let curline = substitute(getline('.'),'^\s\+',"","g")
      if prevline =~ '^\s*'.sym.'\s*$'
        " there should be easier way ...
        execute 'normal kA '."\<ESC>".'"_dF'.a:listSym.'JX'
        return 1
      endif
      let ind = indent(linenum)
      call setline(line('.'), strpart(prevline, 0, ind).a:listSym.' '.curline)
      call cursor(line('.'), ind+3)
      return 1
    endif
    return 0
  endfunction

  if s:WikiAutoListItemInsert('*', a:direction)
    return
  endif

  if s:WikiAutoListItemInsert('#', a:direction)
    return
  endif

  " delete <space>
  if getline('.') =~ '^\s\+$'
    execute 'normal x'
  else
    execute 'normal X'
  endif
endfunction "}}}

function! vimwiki#WikiHighlightWords() "{{{
  let wikies = glob(g:vimwiki_home.'*')
  "" remove .wiki extensions
  let wikies = substitute(wikies, '\'.g:vimwiki_ext, "", "g")
  let g:vimwiki_wikiwords = split(wikies, '\n')
  "" remove paths
  call map(g:vimwiki_wikiwords, 'substitute(v:val, ''.*[/\\]'', "", "g")')
  "" remove backup files (.wiki~)
  call filter(g:vimwiki_wikiwords, 'v:val !~ ''.*\~$''')

  for word in g:vimwiki_wikiwords
    if word =~ g:vimwiki_word1 && !s:WikiIsLinkToNonWikiFile(word)
      execute 'syntax match wikiWord /\<'.word.'\>/'
    else
      execute 'syntax match wikiWord /\[\['.substitute(word,  g:vimwiki_stripsym, s:wiki_badsymbols, "g").'\]\]/'
    endif
  endfor
endfunction "}}}

function! vimwiki#WikiGoHome()"{{{
  execute ':e '.g:vimwiki_home.g:vimwiki_index.g:vimwiki_ext
  let g:vimwiki_history = []
endfunction"}}}

function! vimwiki#WikiDeleteWord() "{{{
  "" file system funcs
  "" Delete WikiWord you are in from filesystem
  let val = input('Delete ['.expand('%').'] (y/n)? ', "")
  if val!='y'
    return
  endif
  let fname = expand('%:p')
  " call WikiGoBackWord()
  try
    call delete(fname)
  catch /.*/
    call s:msg('Cannot delete "'.expand('%:r').'"!')
    return
  endtry
  execute "bdelete! ".escape(fname, " ")

  " delete from g:vimwiki_history list
  call filter (g:vimwiki_history, 's:GetHistoryWord(v:val) != fname')
  " as we got back to previous WikiWord - delete it from history - as much
  " as possible
  let hword = ""
  while !empty(g:vimwiki_history) && hword == s:GetHistoryWord(g:vimwiki_history[0])
    let hword = s:GetHistoryWord(remove(g:vimwiki_history, 0))
  endwhile

  " reread buffer => deleted WikiWord should appear as non-existent
  execute "e"
endfunction "}}}

function! vimwiki#WikiRenameWord() "{{{
  "" Rename WikiWord, update all links to renamed WikiWord
  let wwtorename = expand('%:r')
  let isOldWordComplex = 0
  if wwtorename !~ g:vimwiki_word1
    let wwtorename = substitute(wwtorename,  g:vimwiki_stripsym, s:wiki_badsymbols, "g")
    let isOldWordComplex = 1
  endif

  " there is no file (new one maybe)
  if glob(g:vimwiki_home.expand('%')) == ''
    call s:msg('Cannot rename "'.expand('%').'". It does not exist! (New file? Save it before renaming.)')
    return
  endif

  let val = input('Rename "'.expand('%:r').'" (y/n)? ', "")
  if val!='y'
    return
  endif
  let newWord = input('Enter new name: ', "")
  " check newWord - it should be 'good', not empty
  if substitute(newWord, '\s', '', 'g') == ''
    call s:msg('Cannot rename to an empty filename!')
    return
  endif
  if s:WikiIsLinkToNonWikiFile(newWord)
    call s:msg('Cannot rename to a filename with extension (ie .txt .html)!')
    return
  endif

  if newWord !~ g:vimwiki_word1
    " if newWord is 'complex wiki word' then add [[]]
    let newWord = '[['.newWord.']]'
  endif
  let newFileName = s:WikiStripWord(newWord, g:vimwiki_stripsym).g:vimwiki_ext

  " do not rename if word with such name exists
  let fname = glob(g:vimwiki_home.newFileName)
  if fname != ''
    call s:msg('Cannot rename to "'.newFileName.'". File with that name exist!')
    return
  endif
  " rename WikiWord file
  try
    call rename(expand('%'), newFileName)
    bd
    "function call doesn't work
    call s:editfile('e', newFileName)
  catch /.*/
    call s:msg('Cannot rename "'.expand('%:r').'" to "'.newFileName.'"')
    return
  endtry

  " save open buffers
  let openbuffers = []
  let bcount = 1
  while bcount<=bufnr("$")
    if bufexists(bcount)
      call add(openbuffers, bufname(bcount))
    endif
    let bcount = bcount + 1
  endwhile

  " update links
  execute ':args '.g:vimwiki_home.'*'.g:vimwiki_ext
  if isOldWordComplex
    execute ':silent argdo %s/\[\['.wwtorename.'\]\]/'.newWord.'/geI | update'
  else
    execute ':silent argdo %s/\<'.wwtorename.'\>/'.newWord.'/geI | update'
  endif
  execute ':argd *'.g:vimwiki_ext

  " restore open buffers
  let bcount = 1
  while bcount<=bufnr("$")
    if bufexists(bcount)
      if index(openbuffers, bufname(bcount)) == -1
        execute 'silent bdelete '.escape(bufname(bcount), " ")
      end
    endif
    let bcount = bcount + 1
  endwhile

  "" DONE: after renaming GUI caption is a bit corrupted?
  "" FIXED: buffers menu is also not in the "normal" state, howto Refresh menu?
  "" TODO: Localized version of Gvim gives error -- Refresh menu doesn't exist
  execute "silent! emenu Buffers.Refresh\ menu"

endfunction "}}}

" Functions 2}}}

"" vimwiki html functions {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:WikiCreateDefaultCSS(path) " {{{
  if glob(a:path.'style.css') == ""
    let lines = ['body { margin: 1em 5em 1em 5em; font-size: 100%;}']
    call add(lines, 'p, ul {line-height: 1.5;}')
    call add(lines, '.todo {font-weight: bold; text-decoration: underline; color: #FF0000; }')
    call add(lines, '.strike {text-decoration: line-through; }')
    call add(lines, 'h1 {font-size: 2.0em;}')
    call add(lines, 'h2 {font-size: 1.4em;}')
    call add(lines, 'h3 {font-size: 1.0em;}')
    call add(lines, 'h4 {font-size: 0.8em;}')
    call add(lines, 'h5 {font-size: 0.7em;}')
    call add(lines, 'h6 {font-size: 0.6em;}')
    call add(lines, 'h1 { border-bottom: 1px solid #3366cc; text-align: left; padding: 0em 1em 0.3em 0em; }')
    call add(lines, 'h3 { background: #e5ecf9; border-top: 1px solid #3366cc; padding: 0.1em 0.3em 0.1em 0.5em; }')
    call add(lines, 'ul { margin-left: 2em; padding-left: 0.5em; }')
    call add(lines, 'pre { border-left: 0.2em solid #ccc; margin-left: 2em; padding-left: 0.5em; }')
    call add(lines, 'td { border: 1px solid #ccc; padding: 0.3em; }')
    call add(lines, 'hr { border: none; border-top: 1px solid #ccc; }')

    call writefile(lines, a:path.'style.css')
    echomsg "Default style.css is created."
  endif
endfunction "}}}

function! s:syntax_supported()
  return g:vimwiki_syntax == "default"
endfunction

function! vimwiki#WikiAll2HTML(path) "{{{
  if !s:syntax_supported()
    call s:msg('Wiki2Html: Only vimwiki_default syntax supported!!!')
    return
  endif

  if !isdirectory(a:path)
    call s:msg('Please create '.a:path.' directory first!')
    return
  endif

  let setting_more = &more
  setlocal nomore

  let wikifiles = split(glob(g:vimwiki_home.'*'.g:vimwiki_ext), '\n')
  for wikifile in wikifiles
    echomsg 'Processing '.wikifile
    call vimwiki#Wiki2HTML(a:path, wikifile)
  endfor
  call s:WikiCreateDefaultCSS(g:vimwiki_home_html)
  echomsg 'Wikifiles converted.'

  let &more = setting_more
endfunction "}}}

function! vimwiki#Wiki2HTML(path, wikifile) "{{{
  if !s:syntax_supported()
    call s:msg('Wiki2Html: Only vimwiki_default syntax supported!!!')
    return
  endif

  if !isdirectory(a:path)
    call s:msg('Please create '.a:path.' directory first!')
    return
  endif

  "" helper funcs
  function! s:isWebLink(lnk) "{{{
    if a:lnk =~ '^\(http://\|www.\|ftp://\)'
      return 1
    endif
    return 0
  endfunction "}}}
  function! s:isImgLink(lnk) "{{{
    if a:lnk =~ '.\(png\|jpg\|gif\|jpeg\)$'
      return 1
    endif
    return 0
  endfunction "}}}

  function! s:HTMLHeader(title, charset) "{{{
    let lines=[]
    call add(lines, "")
    call add(lines, '<html>')
    call add(lines, '<head>')
    call add(lines, '<link rel="Stylesheet" type="text/css" href="style.css" />')
    call add(lines, '<title>'.a:title.'</title>')
    call add(lines, '<meta http-equiv="Content-Type" content="text/html; charset='.a:charset.'" />')
    call add(lines, '</head>')
    call add(lines, '<body>')
    return lines
  endfunction "}}}

  function! s:HTMLFooter() "{{{
    let lines=[]
    call add(lines, "")
    call add(lines, '</body>')
    call add(lines, '</html>')
    return lines
  endfunction "}}}

  function! s:closeCode(code, ldest) "{{{
    if a:code
      call add(a:ldest, "</pre></code>")
      return 0
    endif
    return a:code
  endfunction "}}}

  function! s:closePre(pre, ldest) "{{{
    if a:pre
      call add(a:ldest, "</pre>")
      return 0
    endif
    return a:pre
  endfunction "}}}

  function! s:closeTable(table, ldest) "{{{
    if a:table
      call add(a:ldest, "</table>")
      return 0
    endif
    return a:table
  endfunction "}}}

  function! s:closeList(lists, ldest) "{{{
    while len(a:lists)
      let item = remove(a:lists, -1)
      call add(a:ldest, item[0])
    endwhile
  endfunction! "}}}

  " TODO: сделать так, чтобы {{{WikiWord}}} нормально отрабатывал
  function! s:processCode(line, code) "{{{
    let lines = []
    let code = a:code
    let processed = 0
    if !code && a:line =~ '^{{{\s*$'
      " if !code && a:line =~ g:vimwiki_rxPreStart
      let code = 1
      call add(lines, "<code><pre>")
      let processed = 1
    elseif code && a:line =~ '^}}}\s*$'
      " elseif code && a:line =~ g:vimwiki_rxPreEnd
      let code = 0
      call add(lines, "</pre></code>")
      let processed = 1
    elseif code
      let processed = 1
      call add(lines, a:line)
    endif
    return [processed, lines, code]
  endfunction "}}}

  function! s:processPre(line, pre) "{{{
    let lines = []
    let pre = a:pre
    let processed = 0
    if a:line =~ '^\s\+[^[:blank:]*#]'
      if !pre
        call add(lines, "<pre>")
        let pre = 1
      endif
      let processed = 1
      call add(lines, a:line)
    elseif pre && a:line =~ '^\s*$'
      let processed = 1
      call add(lines, a:line)
    elseif pre 
      call add(lines, "</pre>")
      let pre = 0
    endif
    return [processed, lines, pre]
  endfunction "}}}

  function! s:processList(line, lists) "{{{
    let lines = []
    let lstSym = ''
    let lstTagOpen = ''
    let lstTagClose = ''
    let lstRegExp = ''
    let processed = 0
    if a:line =~ '^\s\+\*'
      let lstSym = '*'
      let lstTagOpen = '<ul>'
      let lstTagClose = '</ul>'
      let lstRegExp = '^\s\+\*'
      let processed = 1
    elseif a:line =~ '^\s\+#' 
      let lstSym = '#'
      let lstTagOpen = '<ol>'
      let lstTagClose = '</ol>'
      let lstRegExp = '^\s\+#'
      let processed = 1
    endif
    if lstSym != ''
      let indent = stridx(a:line, lstSym)
      let cnt = len(a:lists)
      if !cnt || (cnt && indent > a:lists[-1][1])
        call add(a:lists, [lstTagClose, indent])
        call add(lines, lstTagOpen)
      elseif (cnt && indent < a:lists[-1][1])
        while indent < a:lists[-1][1]
          let item = remove(a:lists, -1)
          call add(lines, item[0])
        endwhile
      endif
      call add(lines, '<li>'.substitute(a:line, lstRegExp, '', '').'</li>')
    else
      while len(a:lists)
        let item = remove(a:lists, -1)
        call add(lines, item[0])
      endwhile
    endif
    return [processed, lines]
  endfunction "}}}

  function! s:processP(line) "{{{
    let lines = []
    if a:line =~ '^\S'
      call add(lines, '<p>'.a:line.'</p>')
      return [1, lines]
    endif
    return [0, lines]
  endfunction "}}}

  function! s:processHeading(line) "{{{
    let line = a:line
    let processed = 0
    if a:line =~ g:vimwiki_rxH6
      let line = '<h6>'.strpart(a:line, 6).'</h6>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH5
      let line = '<h5>'.strpart(a:line, 5).'</h5>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH4
      let line = '<h4>'.strpart(a:line, 4).'</h4>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH3
      let line = '<h3>'.strpart(a:line, 3).'</h3>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH2
      let line = '<h2>'.strpart(a:line, 2).'</h2>'
      let processed = 1
    elseif a:line =~ g:vimwiki_rxH1
      let line = '<h1>'.strpart(a:line, 1).'</h1>'
      let processed = 1
    endif
    return [processed, line]
  endfunction "}}}

  function! s:processHR(line) "{{{
    let line = a:line
    let processed = 0
    if a:line =~ '^-----*$'
      let line = '<hr />'
      let processed = 1
    endif
    return [processed, line]
  endfunction "}}}

  function! s:processTable(line, table) "{{{
    let table = a:table
    let lines = []
    let processed = 0
    if a:line =~ '^||.\+||.*'
      if !table
        call add(lines, "<table>")
        let table = 1
      endif
      let processed = 1

      call add(lines, "<tr>")
      let pos1 = 0
      let pos2 = 0
      let done = 0
      while !done
        let pos1 = stridx(a:line, '||', pos2)
        let pos2 = stridx(a:line, '||', pos1+2)
        if pos1==-1 || pos2==-1
          let done = 1
          let pos2 = len(a:line)
        endif
        let line = strpart(a:line, pos1+2, pos2-pos1-2)
        if line != ''
          call add(lines, "<td>".line."</td>")
        endif
      endwhile
      call add(lines, "</tr>")

    elseif table
      call add(lines, "</table>")
      let table = 0
    endif
    return [processed, lines, table]
  endfunction "}}}

  "" change dangerous html symbols - < > & (line)
  function! s:safeHTML(line) "{{{
    let line = substitute(a:line, '&', '\&amp;', 'g')
    let line = substitute(line, '<', '\&lt;', 'g')
    let line = substitute(line, '>', '\&gt;', 'g')
    return line
  endfunction "}}}

  "" Substitute text found by regexp_match with tagOpen.regexp_subst.tagClose
  function! s:MakeTagHelper(line, regexp_match, tagOpen, tagClose, cSymRemove, func) " {{{
    let pos = 0
    let lines = split(a:line, a:regexp_match, 1)
    let res_line = ""
    for line in lines
      let res_line = res_line.line
      let matched = matchstr(a:line, a:regexp_match, pos)
      if matched != ""
        let toReplace = strpart(matched, a:cSymRemove, len(matched)-2*a:cSymRemove)
        if a:func!=""
          let toReplace = {a:func}(escape(toReplace, '\&*[]?%'))
        else
          " let toReplace = a:tagOpen.escape(toReplace, '\&*[]?%').a:tagClose
          let toReplace = a:tagOpen.toReplace.a:tagClose
        endif
        let res_line = res_line.toReplace
      endif
      let pos = matchend(a:line, a:regexp_match, pos)
    endfor
    return res_line

  endfunction " }}}

  "" Make tags only if not in ` ... `
  "" ... should be function that process regexp_match deeper.
  function! s:MakeTag(line, regexp_match, tagOpen, tagClose, ...) " {{{
    "check if additional function exists
    let func = ""
    let cSym = 1
    if a:0 == 2
      let cSym = a:1
      let func = a:2
    elseif a:0 == 1
      let cSym = a:1
    endif

    let patt_splitter = g:vimwiki_rxCode
    " let patt_splitter = '\('.g:vimwiki_rxCode.'\)\|\(<a href.\{-}</a>\)\|\(<img src.\{-}/>\)'
    " TODO: make one regexp from g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd
    let patt_splitter = '\('.g:vimwiki_rxCode.'\)\|\('.g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd.'\)\|\(<a href.\{-}</a>\)\|\(<img src.\{-}/>\)'
    if g:vimwiki_rxCode == a:regexp_match || g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd == a:regexp_match
      let res_line = s:MakeTagHelper(a:line, a:regexp_match, a:tagOpen, a:tagClose, cSym, func)
    else
      let pos = 0
      let lines = split(a:line, patt_splitter, 1)
      let res_line = ""
      for line in lines
        let res_line = res_line.s:MakeTagHelper(line, a:regexp_match, a:tagOpen, a:tagClose, cSym, func)
        let res_line = res_line.matchstr(a:line, patt_splitter, pos)
        let pos = matchend(a:line, patt_splitter, pos)
      endfor
    endif
    return res_line
  endfunction " }}}

  "" Make <a href="link">link desc</a>
  "" from [link link desc]
  function! s:MakeExternalLink(entag) "{{{
    let line = ''
    if s:isWebLink(a:entag)
      let lnkElements = split(a:entag)
      let head = lnkElements[0]
      let rest = join(lnkElements[1:])
      if rest==""
        let rest=head
      endif
      if s:isImgLink(rest)
        if rest!=head
          let line = '<a href="'.head.'"><img src="'.rest.'" /></a>'
        else
          let line = '<img src="'.rest.'" />'
        endif
      else
        let line = '<a href="'.head.'">'.rest.'</a>'
      endif
    else
      if s:isImgLink(a:entag)
        let line = '<img src="'.a:entag.'" />'
      else
        let line = '<a href="'.a:entag.'">'.a:entag.'</a>'
      endif
    endif
    return line
  endfunction "}}}

  "" Make <a href="This is a link">This is a link</a>
  "" from [[This is a link]]
  function! s:MakeInternalLink(entag) "{{{
    let line = ''
    if s:isImgLink(a:entag)
      let line = '<img src="'.a:entag.'" />'
    else
      let line = '<a href="'.a:entag.'.html">'.a:entag.'</a>'
    endif
    return line
  endfunction "}}}

  "" Make <a href="WikiWord">WikiWord</a>
  "" from WikiWord
  function! s:MakeWikiWordLink(entag) "{{{
    let line = '<a href="'.a:entag.'.html">'.a:entag.'</a>'
    return line
  endfunction "}}}

  "" Make <a href="http://habamax.ru">http://habamax.ru</a>
  "" from http://habamax.ru
  function! s:MakeBareBoneLink(entag) "{{{
    if s:isImgLink(a:entag)
      let line = '<img src="'.a:entag.'" />'
    else
      let line = '<a href="'.a:entag.'">'.a:entag.'</a>'
    endif
    return line
  endfunction "}}}

  let lsource=readfile(a:wikifile)
  let ldest = s:HTMLHeader(s:getFileNameOnly(a:wikifile), &encoding)

  let pre = 0
  let code = 0
  let table = 0
  let lists = []

  for line in lsource
    let processed = 0
    let lines = []

    let line = s:safeHTML(line)

    "" Code
    if !processed
      let [processed, lines, code] = s:processCode(line, code)
      if processed && len(lists)
        call s:closeList(lists, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      call extend(ldest, lines)
    endif

    "" Pre
    if !processed
      let [processed, lines, pre] = s:processPre(line, pre)
      if processed && len(lists)
        call s:closeList(lists, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      call extend(ldest, lines)
    endif


    "" list
    if !processed
      let [processed, lines] = s:processList(line, lists)
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      call map(lines, 's:MakeTag(v:val, ''\[\[.\{-}\]\]'', '''', '''', 2, ''s:MakeInternalLink'')')
      call map(lines, 's:MakeTag(v:val, ''\[.\{-}\]'', '''', '''', 1, ''s:MakeExternalLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWeblink, '''', '''', 0, ''s:MakeBareBoneLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWikiWord, '''', '''', 0, ''s:MakeWikiWordLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxItalic, ''<em>'', ''</em>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxBold, ''<strong>'', ''</strong>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxTodo, ''<span class="todo">'', ''</span>'', 0)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxDelText, ''<span class="strike">'', ''</span>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSuperScript, ''<sup><small>'', ''</small></sup>'', 1)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSubScript, ''<sub><small>'', ''</small></sub>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxCode, ''<code>'', ''</code>'')')
      " TODO: change MakeTag function: delete cSym parameter -- count of symbols
      " to strip from 2 sides of tag. Add 2 new instead -- OpenWikiTag length
      " and CloseWikiTag length as for preformatted text there could be {{{,}}} and <pre>,</pre>.
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxPreStart.''.\+''.g:vimwiki_rxPreEnd, ''<code>'', ''</code>'', 3)')
      call extend(ldest, lines)
    endif

    "" table
    if !processed
      let [processed, lines, table] = s:processTable(line, table)
      call map(lines, 's:MakeTag(v:val, ''\[\[.\{-}\]\]'', '''', '''', 2, ''s:MakeInternalLink'')')
      call map(lines, 's:MakeTag(v:val, ''\[.\{-}\]'', '''', '''', 1, ''s:MakeExternalLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWeblink, '''', '''', 0, ''s:MakeBareBoneLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxWikiWord, '''', '''', 0, ''s:MakeWikiWordLink'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxItalic, ''<em>'', ''</em>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxBold, ''<strong>'', ''</strong>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxTodo, ''<span class="todo">'', ''</span>'', 0)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxDelText, ''<span class="strike">'', ''</span>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSuperScript, ''<sup><small>'', ''</small></sup>'', 1)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxSubScript, ''<sub><small>'', ''</small></sub>'', 2)')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxCode, ''<code>'', ''</code>'')')
      call map(lines, 's:MakeTag(v:val, g:vimwiki_rxPreStart.''.\+''.g:vimwiki_rxPreEnd, ''<code>'', ''</code>'', 3)')
      call extend(ldest, lines)
    endif

    if !processed
      let [processed, line] = s:processHeading(line)
      if processed
        call s:closeList(lists, ldest)
        let table = s:closeTable(table, ldest)
        let code = s:closeCode(code, ldest)
        call add(ldest, line)
      endif
    endif

    if !processed
      let [processed, line] = s:processHR(line)
      if processed
        call s:closeList(lists, ldest)
        let table = s:closeTable(table, ldest)
        let code = s:closeCode(code, ldest)
        call add(ldest, line)
      endif
    endif

    "" P
    if !processed
      let line = s:MakeTag(line, '\[\[.\{-}\]\]', '', '', 2, 's:MakeInternalLink')
      let line = s:MakeTag(line, '\[.\{-}\]', '', '', 1, 's:MakeExternalLink')
      let line = s:MakeTag(line, g:vimwiki_rxWeblink, '', '', 0, 's:MakeBareBoneLink')
      let line = s:MakeTag(line, g:vimwiki_rxWikiWord, '', '', 0, 's:MakeWikiWordLink')
      let line = s:MakeTag(line, g:vimwiki_rxItalic, '<em>', '</em>')
      let line = s:MakeTag(line, g:vimwiki_rxBold, '<strong>', '</strong>')
      let line = s:MakeTag(line, g:vimwiki_rxTodo, '<span class="todo">', '</span>', 0)
      let line = s:MakeTag(line, g:vimwiki_rxDelText, '<span class="strike">', '</span>', 2)
      let line = s:MakeTag(line, g:vimwiki_rxSuperScript, '<sup><small>', '</small></sup>', 1)
      let line = s:MakeTag(line, g:vimwiki_rxSubScript, '<sub><small>', '</small></sub>', 2)
      let line = s:MakeTag(line, g:vimwiki_rxCode, '<code>', '</code>')
      let line = s:MakeTag(line, g:vimwiki_rxPreStart.'.\+'.g:vimwiki_rxPreEnd, '<code>', '</code>', 3)
      let [processed, lines] = s:processP(line)
      if processed && pre
        let pre = s:closePre(pre, ldest)
      endif
      if processed && code
        let code = s:closeCode(code, ldest)
      endif
      if processed && table
        let table = s:closeTable(table, ldest)
      endif
      call extend(ldest, lines)
    endif

    "" add the rest
    if !processed
      call add(ldest, line)
    endif
  endfor

  "" process end of file
  "" close opened tags if any
  call s:closePre(pre, ldest)
  call s:closeCode(code, ldest)
  call s:closeList(lists, ldest)
  call s:closeTable(table, ldest)


  call extend(ldest, s:HTMLFooter())

  "" make html file.
  "" TODO: add html headings, css, etc.
  let wwFileNameOnly = s:getFileNameOnly(a:wikifile)
  call writefile(ldest, a:path.wwFileNameOnly.'.html')
endfunction "}}}

" 2}}}
syntax\vimwiki.vim	[[[1
122
" Vim syntax file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: 24.11.2008 10:15
" Version:     0.5.1

" Quit if syntax file is already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"" use max highlighting - could be quite slow if there are too many wikifiles
if g:vimwiki_maxhi
  " Every WikiWord is nonexistent
  execute 'syntax match wikiNoExistsWord /'.g:vimwiki_word1.'/'
  execute 'syntax match wikiNoExistsWord /'.g:vimwiki_word2.'/'
  " till we find them in g:vimwiki_home
  call vimwiki#WikiHighlightWords()
else
  " A WikiWord (unqualifiedWikiName)
  execute 'syntax match wikiWord /'.g:vimwiki_word1.'/'
  " A [[bracketed wiki word]]
  execute 'syntax match wikiWord /'.g:vimwiki_word2.'/'
endif


" text: "this is a link (optional tooltip)":http://www.microsoft.com
" TODO: check URL syntax against RFC
let g:vimwiki_rxWeblink = '\("[^"(]\+\((\([^)]\+\))\)\?":\)\?\(https\?\|ftp\|gopher\|telnet\|file\|notes\|ms-help\):\(\(\(//\)\|\(\\\\\)\)\+[A-Za-z0-9:#@%/;$~_?+-=.&\-\\\\]*\)'
execute 'syntax match wikiLink `'.g:vimwiki_rxWeblink.'`'

" Emoticons: must come after the Textilisms, as later rules take precedence
" over earlier ones. This match is an approximation for the ~70 distinct
syntax match wikiEmoticons /\((.)\|:[()|$@]\|:-[DOPS()\]|$@]\|;)\|:'(\)/

let g:vimwiki_rxTodo = '\(TODO:\|DONE:\|FIXME:\|FIXED:\)'
execute 'syntax match wikiTodo /'. g:vimwiki_rxTodo .'/'

" Load concrete Wiki syntax
execute 'runtime! syntax/vimwiki_'.g:vimwiki_syntax.'.vim'

execute 'syntax match wikiBold /'.g:vimwiki_rxBold.'/'

execute 'syntax match wikiItalic /'.g:vimwiki_rxItalic.'/'

execute 'syntax match wikiBoldItalic /'.g:vimwiki_rxBoldItalic.'/'

execute 'syntax match wikiDelText /'.g:vimwiki_rxDelText.'/'

execute 'syntax match wikiSuperScript /'.g:vimwiki_rxSuperScript.'/'

execute 'syntax match wikiSubScript /'.g:vimwiki_rxSubScript.'/'

execute 'syntax match wikiCode /'.g:vimwiki_rxCode.'/'

" Aggregate all the regular text highlighting into wikiText
syntax cluster wikiText contains=wikiItalic,wikiBold,wikiCode,wikiDelText,wikiSuperScript,wikiSubScript,wikiWord,wikiEmoticons

" Header levels, 1-6
execute 'syntax match wikiH1 /'.g:vimwiki_rxH1.'/'
execute 'syntax match wikiH2 /'.g:vimwiki_rxH2.'/'
execute 'syntax match wikiH3 /'.g:vimwiki_rxH3.'/'
execute 'syntax match wikiH4 /'.g:vimwiki_rxH4.'/'
execute 'syntax match wikiH5 /'.g:vimwiki_rxH5.'/'
execute 'syntax match wikiH6 /'.g:vimwiki_rxH6.'/'

" <hr>, horizontal rule
execute 'syntax match wikiHR /'.g:vimwiki_rxHR.'/'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
execute 'syntax match wikiTable /'.g:vimwiki_rxTable.'/'

" Bulleted list items start with whitespace(s), then '*'
" syntax match wikiList           /^\s\+\(\*\|[1-9]\+0*\.\).*$/   contains=@wikiText
" highlight only bullets and digits.
execute 'syntax match wikiList /'.g:vimwiki_rxListBullet.'/'
execute 'syntax match wikiList /'.g:vimwiki_rxListNumber.'/'

" Treat all other lines that start with spaces as PRE-formatted text.
execute 'syntax match wikiPre /'.g:vimwiki_rxPre1.'/'

execute 'syntax region wikiPre start=/'.g:vimwiki_rxPreStart.'/ end=/'.g:vimwiki_rxPreEnd.'/'
" FIXME: this is quite buggy...
" execute 'syntax sync match wikiPreSync grouphere wikiPre /'.g:vimwiki_rxPreStart.'/'


" Folding
execute 'syntax region wikiHeaderFolding start=/'.g:vimwiki_rxFoldHeadingStart.'/ end=/'.g:vimwiki_rxFoldHeadingEnd.'/ transparent fold'

hi def link wikiH1                    Title
hi def link wikiH2                    wikiH1
hi def link wikiH3                    wikiH2
hi def link wikiH4                    wikiH3
hi def link wikiH5                    wikiH4
hi def link wikiH6                    wikiH5
hi def link wikiHR                    wikiH6

hi def wikiBold                       term=bold cterm=bold gui=bold
hi def wikiItalic                     term=italic cterm=italic gui=italic
hi def wikiBoldItalic                 term=bold cterm=bold gui=bold,italic

hi def link wikiCode                  PreProc
hi def link wikiWord                  Underlined
hi def link wikiNoExistsWord          Error

hi def link wikiPre                   PreProc
hi def link wikiLink                  Underlined
hi def link wikiList                  Type
hi def link wikiTable                 PreProc
hi def link wikiEmoticons             Constant
hi def link wikiDelText               Comment
hi def link wikiInsText               Constant
hi def link wikiSuperScript           Constant
hi def link wikiSubScript             Constant
hi def link wikiTodo                  Todo

let b:current_syntax="vimwiki"

syntax\vimwiki_default.vim	[[[1
66
" Vim syntax file
" Language:    Wiki (vimwiki default)
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: [17.09.2008 - 18:54]
" Version:     0.5.1

" text: *strong*
" let g:vimwiki_rxBold = '\*[^*]\+\*'
let g:vimwiki_rxBold = '\(^\|\s\+\|[[:punct:]]\)\zs\*[^*`]\+\*\ze\([[:punct:]]\|\s\+\|$\)'

" text: _emphasis_
" let g:vimwiki_rxItalic = '_[^_]\+_'
let g:vimwiki_rxItalic = '\(^\|\s\+\|[[:punct:]]\)\zs_[^_`]\+_\ze\([[:punct:]]\|\s\+\|$\)'

" text: *_strong italic_* or _*italic strong*_
let g:vimwiki_rxBoldItalic = '\(^\|\s\+\|[[:punct:]]\)\zs\(\*_[^*_`]\+_\*\)\|\(_\*[^*_`]\+\*_\)\ze\([[:punct:]]\|\s\+\|$\)'

" text: `code`
let g:vimwiki_rxCode = '`[^`]\+`'

" text: ~~deleted text~~
let g:vimwiki_rxDelText = '\~\~[^~`]\+\~\~'

" text: ^superscript^
let g:vimwiki_rxSuperScript = '\^[^^`]\+\^'

" text: ,,subscript,,
let g:vimwiki_rxSubScript = ',,[^,`]\+,,'

" Header levels, 1-6
let g:vimwiki_rxH1 = '^!\{1}.*$'
let g:vimwiki_rxH2 = '^!\{2}.*$'
let g:vimwiki_rxH3 = '^!\{3}.*$'
let g:vimwiki_rxH4 = '^!\{4}.*$'
let g:vimwiki_rxH5 = '^!\{5}.*$'
let g:vimwiki_rxH6 = '^!\{6}.*$'

" <hr>, horizontal rule
let g:vimwiki_rxHR = '^----.*$'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
let g:vimwiki_rxTable = '||'

" Bulleted list items start with whitespace(s), then '*'
" syntax match wikiList           /^\s\+\(\*\|[1-9]\+0*\.\).*$/   contains=@wikiText
" highlight only bullets and digits.
" let g:vimwiki_rxList = '^\s\+\(\*\|#\)'
let g:vimwiki_rxListBullet = '^\s\+\*'
let g:vimwiki_rxListNumber = '^\s\+#'

" Treat all other lines that start with spaces as PRE-formatted text.
let g:vimwiki_rxPre1 = '^\s\+[^[:blank:]*#].*$'

" Preformatted text
" let g:vimwiki_rxPreStart = '^{{{\s*$'
" let g:vimwiki_rxPreEnd = '^}}}\s*$'
let g:vimwiki_rxPreStart = '{{{'
let g:vimwiki_rxPreEnd = '}}}'

" Header's folding
let g:vimwiki_rxFoldHeadingStart = '^!'
let g:vimwiki_rxFoldHeadingEnd = '\n\+\ze!'

" vim:tw=0:
syntax\vimwiki_google.vim	[[[1
65
" Vim syntax file
" Language:    Wiki
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: [17.09.2008 - 18:53]
" Version:     0.5.1

" text: *strong*
" let g:vimwiki_rxBold = '\*[^*]\+\*'
let g:vimwiki_rxBold = '\(^\|\s\+\|[[:punct:]]\)\zs\*[^*`]\+\*\ze\([[:punct:]]\|\s\+\|$\)'

" text: _emphasis_
" let g:vimwiki_rxItalic = '_[^_]\+_'
let g:vimwiki_rxItalic = '\(^\|\s\+\|[[:punct:]]\)\zs_[^_`]\+_\ze\([[:punct:]]\|\s\+\|$\)'

" text: *_strong italic_* or _*italic strong*_
let g:vimwiki_rxBoldItalic = '\(^\|\s\+\|[[:punct:]]\)\zs\(\*_[^*_`]\+_\*\)\|\(_\*[^*_`]\+\*_\)\ze\([[:punct:]]\|\s\+\|$\)'

" text: `code`
let g:vimwiki_rxCode = '`[^`]\+`'

" text: ~~deleted text~~
let g:vimwiki_rxDelText = '\~\~[^~`]\+\~\~'

" text: ^superscript^
let g:vimwiki_rxSuperScript = '\^[^^`]\+\^'

" text: ,,subscript,,
let g:vimwiki_rxSubScript = ',,[^,`]\+,,'

" Header levels, 1-6
let g:vimwiki_rxH1 = '^\s*=\{1}.*=\{1}\s*$'
let g:vimwiki_rxH2 = '^\s*=\{2}.*=\{2}\s*$'
let g:vimwiki_rxH3 = '^\s*=\{3}.*=\{3}\s*$'
let g:vimwiki_rxH4 = '^\s*=\{4}.*=\{4}\s*$'
let g:vimwiki_rxH5 = '^\s*=\{5}.*=\{5}\s*$'
let g:vimwiki_rxH6 = '^\s*=\{6}.*=\{6}\s*$'

" <hr>, horizontal rule
let g:vimwiki_rxHR = '^----.*$'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
let g:vimwiki_rxTable = '||'

" Bulleted list items start with whitespace(s), then '*'
" syntax match wikiList           /^\s\+\(\*\|[1-9]\+0*\.\).*$/   contains=@wikiText
" highlight only bullets and digits.
let g:vimwiki_rxListBullet = '^\s\+\*'
let g:vimwiki_rxListNumber = '^\s\+#'

" Treat all other lines that start with spaces as PRE-formatted text.
let g:vimwiki_rxPre1 = '^\s\+[^[:blank:]*#].*$'

" Preformatted text
" let g:vimwiki_rxPreStart = '^{{{\s*$'
" let g:vimwiki_rxPreEnd = '^}}}\s*$'
let g:vimwiki_rxPreStart = '{{{'
let g:vimwiki_rxPreEnd = '}}}'

" Header's folding
let g:vimwiki_rxFoldHeadingStart = '^=\+[^=]\+='
let g:vimwiki_rxFoldHeadingEnd = '\n\ze=\+[^=]\+='

" vim:tw=0:
syntax\vimwiki_media.vim	[[[1
60
" Vim syntax file
" Language:    Wiki (MediaWiki)
" Author:      Maxim Kim (habamax at gmail dot com)
" Home:        http://code.google.com/p/vimwiki/
" Filenames:   *.wiki
" Last Change: [17.09.2008 - 18:53]
" Version:     0.5.1

" text: '''strong'''
let g:vimwiki_rxBold = "'''[^']\\+'''"

" text: ''emphasis''
let g:vimwiki_rxItalic = "''[^']\\+''"

" text: '''''strong italic'''''
let g:vimwiki_rxBoldItalic = "'''''[^']\\+'''''"

" text: `code`
let g:vimwiki_rxCode = '`[^`]\+`'

" text: ~~deleted text~~
let g:vimwiki_rxDelText = '\~\~[^~]\+\~\~'

" text: ^superscript^
let g:vimwiki_rxSuperScript = '\^[^^]\+\^'

" text: ,,subscript,,
let g:vimwiki_rxSubScript = ',,[^,]\+,,'

" Header levels, 1-6
let g:vimwiki_rxH1 = '^\s*=\{1}.\+=\{1}\s*$'
let g:vimwiki_rxH2 = '^\s*=\{2}.\+=\{2}\s*$'
let g:vimwiki_rxH3 = '^\s*=\{3}.\+=\{3}\s*$'
let g:vimwiki_rxH4 = '^\s*=\{4}.\+=\{4}\s*$'
let g:vimwiki_rxH5 = '^\s*=\{5}.\+=\{5}\s*$'
let g:vimwiki_rxH6 = '^\s*=\{6}.\+=\{6}\s*$'

" <hr>, horizontal rule
let g:vimwiki_rxHR = '^----.*$'

" Tables. Each line starts and ends with '||'; each cell is separated by '||'
let g:vimwiki_rxTable = '||'

" Bulleted list items start with whitespace(s), then '*'
" highlight only bullets and digits.
let g:vimwiki_rxListBullet = '^\s*\*\+\([^*]*$\)\@='
let g:vimwiki_rxListNumber = '^\s*#\+'

" Treat all other lines that start with spaces as PRE-formatted text.
let g:vimwiki_rxPre1 = '^\s\+[^[:blank:]*#].*$'

" Preformatted text
let g:vimwiki_rxPreStart = '<pre>'
let g:vimwiki_rxPreEnd = '<\/pre>'

" Header's folding
let g:vimwiki_rxFoldHeadingStart = '^=\+[^=]\+='
let g:vimwiki_rxFoldHeadingEnd = '\n\ze=\+[^=]\+='

" vim:tw=0:
doc\vimwiki.txt	[[[1
495
*vimwiki.txt*  A Personal Wiki for Vim

     __  __  ______            __      __  ______   __  __   ______     ~
    /\ \/\ \/\__  _\   /'\_/`\/\ \  __/\ \/\__  _\ /\ \/\ \ /\__  _\    ~
    \ \ \ \ \/_/\ \/  /\      \ \ \/\ \ \ \/_/\ \/ \ \ \/'/'\/_/\ \/    ~
     \ \ \ \ \ \ \ \  \ \ \__\ \ \ \ \ \ \ \ \ \ \  \ \ , <    \ \ \    ~
      \ \ \_/ \ \_\ \__\ \ \_/\ \ \ \_/ \_\ \ \_\ \__\ \ \\`\   \_\ \__ ~
       \ `\___/ /\_____\\ \_\\ \_\ `\___x___/ /\_____\\ \_\ \_\ /\_____\~
        `\/__/  \/_____/ \/_/ \/_/'\/__//__/  \/_____/ \/_/\/_/ \/_____/~


                            Let the help begins ...~

                               Version: 0.5.1 ~

==============================================================================
CONTENTS                                                    *vimwiki-contents*

  1. Intro ...................................|vimwiki|
  2. Mappings ................................|vimwiki-mappings|
    2.1. Global mappings .....................|vimwiki-global-mappings|
    2.2. Local mappings ......................|vimwiki-local-mappings|
  3. Wiki syntax .............................|vimwiki-syntax|
    3.1. Typeface ............................|vimwiki-typeface|
    3.2. Links ...............................|vimwiki-links|
    3.3. Headers .............................|vimwiki-headers|
    3.4. Paragraphs...........................|vimwiki-paragraphs|
    3.5. Lists ...............................|vimwiki-lists|
    3.6. Pre .................................|vimwiki-pre|
  4. Commands ................................|vimwiki-commands|
  5. Options .................................|vimwiki-options|
  6. Help ....................................|vimwiki-help|
  7. Author ..................................|vimwiki-author|
  8. Changelog ...............................|vimwiki-changelog|
  9. License .................................|vimwiki-license|


==============================================================================
1. Intro                                                             *vimwiki*

Vimwiki being a personal wiki for Vim allows you to organize text information
using hyperlinks. To do a quick start add the following to your vimrc: >
    :let g:vimwiki_home = "~/mywiki/"

Change "~/mywiki/" to whatever path you prefer. Make sure it exists and you
can read and write to that path.

Now restart vim and press <Leader>ww to go to your index wiki file.
Feed it with the following example (copy&paste without and between ---) :

---
! My knowledge base
  * ProjectGuttenberg -- good books are power.
  * MyUrgentTasks -- things I to be done _yesterday_!!!
  * MusicILike, MusicIHate.
---

Notice that ProjectGuttenberg, MyUrgentTasks, MusicILike and MusicIHate
highlighted as errors. Theese WikiWords (WikiWord or WikiPage --
capitalized word connected with other capitalized words) do not exist yet.

Place cursor on ProjectGuttenberg and press Enter. Now
you are in ProjectGuttenberg. Edit and save it, then press Backspace to return
to previous WikiPage. You should see the difference in highliting now.

Now begin to add your own information ...

==============================================================================
2. Mappings                                                 *vimwiki-mappings*

There are global and local mappings in vimwiki.

------------------------------------------------------------------------------
2.1. Global mappings                                 *vimwiki-global-mappings*

<Leader>ww or <Plug>VimwikiGoHome
        Open vimwiki's main file.
        To redefine: >
        :map <Leader>w <Plug>VimwikiGoHome
<

<Leader>wh or <Plug>VimwikiExploreHome
        Open vimwiki's home directory.
        To redefine: >
        :map <Leader>h <Plug>VimwikiExploreHome
<

------------------------------------------------------------------------------
2.1. Local mappings                                   *vimwiki-local-mappings*

Normal mode (Keyboard):~
<Leader>wd              Delete WikiWord you are in.
<Leader>wr              Rename WikiWord you are in.
<CR>                    Folow/Create WikiWord.
<S-CR>                  Split and folow/create WikiWord
<C-CR>                  Vertical split and folow/create WikiWord
<Backspace>             Go back to previous WikiWord
<Tab>                   Find next WikiWord
<S-Tab>                 Find previous WikiWord

Normal mode (Mouse): ~
<2-LeftMouse>           Follow/Create WikiWord
<S-2-LeftMouse>         Split and follow/create WikiWord
<C-2-LeftMouse>         Vertical split and follow/create WikiWord
<RightMouse><LeftMouse> Go back to previous WikiWord

Note: <2-LeftMouse> is just left double click.

==============================================================================
3. Wiki syntax                                                *vimwiki-syntax*

There are a lot of different wikies out there. Most of them have their own
syntax and vimwiki is not an exception here. Default vimwiki's syntax is quite
similar to what google's wiki has. With the noticeable difference in headings
markup.

As for MediaWiki's syntax -- the most used wiki syntax in the world -- it is
not that convenient for non english keyboard layouts to emphasize text as it
uses a lot of '''''' to do it. You have to switch layouts everytime you want
some bold non english text. This is the answer to "Why not MediaWiki?"

Nevertheless, there is MediaWiki syntax file included in the distribution (it
doesn't have all the fancy stuff original MediaWiki syntax has though). As the
Google's one. To switch add the following to your vimrc: >
    let g:vimwiki_syntax = "media"
or: >
    let g:vimwiki_syntax = "google"


------------------------------------------------------------------------------
3.1. Typeface                                               *vimwiki-typeface*

There are a few typefaces that gives you a bit of control on how your
text should be decorated: >
  *bold text*
  _italic text_
  ~~strikeout text~~
  `code (no syntax) text`
  super^script^
  sub,,script,,

------------------------------------------------------------------------------
3.2. Links                                                     *vimwiki-links*

Internal links:
  CapitalizedWordsConnected
or:
  [[This is a link]]

External links effects are visible after export to HTML.
Plain link:
  http://code.google.com/p/vimwiki

Link with description
  [http://habamax.ru/blog habamax home page]

Image link is the link with one of jpg, png or gif endings.
Plain image link:
  http://someaddr.com/picture.jpg

Image thumbnail link:
  [http://someaddr.com/bigpicture.jpg http://someaddr.com/thumbnail.jpg]

------------------------------------------------------------------------------
3.3. Headers                                                 *vimwiki-headers*
! Header level 1
!! Header level 2
!!! Header level 3
!!!! Header level 4
!!!!! Header level 5
!!!!!! Header level 6

------------------------------------------------------------------------------
3.4. Paragraphs                                           *vimwiki-paragraphs*

Every line started from column 0 (zero) is a paragraph if it is not a list,
table or preformatted text.

------------------------------------------------------------------------------
3.5. Lists                                                     *vimwiki-lists*
Indent lists with at least one space:
  * Bulleted list item 1
  * Bulleted list item 2
    * Bulleted list subitem 1
    * Bulleted list subitem 2
    * more ...
      * and more ...
      * ...
    * Bulleted list subitem 3
    * etc

The same goes for numbered lists:
  # Numbered list item 1
  # Numbered list item 2
    # Numbered list subitem 1
    # Numbered list subitem 2
    # more ...
      # and more ...
      # ...
    # Numbered list subitem 3
    # etc

It is possible to mix bulleted and numbered lists.

------------------------------------------------------------------------------
3.6. Tables                                                   *vimwiki-tables*

Tables are created by entering the content of each cell separated by ||
delimiters. You can insert other inline wiki syntax in table cells, including
typeface formatting and links.
For example:

||*Year*s||*Temperature (low)*||*Temperature (high)*||
||1900   ||-10                ||25                  ||
||1910   ||-15                ||30                  ||
||1920   ||-10                ||32                  ||
||1930   ||_N/A_              ||_N/A_               ||
||1940   ||-2                 ||40                  ||


------------------------------------------------------------------------------
3.7. Pre                                                         *vimwiki-pre*

If the line started from whitespace and is not a list it is "preformatted" text.
For example: >

  Tyger! Tyger! burning bright
   In the forests of the night,
    What immortal hand or eye
     Could frame thy fearful symmetry?
  In what distant deeps or skies
   Burnt the fire of thine eyes?
    On what wings dare he aspire?
     What the hand dare sieze the fire?
  ...
  ...

Or use {{{ and }}} to define pre:
{{{ >
  Tyger! Tyger! burning bright
   In the forests of the night,
    What immortal hand or eye
     Could frame thy fearful symmetry?
  In what distant deeps or skies
   Burnt the fire of thine eyes?
    On what wings dare he aspire?
     What the hand dare sieze the fire?
}}}

It could be started from column 0.

==============================================================================
4. Commands                                                 *vimwiki-commands*
:Wiki2HTML
        Convert current WikiPage to HTML.

:WikiAll2HTML
        Convert all WikiPages to HTML.

You should set up & create html directory.
By default it is g:vimwiki_home/html/ so just go to g:vimwiki_home and create
html directory there.

==============================================================================
5. Options                                                   *vimwiki-options*

------------------------------------------------------------------------------
Default: ""                                                   *g:vimwiki_home*
Values: path

Set your wiki files home directory: >
    let g:vimwiki_home = "~/mywiki/"

Change "~/mywiki/" to whatever you prefer -- "d:/vimwiki/" for example.
Make sure it exists and you can read and write to that path.

Note: this option is a MUST.

------------------------------------------------------------------------------
Default: g:vimwiki_home."html"                           *g:vimwiki_home_html*
Values: path

Set up directory for wiki files converted to HTML: >
    let g:vimwiki_home_html = '~/my wiki/html/'

------------------------------------------------------------------------------
Default: "index"                                             *g:vimwiki_index*
Values: filename without extension

If you don't like index.wiki as the main wiki file change it: >
    let g:vimwiki_index = "homesweethome"

Note: there is NO .wiki extension

------------------------------------------------------------------------------
Default: ".wiki"                                               *g:vimwiki_ext*
Values: file extension

If you don't want .wiki extension change it: >
    let g:vimwiki_ext = ".shmiki"


------------------------------------------------------------------------------
Default: "default"                                          *g:vimwiki_syntax*
Values: "default", "media" or "google"

You can use different markup languages (currently default vimwiki, google and
MediaWiki) but only vimwiki's default markup could be converted to HTML at the
moment.
To use MediaWiki's wiki markup: >
    let g:vimwiki_syntax = "media"

To use google's wiki markup: >
    let g:vimwiki_syntax = "google"

------------------------------------------------------------------------------
Default: "A-ZА-Я"                                            *g:vimwiki_upper*
Values: Upper letters (ranges)

This affects WikiWord detection.
By default WikiWord detection uses English and Russian letters.
You can set up your own: >
    let g:vimwiki_upper="A-Z"

------------------------------------------------------------------------------
Default: "a-zа-я"                                            *g:vimwiki_lower*
Values: Lower letters ranges

See |g:vimwiki_upper|: >
    let g:vimwiki_lower="a-z"

------------------------------------------------------------------------------
Default: 1                                                 *g:vimwiki_smartCR*
Values: 0, 1, 2

This option affects the behaviour of <CR> in INSERT mode while adding new
|vimwiki-lists|items.

let g:vimwiki_smartCR=1~
Imagine you have the following list (cursor stands on | ): >
  * List item 1
  * List item 2 |

Now if you press <CR>: >
  * List item 1
  * List item 2
  * |

New list item appear. Now press <CR> again: >
  * List item 1
  * List item 2
  |

It is disappeared. That's it. Try it with cursor on any part of the list. It
also works for |o| and |O|.

let g:vimwiki_smartCR=2~
It only adds new list item. Nothing more. It uses vim comments facility such
as: >
    :h comments
    :h formatoptions.

To turn it off: >
    let g:vimwiki_smartCR = 0

------------------------------------------------------------------------------
Default: 1                                                   *g:vimwiki_maxhi*
Values: 0, 1

Non-existent WikiWord highlighting could be quite slow and if you don't want
it set g:vimwiki_maxhi to 0: >
    let g:vimwiki_maxhi = 0

------------------------------------------------------------------------------
Default: "_"                                              *g:vimwiki_stripsym*
Values: symbol

Change strip symbol -- in Windows you cannot use /*?<>:" in file names so
vimwiki replaces them with symbol given below: (_ is default): >
    let g:vimwiki_stripsym = '_'


==============================================================================
6. Help                                                         *vimwiki-help*

As you could see I am not native English speaker (and writer as well). Please
send me correct phrases instead of that incorrect stuff I have used here.

Any help is really appreciated!

==============================================================================
7. Author                                                     *vimwiki-author*

I live in Moscow and you may believe me -- there are no polar bears (no brown
too) here in the streets.

I do not do programming for a living. So don't blame me for an ugly
ineffective code. :)

Maxim Kim
e-mail: habamax(at)gmail(dot)com~

Vimwiki's website: http://code.google.com/p/vimwiki/
Vim plugins place: http://www.vim.org/scripts/script.php?script_id=2226

==============================================================================
8. Changelog                                               *vimwiki-changelog*

0.5.1
  * [new] This help is created.
  * [new] Now you can fold headers.
  * [new] <Plug>VimwikiGoHome and <Plug>VimwikiExploreHome were added.
  * [fix] Bug with {{{HelloWikiWord}}} export to HTML is fixed.
  * [del] Sync option removed from: Syntax highlighting for preformatted text
    {{{ }}}.

0.5
  * [new] vimwiki default markup to HTML conversion improved.
  * [new] Added basic GoogleWiki and MediaWiki markup languages.
  * [new] Chinese [[complex wiki words]].

0.4
  * [new] vimwiki=>HTML converter in plain vim language.
  * [new] Plugin autoload.

0.3.4
  * [fix] Backup files (.wiki~) caused a bunch of errors while opening wiki
    files.

0.3.3
  * FIXED: [[wiki word with dots at the end...]] didn't work.
  * [new] Added error handling for delete wiki word function.
  * [new] Added keybindings o and O for list items when g:vimwiki_smartCR=1.
  * [new] Added keybinding <Leader>wh to visit wiki home directory.

0.3.2
  * [fix] Renaming -- error if complex wiki word contains %.
  * [fix] Syntax highlighting for preformatted text {{{ }}}. Sync option added.
  * [fix] smartCR bug fix.

0.3.1
  * [fix] Renaming -- [[hello world?]] to [[hello? world]] links are not
    updated.
  * [fix] Buffers menu is a bit awkward after renaming.
  * [new] Use mouse to follow links. Left double-click to follow WikiWord,
    Rightclick then Leftclick to go back.

0.3
  * [new] Highlight non-existent WikiWords.
  * [new] Delete current WikiWord (<Leader>wd).
  * [new] g:vimwiki_smartCR=2 => use vim comments (see :h comments :h
    formatoptions) feature to deal with list items. (thx -- Dmitry Alexandrov)
  * [new] Highlight TODO:, DONE:, FIXED:, FIXME:.
  * [new] Rename current WikiWord -- be careful on Windows you cannot rename
    wikiword to WikiWord. After renaming update all links to that renamed
    WikiWord.
  * [fix] Bug -- do not duplicate WikiWords in wiki history.
  * [fix] after renaming [[wiki word]] twice buffers are not deleted.
  * [fix] when renaming from [[wiki word]] to WikiWord result is [[WikiWord]]
  * [fix] more than one complex words on one line is bugging each other when
    try go to one of them. [[bla bla bla]] [[dodo dodo dodo]] becomes 
    bla bla bla]] [[dodo dodo dodo.


0.2.2
  * [new] Added keybinding <S-CR> -- split WikiWord
  * [new] Added keybinding <C-CR> -- vertical split WikiWord

0.2.1
  * [new] Install on linux now works.

0.2
  * [new] Added part of Google's Wiki syntax.
  * [new] Added auto insert # with ENTER.
  * [new] On/Off auto insert bullet with ENTER.
  * [new] Strip [[complex wiki name]] from symbols that cannot be used in file
    names.
  * [new] Links to non-wiki files. Non wiki files are files with extensions ie
    [[hello world.txt]] or [[my homesite.html]]

0.1
  * First public version.

==============================================================================
9. License                                                   *vimwiki-license*

GNU General Public License v2
http://www.gnu.org/licenses/old-licenses/gpl-2.0.html

To be frank I didn't read it myself. It is not that easy reading. But I hope
it's free enough to suit your needs.


 >
 vim:tw=78:ts=8:ft=help:fdm=marker:

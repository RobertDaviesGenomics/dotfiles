if !exists('g:plugs') || !has_key(g:plugs, 'fzf.vim')
  finish
endif

function! s:tag_handler(tag)
    if !empty(a:tag)
        let token = split(split(a:tag, '\t')[2],';"')[0]
        let m = &magic
        setlocal nomagic
        execute token
        if m
            setlocal magic
        endif
    endif
endfunction

function! s:yank_list()
    if exists(":Yanks")
        redir => ys
        silent Yanks
        redir END
        return split(ys, '\n')[1:]
    else
        return reverse(['0 ' . @0, '1 ' . @1, '2 ' . @2, '3 ' . @3, '4 ' . @4, '5 ' . @5, '6 ' . @6, '7 ' . @7, '8 ' . @8, '9 ' . @9])
    endif
endfunction

function! s:yank_handler(reg)
  if empty(a:reg)
    echo "aborted register paste"
  else
    let token = split(a:reg, ' ')
    if exists(":Yanks")
        execute 'Paste' . token[0]
    else
        execute 'normal! "' . token[0] . 'p'
    endif
  endif
endfunction

function! s:ag_prompt()
  call inputsave()
  let pattern = substitute(@/, '\\<', '', '')
  let pattern = substitute(pattern, '\\>', '', '')
  let pattern = input('Ag: ',pattern)
  call inputrestore()
  if empty(pattern)
    echo 'aborted search.'
  else
    let @/ = pattern
    execute 'Ag' pattern
  endif
endfunction

function! s:dir_handler(dir)
  execute 'lcd ~/src/'.a:dir
  execute 'FZF' . '~/src/'.a:dir
  if has("nvim")
      call feedkeys('i')
  endif
endfunction

command! FZFTag if !empty(tagfiles()) | call fzf#run({
\ 'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
\ 'sink': 'tag',
\ 'options': '+m',
\ 'down': '50%'
\ }) | else | echo 'No tags' | endif

command! FZFTagFile if !empty(tagfiles()) | call fzf#run({
\ 'source': "cat " . join(tagfiles()) . ' | grep -P "' . expand('%:t') . '"',
\ 'sink': function('<sid>tag_handler'),
\ 'options': '+m --with-nth=1',
\ 'down': '50%'
\ }) | else | echo 'No tags' | endif

command! FZFYank call fzf#run({
\ 'source': <sid>yank_list(),
\ 'sink': function('<sid>yank_handler'),
\ 'options': '-m',
\ 'down': 12
\ })

command! FZFProjects call fzf#run({
\ 'source': "ls -1p ~/src | awk -F/ '/\\/$/ {print $1}'",
\ 'sink': function('<sid>dir_handler'),
\ 'options': '-m',
\ 'down': '50%'
\ })

nnoremap <silent> <Leader>t :FZFTagFile<CR>
nnoremap <silent> <Leader>T :FZFTag<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>m :Marks<CR>
nnoremap <silent> <Leader>a :call <sid>ag_prompt()<CR>
nnoremap <silent> <Leader>A :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>y :FZFYank<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>r :History<CR>
nnoremap <silent> <Leader>p :FZFProjects<CR>
nnoremap <silent> <Leader>j :BLines<CR>

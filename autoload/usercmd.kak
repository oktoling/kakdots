
# spawn terminal
define-command -docstring "spawn terminal in your current directory" kgx-new-tab %{
    nop %sh{ {
        kgx --tab --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}

# alternate escape
map global insert <a-.> <esc>
map global prompt <a-.> <esc>
map global view   <a-.> <esc>


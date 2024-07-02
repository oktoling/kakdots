
# spawn terminal
define-command -docstring "add a new tab for GNOME's default terminal in your current directory" kgx-new-tab %{
    nop %sh{ {
        kgx --tab --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}

define-command -docstring "spawn a new alacritty instance in your current directory" alacritty %{
    nop %sh{ {
        alacritty --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}

# map <esc> to <a-.>
# useful for tmux bcuz escape key causes a delay
map global prompt <a-.> <esc>
map global insert <a-.> <esc>


# spawn terminal
define-command -docstring "add a new tab for GNOME's default terminal in your current directory" kgx-new-tab %{
    nop %sh{ {
        kgx --tab --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}

# alternate escape
map global insert <a-.> <esc>
map global prompt <a-.> <esc>
map global view   <a-.> <esc>

define-command -docstring "spawn a new alacritty instance in your current directory" alacritty %{
    nop %sh{ {
        alacritty --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}


define-command -docstring "(wayland): copy to system clipboard" wl-copy %{
    nop %sh{
        echo "$kak_selection" | wl-copy >/dev/null 2>&1 
    }
}

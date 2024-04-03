
# spawn terminal
define-command -docstring "spawn terminal in your current directory" kgx-new-tab %{
    nop %sh{ {
        kgx --tab --working-directory=.
    } > /dev/null 2>&1 < /dev/null & }
}

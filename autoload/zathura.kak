provide-module zathura %{
    define-command -params 1 -docstring %{
        zathura <FILE>
        open a file using zathura
    } -file-completion zathura %{ evaluate-commands %sh{
        zathura "$1" >/dev/null 2>&1 &
    }}
}

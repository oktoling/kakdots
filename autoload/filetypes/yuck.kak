hook global BufCreate .*[.](yuck) %{
    set-option buffer filetype lisp
}

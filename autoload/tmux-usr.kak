# custom config for tmux sessions.

# if this check fails the next modules are not loaded
hook global ModuleLoaded (tmux) %{
    declare-user-mode tmux
    map -docstring 'tmux shortcuts' global user a ':enter-user-mode tmux<ret>'

    map -docstring %{
        spawn terminal, splitting horizontally
    } global tmux h ':tmux-repl-horizontal<ret>'

    map -docstring %{
        spawn terminal, splitting vertically
    } global tmux v ':tmux-repl-vertical<ret>'

    define-command -docstring %{
        sp <file>
        open a new kakoune instance, splitting window
        horizontally
    } -params 1 sp %{
        tmux-terminal-horizontal kak %arg{1}
    }
    complete-command sp file

    define-command -docstring %{
        vs <file>
        open a new kakoune instance, splitting window
        vertically
    } -params 1 vs %{
        tmux-terminal-vertical kak %arg{1}
    }
    complete-command vs file
}


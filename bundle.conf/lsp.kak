bundle kakoune-lsp https://github.com/kakoune-lsp/kakoune-lsp.git %{
    set global lsp_diagnostic_line_error_sign '!'
    set global lsp_diagnostic_line_warning_sign '?'
    set global lsp_diagnostic_line_info_sign '>'
    lsp-inlay-diagnostics-enable global

    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    hook global WinSetOption filetype=(rust) %{
        set window lsp_server_configuration rust.clippy_preference="on"
    }

    map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
    map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
    map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
    map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
    map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
    map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'


    hook global WinSetOption filetype=(rust|javascript|typescript|c|cpp|zig|java) %{
        hook window BufWritePre .* %{
            lsp-formatting-sync
        }
    }

    # define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global KakEnd .* lsp-exit
}

bundle-install-hook kakoune-lsp %{
    cargo install --locked --force --path .
}

bundle-cleaner kakoune-lsp %{
    cargo uninstall --locked --force --path .
}

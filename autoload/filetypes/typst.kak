hook global BufCreate .*[.](typ) %{
    set-option buffer filetype typst
}

hook global WinSetOption filetype=typst %{
    echo -debug "Enabling LSP for filtetype %opt{filetype}"
    set-option window lsp_auto_highlight_references true
    set-option window lsp_hover_anchor true
    # lsp-auto-hover-enable
    set-option buffer lsp_servers %{
    [tinymist]
    root_globs = [".git", ".hg"]
    args = ["lsp"]
    settings_section = "_"
    [tinymist.settings._]
    # See https://myriad-dreamin.github.io/tinymist/configurations.html
    # better control for exporting
    exportPdf = "never"
    formatterMode = "typstyle"
    previewFeature = "disable"
    }
    lsp-enable-window
    eval %sh{ kak-tree-sitter -dks --init $kak_session -vvvvv }
}

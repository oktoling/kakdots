hook global WinSetOption filetype=python %{
    set-option window lsp_auto_highlight_references true
    set-option window lsp_hover_anchor true
    # lsp-auto-hover-enable
    echo -debug "Enabling LSP for filtetype %opt{filetype}"
    lsp-enable-window
}

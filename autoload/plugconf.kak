# NOTE: bundle names must match git repo name / directory name

# fetch / load & configure bundles (plugins)
source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle.git

bundle auto-pairs.kak https://github.com/alexherbo2/auto-pairs.kak.git %{
    enable-auto-pairs
}

bundle kak-tree-sitter https://github.com/hadronized/kak-tree-sitter.git %{
    eval %sh{ kak-tree-sitter -dks --session $kak_session --with-highlighting }
} 
bundle kakoune-tree-sitter-themes https://github.com/oktoling/kakoune-tree-sitter-themes.git %{
    colorscheme tree-sitter
    # colorscheme catppuccin_macchiato
} 

bundle kakoune-lsp https://github.com/kakoune-lsp/kakoune-lsp.git %{
    # uncomment to enable debugging
    # eval %sh{echo ${kak_opt_lsp_cmd} >> /tmp/kak-lsp.log}
    # set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

    # this is not necessary; the `lsp-enable-window` will take care of it
    # eval %sh{${kak_opt_lsp_cmd} --kakoune -s $kak_session}

    set global lsp_diagnostic_line_error_sign '!'
    set global lsp_diagnostic_line_warning_sign '?'

    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global WinSetOption filetype=(c|zig|rust|javascript|typescript) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor false
        # lsp-auto-hover-enable
        echo -debug "Enabling LSP for filtetype %opt{filetype}"
        lsp-enable-window
    }

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


    hook global WinSetOption filetype=(rust|javascript|typescript|c|cpp) %{
        hook window BufWritePre .* %{
            lsp-formatting-sync
        }
    }

    hook global KakEnd .* lsp-exit
} 

# install hooks
bundle-install-hook kakoune-lsp %{
     cd ~/.config/kak/bundle/kakoune-lsp/
     cargo install --locked --force --path .
 }

bundle-install-hook kak-tree-sitter %{
    cd ~/.config/kak/bundle/kak-tree-sitter/
    cargo install --locked --force --path ./kak-tree-sitter
    cargo install --locked --force --path ./ktsctl
}

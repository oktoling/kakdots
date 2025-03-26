# NOTE: bundle names must match git repo name / directory name

# fetch / load & configure bundles (plugins)
source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle.git

# fzf
bundle fzf.kak https://github.com/andreyorst/fzf.kak.git %{
    map -docstring 'run fzf' global user f ':fzf-mode<ret>'
}

# LSP
bundle kakoune-lsp https://github.com/kakoune-lsp/kakoune-lsp.git %{

    set global lsp_diagnostic_line_error_sign '!'
    set global lsp_diagnostic_line_warning_sign '?'
    set global lsp_diagnostic_line_info_sign '>'
    lsp-inlay-diagnostics-enable global

    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    hook global WinSetOption filetype=(c|java|rust|javascript|typescript|zig|haskell) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor true
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

    # define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global KakEnd .* lsp-exit
}

# Tree sitter
bundle kak-tree-sitter https://git.sr.ht/~hadronized/kak-tree-sitter %{
    eval %sh{ kak-tree-sitter -dks --init $kak_session }
    # tree-sitter-session-begin
}

# tree sitter themes
bundle-noload kakoune-tree-sitter-themes https://github.com/oktoling/kakoune-tree-sitter-themes.git

# autopairs
bundle auto-pairs.kak https://github.com/alexherbo2/auto-pairs.kak.git %{
    set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'"
    enable-auto-pairs
}

# statusline
bundle yummy.kak https://github.com/Hjagu09/yummy.kak.git %{
    require-module yummy_the_rigth_config
    set global yummy_fmt_right     " $count $selection $git in $bufname$modified $client_server $mode"
    yummy-enable
}

# terminal
bundle popup.kak https://github.com/enricozb/popup.kak.git %{
    evaluate-commands %sh{kak-popup init}
    map -docstring "open shell" global user c %{:popup --title bash bash<ret>} 
}

# install hooks

bundle-install-hook popup.kak %{
    cargo install --locked --force --path .
}

bundle-install-hook kakoune-lsp %{
    cargo install --locked --force --path .
}

bundle-install-hook kak-tree-sitter %{
    cargo install --locked --force --path ./kak-tree-sitter
    cargo install --locked --force --path ./ktsctl
}

bundle-install-hook kakoune-tree-sitter-themes %{
  # Post-install code here...
  mkdir -p ${kak_config}/colors
  ln -sf "${kak_opt_bundle_path}/kakoune-tree-sitter-themes" "${kak_config}/colors/"
}

bundle-cleaner kakoune-tree-sitter-themes %{
  # Remove the symlink
  rm -rf "${kak_config}/colors/kakoune-tree-sitter-themes"
}

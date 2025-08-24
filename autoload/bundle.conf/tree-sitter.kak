# Tree sitter
bundle-customload kak-tree-sitter https://git.sr.ht/~hadronized/kak-tree-sitter %{
    hook global WinSetOption filetype=(rust|c|cpp|zig|typst|markdown) %{
        eval %sh{ kak-tree-sitter -dks --init $kak_session --with-highlighting --with-text-objects -vvvvv }
        # reload colorscheme to support highlights
        colorscheme night-owl
    }
}

bundle-install-hook kak-tree-sitter %{
    cargo install --locked --force --path ./kak-tree-sitter
    cargo install --locked --force --path ./ktsctl
}

bundle-cleaner kak-tree-sitter %{
    cargo uninstall kak-tree-sitter
    cargo uninstall ktsctl
}

bundle-theme kakoune-tree-sitter-themes https://git.sr.ht/~hadronized/kakoune-tree-sitter-themes
colorscheme night-owl

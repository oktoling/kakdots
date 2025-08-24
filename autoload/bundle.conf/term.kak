# use popup.kak for built-in terminal support
bundle popup.kak https://github.com/enricozb/popup.kak.git %{
    evaluate-commands %sh{kak-popup init}
    map -docstring "open shell" global user c %{:popup --title bash bash<ret>} 
}

bundle-install-hook popup.kak %{
    cargo install --locked --force --path .
}

bundle-cleaner popup.kak %{
    cargo uninstall --locked --force --path .
}

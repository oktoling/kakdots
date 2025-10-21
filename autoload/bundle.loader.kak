# generates a bundle.kak file that loads everything in %val{config}/bundle.conf
# this is for safer porting between machines, honestly i have no clue why my laptop
# one worked

define-command bundle-config-update-debug %{
    evaluate-commands %sh{
        printf "echo -debug %%{bundle-config-update: pwd => $(pwd)}\n"
        for file in $(find "$kak_config"/bundle.conf/ -type f); do
            printf "echo -debug \"bundle-config-update-debug: found file $file\"\n";
            echo "echo -debug \"bundle-config-update-debug: modified to $file\"" | sed "s?$kak_config?%{%val{config}}?"
        done
    }
}

define-command bundle-config-update %{
    nop %sh{
        fname="bundle.kak"
        if [[ -d "$fname" ]]; then
            rm "$fname"
        fi

        for conf in $(find "$kak_config"/bundle.conf/ -type f); do
            conf_path_mod=$(echo "$conf" | sed "s?$kak_config?%%val{config}?")
            printf "source \"$conf_path_mod\"\n" >> "$fname"
        done
    }
}

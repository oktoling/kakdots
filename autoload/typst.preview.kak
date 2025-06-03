# current issues with this script
# -> zathura cannot find file for some reason
# proposal
# -> create a separate script for running typst watch.
provide-module typst-preview %{
    declare-option -hidden str typst_preview_file %sh{ mktemp }
    nop %sh{ touch "$typst_preview_file.pdf" }

    define-command -hidden typst-preview-update %{
        execute-keys ":w -force %opt{typst_preview_file}<ret>"
    }

    define-command -hidden typst-preview-init %{
        typst-preview-update
        declare-option str typst_preview_pid_watch %sh{
            typst watch "$kak_opt_typst_preview_file" "$kak_opt_typst_preview_file.pdf"  >/dev/null 2>/dev/null & echo $!
        } 
        declare-option str typst_preview_pid_view %sh{
            zathura "$kak_opt_typst_preview_file.pdf"  >/dev/null 2>/dev/null & echo $!
        }
    }

    define-command -hidden typst-preview-quit %sh{
        kill -s SIGKILL "$kak_opt_typst_preview_pid_watch"
        kill -s SIGKILL "$kak_opt_typst_preview_pid_view"
    }
    define-command typst-preview-enable %{
        typst-preview-init
        define-command -docstring %{
            quit typst preview manually
        } typst-preview-disable typst-preview-quit
    }

    hook global KakEnd '' typst-preview-quit
}

hook global WinSetOption filetype=typst %{
    require-module typst-preview
}


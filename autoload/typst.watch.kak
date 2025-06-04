provide-module typst-watch %{
    require-module zathura
    define-command  -docstring %{
    typst-preview <FILE>
    watch a file with typst
    } \
    -params 1 \
    -file-completion \
    typst-watch %{
        evaluate-commands %sh{
            KAK_TYPST_PID_FILE="/tmp/typst.kak.pid"
            if [[ -f "$KAK_TYPST_PID_FILE" ]];
            then
                echo 'echo -debug %{ '\
                'typst-preview: pid file exist, a file is currently being watched, stop that process first.'\
                '}'
            	echo "info -title %{ typst-watch still running } %{ quit currently running preview file first. }"
            else
                echo 'echo -debug %{ typst-preview: starting... }'
                typst watch "$1" >/dev/null 2>&1 & echo "$!" > "$KAK_TYPST_PID_FILE"
                echo 'info -title "%val{buffile} enabled" %{ view the file with `zathura <name of your file>.pdf`}'
                echo "echo -debug %{ typst-watch: process running and recorded at $(cat $KAK_TYPST_PID_FILE)}"
            fi
        }
    }

    define-command -docstring %{
    quit currently running watch process
    } \
    typst-watch-quit %{
        evaluate-commands %sh{
            KAK_TYPST_PID_FILE="/tmp/typst.kak.pid"
            if [[ -f "$KAK_TYPST_PID_FILE" ]];
            then
                echo "echo -debug %{ confirm file contents of $KAK_TYPST_PID_FILE: $(cat $KAK_TYPST_PID_FILE)}"
                kill -9 "$(cat $KAK_TYPST_PID_FILE)"
                rm "$KAK_TYPST_PID_FILE"
            	echo "info %{ typst watch process successfully exited. }"
            else
            	echo "info %{ no typst process running }"
            fi
        }
    }

    hook global KakEnd '' typst-watch-quit 
}

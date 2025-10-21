source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle

# for bundling in files or some shit
source "%val{config}/bundle.kak"

add-highlighter global/ number-lines -relative -hlcursor

set-option -add global ui_options terminal_assistant=none

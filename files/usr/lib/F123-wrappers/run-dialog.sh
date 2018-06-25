write_history(){
    oldHistory="$(grep -v "$txt" "$historyPath/history" | head -n 49)"
    echo -e "$txt\n$oldHistory" | sed 's/^$//g' > "$historyPath/history"
}

historyPath="${XDG_CONFIG_HOME:-$HOME/.config}/F123"
if ! [[ -d "$historyPath" ]]; then
    mkdir -p "$historyPath"
fi
if [[ -f "$historyPath/history" ]]; then
    txt=$(yad --entry --editable \
        --title "F123" \
        --text "Execute program or enter file" \
        --button "Open:0" \
        --separator "\n" \
        --rest "$historyPath/history")
else
    txt=$(yad --entry \
        --title "F123" \
        --text "Execute program or enter file" \
        --button "Open:0")
fi
if [[ -z "$txt" ]]; then
    exit 0
fi
if [[ "$txt" =~ ^ftp://|http://|https://|www.* ]]; then
    /usr/bin/firefox $txt
    write_history
    exit 0
fi
if [[ "$txt" =~ ^mailto://.* ]]; then
    xdg-email $txt
    write_history
    exit 0
fi
if [[ "$txt" =~ ^man://.* ]]; then
    eval "${txt/:\/\// }" | yad --text-info --show-cursor --button "Close:0" --title "F123" -
    write_history
    exit 0
fi
if command -v "${txt%% *}" &> /dev/null ; then
    eval $txt&
else
(xdg-open $txt || /usr/bin/pcmanfm)&
fi
write_history
exit 0 

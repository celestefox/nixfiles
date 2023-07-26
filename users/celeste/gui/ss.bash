#! /usr/bin/env nix-shell
#! nix-shell -i bash -p shotgun rclone xclip xdotool dunst hacksaw
set -euo pipefail # TODO: not duplicate deps/these opts w/ i3.nix? But these make ss directly runnable to test with
IFS=$' '
# variable setup
#### the directory screenshots are saved to
outdir="${XDG_PICTURES_DIR:-"${HOME}/media"}/ss"
#### the name, minus extension and base directory, of the screenshot
filename="$(TZ="UTC" date '+%Y/%m/%d%H%M%S')"
full_name="$outdir/$filename.png"

print_usage() {
    # Not "perfect", but fine for just informative usage i think?
    name="$(basename "$0")"
    cat <<-EOF
$name: take a screenshot
    usage: $name mode action
    mode: select,window,display,full
    action:save,copy,link
    copy and link also save
EOF
}

main() {
    if [ $# -ne 2 ]; then
        print_usage
        exit 1
    fi
    mode="$1"
    action="$2"

    # Process the options
    case $mode in
    select)
        #selection="$(slop -r boxzoom -f "-i %i -g %g")"
        selection="$(hacksaw -c "#5511bb" -f "-g %g")"
        ;;
    window)
        selection="-i $(xdotool getactivewindow)"
        ;;
    display)
        # TODO: this is hardcoded for two side-by-side 1080p monitors!
        # eval "$(xdotool getmouselocation --shell)"
        # if [[ $X -gt 1919 ]]; then selection="-g 1920x1080+1920+0"
        # else selection="-g 1920x1080+0+0"
        # fi
        # shotgun actually does this for me now?
        selection="-s"
        ;;
    full)
        selection=""
        ;;
    *)
        printf "Bad mode \"%q\"! Expected one of: select,window,display,full\n" "$mode"
        exit 2
        ;;
    esac

    # Only checking here
    case $action in
    save | copy | link) ;;
    *)
        printf "Bad action \"%q\"! Expected one of: save,copy,link\n" "$action"
        exit 3
        ;;
    esac

    # Time to act!
    mkdir -p "$(dirname "$full_name")"
    
    # shellcheck disable=SC2086
    shotgun $selection "$full_name"

    # Screenshot is saved! Time to try to act.
    case $action in
    save)
        # Just need to notify!
        dunstify --appname=ss "Screenshot saved!" "Screenshot saved to $full_name"
        ;;
    copy)
        # Copy and notify
        xclip -in -selection clipboard -t image/png "$full_name"
        dunstify --appname=ss "Screenshot saved and copied!" "Screenshot saved to $full_name and copied to clipboard"
        ;;
    link)
        # Upload, put link in clipboard
        # TODO: this is very much made for me personally, here, obviously
        rclone copy "$full_name" "uploads:celeste-uploads/ss/$(dirname "$filename")"
        printf "https://uploads.foxgirl.tech/ss/%s.png" "$filename" | xclip -in -selection clipboard
        dunstify --appname=ss "Screenshot uploaded!" "Screenshot saved to $full_name, uploaded and link copied to clipboard"
        ;;
    esac
}

main "$@"

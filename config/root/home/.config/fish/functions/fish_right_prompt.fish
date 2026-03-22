function fish_right_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    # Exit Code (Only if non-zero)
    if test $last_status -ne 0
        echo -n -s $red "[" $last_status "]" $normal " "
    end
end

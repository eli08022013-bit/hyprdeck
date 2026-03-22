function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    # Arch Linux Logo (Nerd Font)
    echo -n -s $blue " " $normal

    # Directory
    echo -s $blue " $(prompt_pwd)"

    # Final prompt character
    echo -n -s $normal "$(whoami) ❯ " $normal
end

#!/usr/bin/fish

set monitor $(hyprctl activeworkspace -j | jq -r '.monitor')
set path $(swww query | grep $monitor | awk '{print $9}')
echo $path

#!/bin/bash

#set -euo pipefail

lsof /var/lib/dpkg/lock
if [ $? -ne 1 ]; then
        echo "Another process has f-locked /var/lib/dpkg/lock" 1>&2
        exit 1
fi

# IBM Cloud
curl -sL https://ibm.biz/idt-installer | bash
# Mutagen (for dev)
wget https://github.com/mutagen-io/mutagen/releases/download/v0.11.5/cli_linux_amd64_v0.11.5.tar.gz
tar xvfz cli_linux_amd64*
chmod +x mutagen
mv mutagen /usr/local/bin/mutagen
# k9s for ncurses K8s exploration
wget https://github.com/derailed/k9s/releases/download/v0.22.1/k9s_Linux_x86_64.tar.gz
tar xvfz k9s*
chmod +x k9s
mv k9s /usr/local/bin/k9s
# OpenShift CLI because: OCP
wget http://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar xvfz ./oc.tar.gz
chmod +x oc
mv oc /usr/local/bin/oc

#tmux
curl https://raw.githubusercontent.com/jpapejr/dotfiles/master/.tmux.conf -o /root/.tmux.conf

cat << EOF > /root/.tmux.conf
set -g mouse on
bind -Tcopy-mode WheelUpPane send -N1 -X scroll-up
bind -Tcopy-mode WheelDownPane send -N1 -X scroll-down
set -g status on
# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
# Automatically set window title
set-window-option -g automatic-rename on
set-option -g set-titles on
# THEME

#Variables
color_status_text="colour245"
color_window_off_status_bg="colour238"
color_light="white" #colour015
color_dark="colour232" # black= colour232
color_window_off_status_current_bg="colour254"


set -g status-bg white
set -g status-fg black
set -g status-interval 60
set -g status-left-length 30
set -g status-left '#[fg=green](#S) #(whoami) '

bind-key -T copy-mode MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"

bind -T root F12  \
  set prefix None \;\
  set key-table off \;\
  set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
  set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
  set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S \;\

bind -T off F12 \
  set -u prefix \;\
  set -u key-table \;\
  set -u status-style \;\
  set -u window-status-current-style \;\
  set -u window-status-current-format \;\
  refresh-client -S

wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

set -g status-right "$wg_is_keys_off  $wg_user_host"

EOF

# touch done file in /root
touch /root/cloudinit.done

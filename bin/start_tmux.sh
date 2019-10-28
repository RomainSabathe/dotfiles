PROJECT="my_project"
tmux new-session -s $PROJECT \; \
    send-keys "cd ~/git/$PROJECT" C-m \; \
    send-keys "nvim" C-m \; \
    send-keys ":vsplit" C-m \; \
    split-window -v -p 20 \; \
    send-keys "pyenv activate $PROJECT" \; \
    select-pane -t 1 \; \
    split-window -h -p 30 \; \
    send-keys "vifm" C-m \; \
    send-keys ":cd ~/git/$PROJECT" C-m \; \
    split-window -v -p 35 \;

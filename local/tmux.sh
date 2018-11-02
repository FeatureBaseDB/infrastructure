function tmux-split() {
    # Name of tmux session
    SESSION=$1
    shift
    # Array of commands
    C=("$@")
    # Number of commands minus one
    N=$((${#C[@]} - 1))

    tmux new-session -d -s $SESSION
    tmux select-window -t $SESSION
    tmux select-layout even-vertical

    for i in $(seq 0 $N); do
        # Select the "Nth" pane and launch pilosa
        tmux select-pane -t $i
        tmux send-keys "${C[i]}" Enter

        # TODO: This splitting logic works up to only about 5 nodes before failing with "create pane failed: pane too small"
        # Split the window after every loop except the last
        if [ ! $i -eq $N ]; then
            tmux split-window -v
            tmux select-layout even-vertical
        fi
    done
}

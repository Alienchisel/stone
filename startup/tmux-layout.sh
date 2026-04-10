#!/usr/bin/env bash
# terminus - creates and attaches to a named tmux session with a
# predefined window and pane layout for desktop work.
# Requires: tmux

show_help() {
    cat <<'EOF'
Usage: terminus [-h|--help]

Creates and attaches to a tmux session named 'terminus' with a
predefined layout. If the session already exists, attaches to it.

Session layout:
  Window 1: cor (three panes)
    ┌─────────┬──────────┐
    │         │  pane 2  │
    │ pane 1  ├──────────┤
    │         │  pane 3  │
    └─────────┴──────────┘

  Window 2: explor (four panes, tiled)
    ┌─────────┬──────────┐
    │ pane 1  │  pane 2  │
    ├─────────┼──────────┤
    │ pane 3  │  pane 4  │
    └─────────┴──────────┘

Settings (edit in script):
  SESSION     tmux session name   (default: terminus)
  BASE_DIR    starting directory  (default: ~/Desktop)

Requires: tmux
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && show_help && exit 0

# Dependency check
command -v tmux &>/dev/null || { echo "Error: 'tmux' not found."; exit 1; }

# ------------------------
# Settings
# ------------------------
SESSION="terminus"
BASE_DIR="$HOME/Desktop"

# Validate base directory
[[ -d "$BASE_DIR" ]] || { echo "Error: BASE_DIR not found: '$BASE_DIR'"; exit 1; }

# ------------------------
# Attach to existing session if it already exists
# ------------------------
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach-session -t "$SESSION"
    exit 0
fi

# ============================
# Window 1: COR
# Three-pane layout: left column + right column split vertically
#
#  ┌─────────┬──────────┐
#  │         │  pane 2  │
#  │ pane 1  ├──────────┤
#  │         │  pane 3  │
#  └─────────┴──────────┘
# ============================

# Create the session and first window
tmux new-session -d -s "$SESSION" -n cor -c "$BASE_DIR"

# Split pane 1 horizontally to create pane 2 on the right
tmux split-window -h -t "$SESSION":cor.1 -c "$BASE_DIR"

# Split pane 2 vertically to create pane 3 below it
tmux split-window -v -t "$SESSION":cor.2 -c "$BASE_DIR"

# Widen the left pane by nudging the divider leftward
tmux resize-pane -t "$SESSION":cor.1 -L 30

# Uncomment to auto-run default scripts on session start:
tmux send-keys -t "$SESSION":cor.1 "random-column --fullscreen" C-m
tmux send-keys -t "$SESSION":cor.2 "ascii-latin --fullscreen 'PER IGNOTUM'" C-m
tmux send-keys -t "$SESSION":cor.3 "ascii-latin --fullscreen 'PERTEMPTARE'" C-m

# Focus the left pane
tmux select-pane -t "$SESSION":cor.1

# ============================
# Window 2: EXPLOR
# Four-pane tiled layout: 2x2 grid
#
#  ┌─────────┬──────────┐
#  │ pane 1  │  pane 2  │
#  ├─────────┼──────────┤
#  │ pane 3  │  pane 4  │
#  └─────────┴──────────┘
# ============================

tmux new-window -t "$SESSION" -n explor -c "$BASE_DIR"

# Split pane 1 horizontally to create pane 2 on the right
tmux split-window -h -t "$SESSION":explor.1 -c "$BASE_DIR"

# Split pane 1 vertically to create pane 3 below it
tmux split-window -v -t "$SESSION":explor.1 -c "$BASE_DIR"

# Split pane 2 vertically to create pane 4 below it
tmux split-window -v -t "$SESSION":explor.2 -c "$BASE_DIR"

# Apply tiled layout to ensure a clean 2x2 grid
tmux select-layout -t "$SESSION":explor tiled

# Focus the top-left pane
tmux select-pane -t "$SESSION":explor.1

# ============================
# Focus
# Return focus to window 1, pane 1 before attaching
# ============================
tmux select-window -t "$SESSION":cor
tmux select-pane -t "$SESSION":cor.1

# ------------------------
# Attach to the session
# ------------------------
tmux attach-session -t "$SESSION"


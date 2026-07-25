# Forward Alt+HJKL to Herdr from interactive shell panes.
# Neovim handles the same keys itself and falls through to Herdr at split edges.

if [[ -n "$HERDR_WORKSPACE_ID" ]] && command -v herdr >/dev/null 2>&1; then
  _herdr_focus_pane() {
    zle -I
    command herdr pane focus --direction "$1" >/dev/null 2>&1
  }

  _herdr_focus_left() { _herdr_focus_pane left }
  _herdr_focus_down() { _herdr_focus_pane down }
  _herdr_focus_up() { _herdr_focus_pane up }
  _herdr_focus_right() { _herdr_focus_pane right }

  zle -N _herdr_focus_left
  zle -N _herdr_focus_down
  zle -N _herdr_focus_up
  zle -N _herdr_focus_right

  for keymap in emacs viins vicmd; do
    bindkey -M "$keymap" '^[h' _herdr_focus_left
    bindkey -M "$keymap" '^[j' _herdr_focus_down
    bindkey -M "$keymap" '^[k' _herdr_focus_up
    bindkey -M "$keymap" '^[l' _herdr_focus_right
  done
fi

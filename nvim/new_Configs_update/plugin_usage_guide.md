# 📚 Neovim Plugin Usage Guide

This guide explains how to use the new plugins added to your configuration.

---

## 1. 🧭 vim-tmux-navigator
**Goal:** Treat Neovim splits and Tmux panes as the **same thing**.

### How to Use
Use your standard navigation keys combined with **Control**:
*   **`Ctrl` + `h`**: Move focus **Left** (to a split OR a tmux pane).
*   **`Ctrl` + `j`**: Move focus **Down**.
*   **`Ctrl` + `k`**: Move focus **Up**.
*   **`Ctrl` + `l`**: Move focus **Right**.
*   **`Ctrl` + `\`**: Jump to previous split/pane.

### ⚠️ IMPORTANT: Tmux Config Required
For this to work, you MUST add this to your `~/.tmux.conf` file:

```tmux
# Smart pane switching with awareness of Vim splits.
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
```

---

## 2. ⇥ tabout.nvim (Enhanced for C++)
**Goal:** Escape brackets `()` `[]` `{}` and **Templates `<>`** without reaching for arrow keys.

### How to Use
When you are typing code and your cursor is inside brackets/quotes:
*   **Press `<Tab>`**: instantly jumps your cursor **outside** the closing character.
*   **Press `<Shift> + <Tab>`**: Jumps backwards.

**C++ Example (New Feature):**
1.  You type `std::vector<string|>` (Cursor is at `|`).
2.  Press **`Tab`**.
3.  Cursor jumps to: `std::vector<string>|` (Past the `>`).
    *   *This is exclusive to your new config!*

> **Note:** If the autocomplete menu is open, `<Tab>` will select the completion item first.

---

## 3. ⏳ fidget.nvim (Cleaner UI)
**Goal:** See what the LSP is doing without getting annoyed.

### How to Use
*   **Passive:** There are no keybinds.
*   **Look:** Check the **bottom right corner**.
*   **Improvement:** I set it to be **Transparent** and use a smooth "dots" animation so it doesn't distract you or block your code.

---

## 4. 🔗 vim-tpipeline (Smart Status)
**Goal:** Save screen space by merging Neovim statusline into Tmux.

### How to Use
*   **Automatic:** It now **Auto-Detects** if you are in Tmux.
    *   **In Tmux:** Hides Neovim's bottom bar (saves space).
    *   **NOT in Tmux:** Keeps the bar (so you don't lose info).

### ⚠️ Tmux Config Recommendation
Add this to `~/.tmux.conf` to enable the "passthrough" capability:
```tmux
set -g focus-events on
set -g status-style bg=default
set -g status-left-length 90
set -g status-right-length 90
set -g status-justify centre
```

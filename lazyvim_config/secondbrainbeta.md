BETA still just hanign around 

The Golden Rule:

Start of Day: "Pull" (Get changes from the other computer).
End of Day: "Push" (Save your work to the cloud).

nbs = Notes Brain Sync)

cp /home/thejoceph/.gemini/antigravity/scratch/brain_sync.sh /home/thejoceph/.local/bin/nbs
chmod +x /home/thejoceph/.local/bin/nbs

# ⚡ The "Second Brain" Full Cycle (Integration Practice)

**Objective:** Master the complete loop from idea to cloud using your new tools.

## The Scenerio
You are starting your day. You have an idea about a "Project X". You need to record it, link it to your daily journal, and verify it's saved to the cloud so you can see it at school later.

## Step-by-Step Drill

### 1. Start Current (The Protocol)
*   **Action:** Open your terminal.
*   **Command:** `nbs`
*   **Why:** This "Pulls" any changes you might have made on your other computer. Always start with this.

### 2. Enter the Brain
*   **Command:** `nvim`
*   **Keymap:** Press `<Space>nn` (Notes New/Index)
*   **Result:** You are now at your "Home Base" note.

### 3. Capture the Idea
*   **Keymap:** Press `<Space>on` (Obsidian New)
*   **Type:** `Project X Analysis` -> Press `Enter`.
*   **Result:** A new file is created for you instantly.

### 4. Write & Link (The Power Step)
*   **Type Header:** `# Project X Analysis`
*   **Type Body:** "This project relates to [[daily]] notes."
    *   *Notice:* As you type `[[da...`, it might autocomplete.
*   **Action:** Place cursor on `[[daily]]` and press `Enter`.
    *   *Result:* You just jumped to your daily note!
*   **Action:** Press `Ctrl+o` (Jump Back).
    *   *Result:* You are back in "Project X".

### 5. Use Your New Tools
*   **Insert Date:** Press `<Space>id` -> See `2025-12-15`.
*   **Insert Time:** Press `<Space>it` -> See `18:30`.
*   **Check Visuals:** Press `<Space>uc` to toggle the "Conceal" (hide/show markdown symbols) to verify it looks clean.

### 6. Search It (Verify Retrieval)
*   **Action:** Close the current buffer (`:q` or `<leader>bd`).
*   **Keymap:** Press `<Space>ng` (Notes Grep/Search).
*   **Type:** `Project X`
*   **Result:** Neovim finds your text inside the note instantly. Press `Enter` to open it.

### 7. Finish (The Save)
*   **Action:** Quit Neovim (`:qq`).
*   **Command:** `nbs`
*   **Why:** This "Pushes" your new note to GitHub.
*   **Verify:** You should see "Pushing to GitHub..." and "Done."

---
**Summary Loop:** `nbs` -> Write -> Link -> Search -> `nbs`

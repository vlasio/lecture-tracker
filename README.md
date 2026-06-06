# 📚 Lecture Tracker

A command-line app written in Common Lisp to keep track of your lectures. Log whether you attended, whether you worked through it independently, and add any notes — all saved to a local file so your data persists between sessions.

## Features

- Add lectures with attendance and independent study status
- View all lectures in a formatted table
- Delete lectures by name
- Automatically saves to and loads from a local database file

## Requirements

- [SBCL](https://www.sbcl.org/) (Steel Bank Common Lisp)
- `rlwrap` (optional, but recommended for a better REPL experience)

### Install on Ubuntu/Debian

```bash
sudo apt install sbcl rlwrap
```

### Install on macOS

```bash
brew install sbcl rlwrap
```

## Setup

Before running, make sure the save directory exists:

```bash
mkdir -p ~/projects/lecture-tracker
```

## Running

```bash
rlwrap sbcl --load lecture-tracker.lisp --eval "(main-menu)"
```

You'll be dropped into an interactive menu:

```
========================
   LECTURE TRACKER
========================
1. Add a new lecture
2. Save lectures to file
3. Load lectures from file
4. Show all lectures
5. Delete a lecture
6. Quit
------------------------
```

## Data Storage

Lectures are saved to:

```
~/projects/lecture-tracker/my-database.txt
```

This file is created automatically on first save. You can change the path by editing the `*db-filename*` variable at the top of `lecture-tracker.lisp`.

# Hangman Bash Game

A simple **Hangman** game implemented in **Bash**.  
Players try to guess the hidden word by typing letters before running out of attempts.  

---

## Features
- Random word selection from multiple categories:
  - Programming
  - Animals
  - Countries
  - Names
  - Food
- ASCII-art hangman drawing as mistakes accumulate
- Tracks previously tried letters
- Colored console output (green for correct guesses, red for incorrect, yellow for hangman drawing)
- Replay option after game ends

---

## Requirements
- Bash (tested with Bash 5.x)
- Works on Linux and macOS

Tested on:  
- **Ubuntu Linux**  
- **macOS Sequoia**  
- **macOS Tahoe**

---

## Usage
Make the script executable:
```bash
chmod +x hangman.sh
```

## Run the game
```bash
./hangman.sh
```

## Example gameplay
```bash
*****************************************
             HANGMAN - GAME              
     Guess the word before you hang!     
*****************************************
Remaining attempts: 7
Current progress: _______
Letters already tried: 
Guess a letter: 
```

## License
This project is licensed under the MIT License.
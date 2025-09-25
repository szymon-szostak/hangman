#!/bin/bash

# defined ANSI color codes for coloring console output; 
# later used with the -e flag to interpret escape sequences
RESET="\033[0m" # restores the default font configuration of the terminal
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"

welcome_screen() {
    echo -e "${GREEN}"
    echo "*****************************************"
    echo "             HANGMAN - GAME              "
    echo "     Guess the word before you hang!     "
    echo "*****************************************"
    echo -e "${RESET}"
}

end_screen() {
    local result=$1 # when calling this function, the first argument indicates the game result color (green=win; red=loss)
    local password=$2
    echo -e "${result}"
    echo "*****************************************"
    if [[ "$result" == "${GREEN}" ]]; then # thanks to double brackets we don’t need spaces around logical operators
        echo "      Congratulations! You won!          "
    else
        echo "              +---+                      "
        echo "              |   |                      "
        echo "              O                          "
        echo "             /|\                         "
        echo "              |                          "
        echo "             / \                         "
        echo "        Unfortunately, you lost!         "
    fi
    echo " The chosen word was: $password "
    echo "*****************************************"
    echo -e "${RESET}"
}

show_game_status() {
    echo "Remaining attempts: $remaining_attempts"
    echo "Current progress: $display_guess_stage"
    echo "Letters already tried: ${tried_letters[*]}" # show all elements of the array separated by spaces
    draw_hangman
}

draw_hangman() {
    local mistakes=$((allowed_attempts - remaining_attempts))
    echo -e "${YELLOW}"
    echo "   +---+"
    echo "   |   |"
    case $mistakes in # conditional statement for which body part to display based on number of mistakes
    1) echo "   O   " ;;
    2)
        echo "   O   "
        echo "   |   "
        ;;
    3)
        echo "   O   "
        echo "  /|   "
        ;;
    4)
        echo "   O   "
        echo "  /|\  "
        ;;
    5)
        echo "   O   "
        echo "  /|\  "
        echo "   |   "
        ;;
    6)
        echo "   O   "
        echo "  /|\  "
        echo "   |   "
        echo "  /    "
        ;;
    7)
        echo "   O   "
        echo "  /|\  "
        echo "   |   "
        echo "  / \  "
        ;;
    esac
    echo -e "${RESET}"
}

choose_category() {
    echo "Choose a category:"
    local categories=("PROGRAMMING" "ANIMALS" "COUNTRIES" "NAMES" "FOOD")
    local words_in_categories=(
        "programming computer python processor javascript"
        "dog cat penguin hamster dolphin"
        "Poland Germany Spain France Norway"
        "Sebastian Alexandra Franciszek Zuzanna Kazimierz"
        "Spaghetti Dumplings TomatoSoup Toasts Eggbread"
    )
    # below is to list available categories; iterating through array indices
    # using @ instead of * to treat items as separate strings; +1 to start from 1 not 0
    for i in ${!categories[@]}; do
        echo "$((i + 1)). ${categories[$i]}"
    done

    local category_index # category index starts from 1
    echo "Enter the category number (1-${#categories[@]}): "
    read category_index

    if [[ ! $category_index =~ ^[1-${#categories[@]}]$ ]]; then # compare with regex
        echo "Invalid category number. Choosing random category."
        category_index=$((RANDOM % ${#categories[@]} + 1)) # generates a random number mod number of categories
    fi

    local words_for_category=(${words_in_categories[$((category_index - 1))]}) 
    chosen_word=${words_for_category[$((RANDOM % ${#words_for_category[@]}))]}
    chosen_word=$(echo "$chosen_word" | tr '[:upper:]' '[:lower:]') # convert uppercase to lowercase
    display_guess_stage=$(echo "$chosen_word" | sed 's/./_/g') # replace letters with underscores
    echo "Chosen word: $(echo "$chosen_word" | sed 's/./*/g')" # mask chosen word
}

guess_letter() {
    local input_letter=$1 # argument passed to function
    if [[ " ${tried_letters[*]} " == *" $input_letter "* ]]; then 
        echo "This letter was already tried. Try again."
        return
    fi

    tried_letters+=("$input_letter")
    local letter_found=false
    local updated_display=""
    for ((i = 0; i < ${#chosen_word}; i++)); do # iterate over word by index
        if [[ ${chosen_word:i:1} == $input_letter ]]; then
            updated_display+="$input_letter"
            letter_found=true
        else
            updated_display+="${display_guess_stage:i:1}"
        fi
    done

    display_guess_stage="$updated_display"

    if [[ $letter_found == true ]]; then
        echo -e "${GREEN}Good job! Letter $input_letter is in the word.${RESET}"
    else
        echo -e "${RED}Sorry, letter $input_letter is not in the word.${RESET}"
        ((remaining_attempts--))
    fi
}

main() {
    play_again="yes"
    while [[ $play_again == "yes" ]]; do
        welcome_screen
        allowed_attempts=7
        remaining_attempts=$allowed_attempts
        tried_letters=()
        choose_category

        while [[ $remaining_attempts -gt 0 && $display_guess_stage != $chosen_word ]]; do 
            show_game_status
            echo "Guess a letter: "
            read typed_letter

            if [[ ! $typed_letter =~ [a-zA-Z] ]]; then # check if character is a letter
                echo "Invalid input. Please enter a letter."
                continue
            fi

            typed_letter=$(echo "$typed_letter" | tr '[:upper:]' '[:lower:]') 
            guess_letter "$typed_letter" 
        done

        if [[ $display_guess_stage == $chosen_word ]]; then 
            end_screen ${GREEN} "$chosen_word"
        else
            end_screen ${RED} "$chosen_word"
        fi

        echo "Do you want to play again? (type yes/no): "
        read play_again
    done
}

main
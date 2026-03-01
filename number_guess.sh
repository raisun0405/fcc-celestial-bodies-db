#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt for username
echo "Enter your username:"
read USERNAME

# Fetch user from database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

# If user is not found
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Insert new user
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  # Get new user_id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
else
  # If user exists, fetch game stats
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id = $USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate secret number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS_COUNT=0

echo "Guess the secret number between 1 and 1000:"

# Guessing loop
while read GUESS
do
  # Check if input is a valid integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    ((GUESS_COUNT++))
    
    if [[ $GUESS -eq $SECRET_NUMBER ]]
    then
      break;
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  fi
done

# Insert game record into database
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $GUESS_COUNT)")

# Print winning message
echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"# feat
# fix
# refactor
# chore
# feat
# fix
# refactor
# chore

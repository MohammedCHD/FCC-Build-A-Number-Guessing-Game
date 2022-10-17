#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo -e "\nEnter your username:"
read USERNAME
RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
USER_CHECK=$($PSQL "SELECT username FROM user_info WHERE username='$USERNAME'")
if [[ -z $USER_CHECK ]]
then
  NEW_USER=$($PSQL "INSERT INTO user_info(username, games_played, best_game) VALUES('$USERNAME', 0, 0)")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_info WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$USERNAME'")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
echo -e "\nGuess the secret number between 1 and 1000:"
USER_GUESS=0
GUESSES=0
while [[ $USER_GUESS != $RANDOM_NUMBER ]]
do
  read USER_GUESS
  if [[ "$USER_GUESS" =~ ^[0-9]+$ ]]
  then
    if [[ $USER_GUESS > $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
    else if [[ $USER_GUESS < $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
    fi
    fi
  else
    echo -e "\nThat is not an integer, guess again:"
  fi
  GUESSES=$(( $GUESSES + 1 ))
done
echo -e "\nYou guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$USERNAME'")
if [[ $BEST_GAME > $GUSSES ]]
then
  UPDATE_USER_INFO=$($PSQL "UPDATE user_info SET games_played=games_played + 1, best_game=$GUESSES WHERE username='$USERNAME'")
else
  UPDATE_USER_INFO=$($PSQL "UPDATE user_info SET games_played=games_played + 1 WHERE username='$USERNAME'")
fi

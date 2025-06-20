#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  if [[ $YEAR != "year" ]]
  then
   
    WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING RETURNING team_id")
    if [[ -z $WINNER_ID || $WINNER_ID == *"INSERT"* ]]; then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT (name) DO NOTHING RETURNING team_id")
    if [[ -z $OPPONENT_ID || $OPPONENT_ID == *"INSERT"* ]]; then
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    WINNER_ID=$(echo "$WINNER_ID" | tr -d '[:space:]')
    OPPONENT_ID=$(echo "$OPPONENT_ID" | tr -d '[:space:]')

 
    if ! [[ "$WINNER_ID" =~ ^[0-9]+$ ]]; then
      echo "Ошибка: Неверный формат WINNER_ID ($WINNER_ID) для команды $WINNER"
      exit 1
    fi

    if ! [[ "$OPPONENT_ID" =~ ^[0-9]+$ ]]; then
      echo "Ошибка: Неверный формат OPPONENT_ID ($OPPONENT_ID) для команды $OPPONENT"
      exit 1
    fi


    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WG, $OG)")
    if [[ $? -ne 0 ]]; then
      echo "Ошибка при вставке матча: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WG, $OG"
      exit 1
    fi
  fi
done

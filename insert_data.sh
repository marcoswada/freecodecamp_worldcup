#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WTEAM OTEAM WGOALS OGOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #get team_id for winning team
    WTEAM_ID=$($PSQL "SELECT team_id from teams where name='$WTEAM'"); 
    #if not found
    if [[ -z $WTEAM_ID ]]
    then
      #insert into teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO TEAMS (name) values ('$WTEAM')")
      if [[ $INSERT_TEAM_RESULT  == "INSERT 0 1" ]]
      then
        echo "Inserting into teams, $WTEAM"
      fi
      #get new team_id for winning team
      WTEAM_ID=$($PSQL "SELECT team_id from teams where name='$WTEAM'"); 
    fi
    #get team_id for opponent team
    OTEAM_ID=$($PSQL "SELECT team_id from teams where name='$OTEAM'"); 
    #if not found
    if [[ -z $OTEAM_ID ]]
    then
      #insert into teams
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO TEAMS (name) values ('$OTEAM')")
      if [[ $INSERT_TEAM_RESULT  == "INSERT 0 1" ]]
      then
        echo "Inserting into teams, $OTEAM"
      fi
      #get new team_id for winning team
      OTEAM_ID=$($PSQL "SELECT team_id from teams where name='$OTEAM'"); 
    fi
    #insert into games
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES ($YEAR, '$ROUND', $WTEAM_ID,$WGOALS,$OTEAM_ID,$OGOALS);")
    if [[ $INSERT_GAME_RESULT  == "INSERT 0 1" ]]
    then
      echo "Inserting into games, $"
    fi
  fi
done

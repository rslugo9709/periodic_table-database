#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

WORD=$1
MAIN(){
  
  if [[ -z $WORD ]]
  then
  ## No input
    echo -e "Please provide an element as an argument."
  else
  
      # if input is a number
    if [[ $WORD =~ ^[0-9]+$ ]]
    then
      
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$WORD;")
      if [[ -z $DATA ]]
      then
       ## Not found
       echo -e "I could not find that element in the database."
      else
        echo $DATA | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
        do
          echo -e "The element with atomic number $WORD is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi
      
    else
      if [[ ${#WORD} -le 2 ]]
      then
        ## find by symbol
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$WORD';")
      if [[ -z $DATA ]]
      then
       ## Not found
       echo -e "I could not find that element in the database."
      else
        echo $DATA | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
        do
          echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi

      fi
      
      if [[ $(expr length "$WORD") > 2 ]]
      then
        ## find by name
        DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name ILIKE '$WORD';")
        if [[ -z $DATA ]]
        then
        ## Not found
        echo -e "I could not find that element in the database."
        else
          echo $DATA | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
          do
            echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
        fi
      fi
    fi

  fi
}


MAIN
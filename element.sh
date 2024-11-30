if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else

    PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE 
    (atomic_number::TEXT = '$1' AND '$1' ~ '^[0-9]+$') OR
    (symbol = '$1' OR name = '$1') LIMIT 1")

    if [[ $ELEMENT ]]; then

    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ELEMENT'")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ELEMENT'")

    ELEMENT_INFO=$($PSQL "SELECT * FROM properties WHERE atomic_number='$ELEMENT'")

    IFS="|" read -r atomic_number type atomic_mass melting_point boiling_point type_id <<< "$ELEMENT_INFO"

    echo "The element with atomic number $ELEMENT is $NAME ($SYMBOL). It's a $type, with a mass of $atomic_mass amu. $NAME has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."

    else
    echo "I could not find that element in the database."
    fi
fi
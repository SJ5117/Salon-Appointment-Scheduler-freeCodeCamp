#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nWelcome to Samuel's Salon!\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # display services
  echo "What would you like?"
  GET_SERVICE=$($PSQL "SELECT service_id, name FROM services")
  echo "$GET_SERVICE" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) ENGINE ;;
    2) ENGINE ;;
    3) ENGINE ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

ENGINE() {
  # ask for phone number
  echo -e "\nEnter your phone number:\n"
  read CUSTOMER_PHONE

  #get phone number
  CUSTOMER_PHONE_GET=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # if phone number doesn't exist
  if [[ -z $CUSTOMER_PHONE_GET ]]
  then
    echo -e "\nEnter your name:\n"
    read CUSTOMER_NAME
    echo -e "\nWelcome, $CUSTOMER_NAME!"

    # add new customer
    ENTER_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # get customer_id, name, and service
  CUSTOMER_ID_GET=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME_GET=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE_GET=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # ask for appointment time
  echo -e "\nEnter preferred appointment time:\n"
  read SERVICE_TIME

  # create appointment
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_GET, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_GET_FORMATTED=$(echo $SERVICE_GET | sed 's/ |/"/')
  CUSTOMER_NAME_GET_FORMATTED=$(echo $CUSTOMER_NAME_GET | sed 's/ |/"/')

  echo -e "\nI have put you down for a $SERVICE_GET_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_GET_FORMATTED."
}

MAIN_MENU

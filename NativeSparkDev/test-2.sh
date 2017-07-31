

echo "$(seq 15 22)"

VALID_PASSWORD="secret" #this is our password.

echo "Please enter the password:"
read PASSWORD

if [[ "$PASSWORD" = "$VALID_PASSWORD" ]]; then
	echo "You have access!"
        echo "$PASSWORD"
        echo "$VALID_PASSWORD"
else
	echo "ACCESS DENIED!"
        echo "$PASSWORD"
        echo "$VALID_PASSWORD"
fi





read -p "Select Benchmark: " benchinput


read -p tes

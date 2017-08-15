
[ ! "$SCRIPT"] && SCRIPT=$(readlink -f "$0")
#[ ! "$ALOJA_DIR" ] && ALOJA_DIR="/home/rradowitz/Documents/aloja" #aloja source dir.
[ ! "$ALOJA_DIR" ] && ALOJA_DIR=$(dirname "$SCRIPT") #aloja source dir.

file=~/$(date +"%Y%m%d%H%M")-Local-Results.txt
echo "Results are generated and saved in your home directory"
echo "$file"


echo $ALOJA_DIR


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

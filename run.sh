if [ "$2" == "64" ]
then
    cd BODY
    ./run64.sh "../${1}"
    cd ../ 
else
    cd BODY
    ./run.sh "../${1}"
    cd ../ 
fi
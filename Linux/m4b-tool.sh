
#echo "Enter the input location of audiobooks:"

#read input





#cd "$input"

#for i in $(ls); do
#    #echo "\"$i/\""
#    in="\"$i/\""
#    out="\"$i.m4b\""
#    echo m4b-tool merge $in --output-file=$out & > output.txt
#done




#The Magic Tree House Collection #1-55 % m4b-tool merge The\ Magic\ Tree\ House\ \(Book\ \#01\)\ -\ Dinosaurs\ Before\ Dark #--output-file="book1.m4b

input="$1"

OIFS="$IFS"
IFS=$'\n'

cd "$input"

IFS="$OIFS"

echo $1 > files

while IFS= read -r file; do 
    ls "$file" > files_new
done < files

while IFS= read -r file_new; do
    m4b-tool merge "$file_new" --output-file "$file_new.m4b" &
done < files_new 

rm -f files
rm -f files_new
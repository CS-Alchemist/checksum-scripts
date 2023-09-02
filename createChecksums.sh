#!/bin/bash
#################################################################################################
#	Dieses Script ist für die erstellung von SHA256 checksums vorgesehen, die für		#
#	jede datei ab einen Wurzelverzeichnis erstellt wird. Eine Liste der Prüfsummen wird	#
#	im Wurzelverzeichnis abgelegt.								#
#################################################################################################

echo -e "Script wird ausgeführt!\n" > /dev/tty
saveIFS=$IFS #Anderes Zeilenende
IFS=$(echo -en "\n\b")
touch checksums_sha256.txt
find ./ -type f | grep -v ./checksums_sha256.txt > /tmp/checksums_sha256_find.txt
cat checksums_sha256.txt | cut -c 67- > /tmp/checksums_sha256_cut.txt
checkPath=$(grep -vx -f /tmp/checksums_sha256_cut.txt /tmp/checksums_sha256_find.txt)
rm /tmp/checksums_sha256_find.txt
rm /tmp/checksums_sha256_cut.txt
rootPWD=$PWD

#Zähle Dateien
count1=0
for i in $checkPath
do
	let count1=count1+1
done

echo -e  "Es werden $count1 Dateien überprüft\n"

#erstelle Checksums
count2=1
percentage=0
for i in $checkPath
do
	#move Courser lines up
	if [ $count2 -gt 1 ]
	then
		echo -en "\e[2A\e[K"
	fi
	let percentage=count2*100
	let percentage=percentage/count1
	echo "Berechne: $i"
	echo "$percentage% sind abgeschlossen"
	sha256sum "$i" >> checksums_sha256.txt 2>/dev/null
	let count2=count2+1
done

IFS=$saveIFS
echo -e "\n\nScript wurde erfolgreich ausgeführt!\n\n" > /dev/tty

exit

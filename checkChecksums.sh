#!/bin/bash
#################################################################################################
#   Dieses Script ist für die Prüfung von SHA256 checksums vorgesehen, die für                  #
#   jede datei ab einen Wurzelverzeichnis (PWD) erstellt wurde. Eine Liste der Prüfsummen       #
#   muss im PWD abgelegt sein.                                                                  #
#################################################################################################

saveIFS=$IFS
IFS=$(echo -en "\n\b")
cwd=$PWD

iter=$(find ./ -name checksums_sha256.txt | sed 's#checksums_sha256.txt##')

checkFilelisted() {
    Files=$(find ./ -type f| grep -v ./checksums_sha256.txt )
    for file in $Files; do
        grep $file ./checksums_sha256.txt > /dev/null
        if [ $? != 0 ]; then
            echo "ERROR: $file has no checksum" 1>&2
        fi
    done
}

for i in $iter
do
    cd $i
    echo checking "$i"
    checkFilelisted
    sha256sum -c checksums_sha256.txt
    [ $? != 0 ] && echo "Es trat ein Fehler auf" 1>&2
    cd $cwd
done
IFS=$saveIFS

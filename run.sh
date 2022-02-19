#!/bin/bash

# create document to source/ from template
# insert date
# clearsign with gpg
# output to records/
# git push

source source/progress.sh

echo << EOF

					WELCOME TO

 _      _  __        _____                             
| |    (_)/ _|      / ____|                            
| |     _| |_ ___  | |     __ _ _ __   __ _ _ __ _   _ 
| |    | |  _/ _ \ | |    / _` | '_ \ / _` | '__| | | |
| |____| | ||  __/ | |___| (_| | | | | (_| | |  | |_| |
|______|_|_| \___|  \_____\__,_|_| |_|\__,_|_|   \__, |
                                                  __/ |
                                                 |___/ 
												 
copyright (c) aidswidjaja 2022 // github.com/aidswidjaja

EOF

echo "Run this script in life-canary/ on macOS/Linux with GNU coreutils"

# h/t https://stackoverflow.com/a/8597411/6299634

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "HEADS UP: ensure you have gdate and gsed from GNU coreutils, and git for this script to work. Install with brew install gdate gsed."
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "HEADS UP: ensure you have gdate and gsed from GNU coreutils, and git for this script to work."
elif [[ "$OSTYPE" == "msys" ]]; then
	echo "WARNING: You're using the MinGW GNU coreutils for Windows. No guarantees this will work: use Windows Subsystem for Linux."
elif [[ "$OSTYPE" == "win32" ]]; then
	echo "WARNING: You're running this bash script on Windows. This probably won't work: use Windows Subsystem for Linux."
else
	echo "WARNING: Unrecognised operating system. Nani?"
fi

if date --version >/dev/null 2>&1 ; then
    echo "INFO: Using GNU date, naisu!"
else
    echo "WARNING: Not using GNU date. This may fail."
fi

echo << EOF
===== DEPENDENCIES =====

- git°
- gpg^
- gsed*
- gtime*

°git (including signed commits) should be configured beforehand
^gpg should be configured. By default, Life Canary assumes the email life-canary@adrian.id.au but you can change this by running the script with an email arg (e.g ./run.sh kirito@aincrad.org).
*sed and time should be from GNU coreutils, not BSD.

EOF

# h/t https://stackoverflow.com/a/238094/6299634

echo "===== BEGINNING EXECUTION ======"

setup_scroll_area
DATE_NAME=$(gdate '+%B_%d_%Y')
DATE_REPLACE=$(gdate '+%B %d %Y')

if [ "$1" == "" ] || [ $# -gt 1 ]; then
	EMAIL="life-canary@adrian.id.au"
else 
	EMAIL="$1"
fi

draw_progress_bar 12

cp source/template.txt unsigned/${DATE_NAME}.txt
draw_progress_bar 24

gsed -i 's/REPLACE_ME/${DATE_REPLACE}/g' unsigned/${DATE_NAME}.txt 
draw_progress_bar 36

gpg --output records/${DATE_NAME}.txt --clearsign unsigned/${DATE_NAME}.txt -u ${EMAIL}
draw_progress_bar 48

cp -f latest_signed.txt records/${DATE_NAME}.txt
draw_progress_bar 60

git add -A
draw_progress_bar 72

git commit -m "New automated entry: ${DATE_REPLACE}"
draw_progress_bar 84

git push origin main
draw_progress_bar 100
destroy_scroll_area

echo "===== FINISHED ======"

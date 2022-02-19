#!/bin/bash

# create document to source/ from template
# insert date
# clearsign with gpg
# output to records/
# git push

# h/t https://stackoverflow.com/a/5947802/6299634

source source/progress.sh

# ANSI escape colour codes

CYAN='\033[0;36m'
NC='\033[0m' # No Color
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTPURPLE='\033[1;35m'
WHITE='\033[1;37m'

printf << EOF

					${WHITE}WELCOME TO${NC}
					${CYAN}
 _      _  __        _____                             
| |    (_)/ _|      / ____|                            
| |     _| |_ ___  | |     __ _ _ __   __ _ _ __ _   _ 
| |    | |  _/ _ \ | |    / _` | '_ \ / _` | '__| | | |
| |____| | ||  __/ | |___| (_| | | | | (_| | |  | |_| |
|______|_|_| \___|  \_____\__,_|_| |_|\__,_|_|   \__, |
                                                  __/ |
                                                 |___/ 
${YELLOW}												 
copyright (c) aidswidjaja 2022 // github.com/aidswidjaja
${NC}
EOF

echo "${LIGHTRED}Run this script in life-canary/ on macOS/Linux with GNU coreutils${NC}"

# h/t https://stackoverflow.com/a/8597411/6299634

if [[ "$OSTYPE" == "linux"* ]]; then
	DATE="date"
	SED="sed"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "${LIGHTPURPLE}HEADS UP: ensure you have gdate and gsed from GNU coreutils, and git for this script to work. Install with brew install gdate gsed.${NC}"
	DATE="gdate"
	SED="gsed"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "${LIGHTPURPLE}HEADS UP: ensure you have gdate and gsed from GNU coreutils, and git for this script to work.${NC}"
	DATE="gdate"
	SED="gsed"
elif [[ "$OSTYPE" == "msys" ]]; then
	echo "${LIGHTRED}WARNING: You're using the MinGW GNU coreutils for Windows. No guarantees this will work: use Windows Subsystem for Linux.${NC}"
elif [[ "$OSTYPE" == "win32" ]]; then
	echo "${LIGHTRED}WARNING: You're running this bash script on Windows. This probably won't work: use Windows Subsystem for Linux.${NC}"
else
	echo "${LIGHTRED}WARNING: Unrecognised operating system. Nani?${NC}"
	DATE="gdate"
	SED="gsed"
fi

if ${DATE} --version >/dev/null 2>&1 ; then
    echo "${CYAN}INFO: Using GNU date, naisu!${NC}"
else
    echo "${LIGHTPURPLE}WARNING: Not using GNU date. This may fail.${NC}"
fi

if ${SED} --version >/dev/null 2>&1 ; then
    echo "${CYAN}INFO: Using GNU date, naisu!${NC}"
else
    echo "${LIGHTPURPLE}WARNING: Not using GNU date. This may fail.${NC}"
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

if [[ ${DATE} == "date" ]]; then
	DATE_NAME=$(date '+%B_%d_%Y')
	DATE_REPLACE=$(date '+%B %d %Y')
else
	DATE_NAME=$(gdate '+%B_%d_%Y')
	DATE_REPLACE=$(gdate '+%B %d %Y')
fi


if [ "$1" == "" ] || [ $# -gt 1 ]; then
	EMAIL="life-canary@adrian.id.au"
else 
	EMAIL="$1"
fi

draw_progress_bar 12

cp source/template.txt unsigned/${DATE_NAME}.txt
draw_progress_bar 24

${SED} -i 's/REPLACE_ME/${DATE_REPLACE}/g' unsigned/${DATE_NAME}.txt 
draw_progress_bar 36

gpg -u ${EMAIL} --output records/${DATE_NAME}.txt --clearsign unsigned/${DATE_NAME}.txt
draw_progress_bar 48

cp -f records/${DATE_NAME}.txt latest_signed.txt
draw_progress_bar 60

git add -A
draw_progress_bar 72

git commit -m "New automated entry: ${DATE_REPLACE}"
draw_progress_bar 84

git push origin main
draw_progress_bar 100
destroy_scroll_area

echo "===== FINISHED ======"

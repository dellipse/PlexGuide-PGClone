#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
projectname () {
pgclonevars

# prevents user from moving on unless email is set
if [[ "$pgcloneemail" == "NOT-SET" ]]; then
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '↘️  ERROR! E-Mail is not setup! | Press [ENTER] ' typed < /dev/tty
keymanagementinterface; fi

projectcheck="good"
if [[ $(gcloud projects list --account=${pgcloneemail} | grep "pg-") == "" ]]; then
projectcheck="bad"; fi

# prompt user
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT PROJECT
$pgclonepublic

[1] Project: Use Existing Project
[2] Project: Build New
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty

case $typed in
1 )
    if [[ "$projectcheck" == "bad" ]]; then
    echo "BAD"
    projectname; fi ;;
2 )

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project Name ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name of your project? Ensure the PROJECT NAME is one word; all lowercase;
no spaces!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Name | Press [Enter]: ' typed < /dev/tty

date=`date +%m%d`
rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
projectid="pg--${date}${rand}"
gcloud projects create $projectid --account=${pgcloneemail}
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Confirm Info | Press [ENTER]: ' typed < /dev/tty
    ;;
Z )
    clonestart ;;
z )
    clonestart ;;
* )
    keyinputpublic ;;
esac

}
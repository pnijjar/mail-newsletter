#!/bin/bash

# Can I send out newsletters?
# (Not very well)


# ===== CONFIG/CONSTANTS 

# configfile bodyfile 
# to_addr 
# from_addr account 
declare -A PARAM
PARAM[watcamp]="watcamp.config.py watcamp.txt \
  watcamp-newsletter@kwlug.org \
  newsletter-watcamp@kwlug.org newsletter.watcamp.kwlug.org"
PARAM[spectrum]="spectrum.config.py spectrum.txt \
  rainbow@listserv.thinkers.org \
  newsletter-spectrum@kwlug.org newsletter.spectrum.kwlug.org"


PYDIR="/home/pnijjar/google-calendar-helpers"
CONFDIR="/home/pnijjar/gcal-confs"
BODYDIR="/home/pnijjar/output"


# ===== FUNCTIONS 

# $1 : the newsletter ID ("spectrum", "watcamp")
# I am doing this because I do not how to encode a
# date in the array.
function get_subject () { 
  datestring=`date +"%b %d, %Y"`
  
  if [[ $1 == "spectrum" ]]
  then
    retval="Rainbow Clearinghouse Events ($datestring listing)"
  else
    retval="$datestring events listing"
  fi  

  # retval is now a GLOBAL VARIABLE. Ugh. 
} 


# ===== MAIN PROGRAM 


source "$PYDIR/venv/bin/activate"


# ${!PARAM[@]} - get keys
for newsletter in "${!PARAM[@]}"
do

    read conffile bodyfile to_addr from_addr account <<< "${PARAM[$newsletter]}"


    $PYDIR/gen_newsletter.py \
      --configfile $CONFDIR/$conffile \
      2>&1 >> /home/pnijjar/logs/cronjob.log

    get_subject $newsletter
    email_subject="$retval"
    email_body=$(<$BODYDIR/$bodyfile)
    email_date=`date -R`

    read -d '' EMAIL <<- EOF
To: $to_addr
From: $from_addr
Subject: $email_subject 
Date: $email_date
Content-Type: text/plain; charset=UTF-8

$email_body
EOF

    echo "$EMAIL" | \
    msmtp -a $account $to_addr
done 

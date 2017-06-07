#!/bin/bash

# Can I send out newsletters?


PYDIR="/home/pnijjar/google-calendar-helpers"
CONFDIR="/home/pnijjar/gcal-confs"

source "$PYDIR/venv/bin/activate"
$PYDIR/gen_newsletter.py --configfile $CONFDIR/watcamp.config.py

WATCAMP_BODY="/home/pnijjar/output/watcamp.txt"


email_subject=`date +"%b %d, %Y events listing"`
email_dest="watcamp-newsletter@kwlug.org"
email_body=$(<$WATCAMP_BODY)


read -d '' EMAIL <<- EOF
To: $email_dest
From: newsletter-watcamp@kwlug.org
Subject: $email_subject 
Content-Type: text/plain; charset=UTF-8

$email_body
EOF

echo "$EMAIL" | \
msmtp -a newsletter.watcamp.kwlug.org $email_dest



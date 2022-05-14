#!/bin/bash


sendmail -t -F SenderDisplayerName <<EOF
SUBJECT: sendmail test subject
TO: chengyanming@58.com
CC: chengyanming@58.com
MIME-VERSION: 1.0
Content-type: text/plain

"sssssss"

EOF

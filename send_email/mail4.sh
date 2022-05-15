# !/bin/sh


from='yanggang@fruitsmobile.com'
from="392184312@qq.com"
to="chengyanming@58.com"

email_date=''
email_content="/Users/chengyanming/Desktop/Advised.xml"
email_subject='Top800_Game_Free_USA'


function send_email(){
    email_date=$(date "+%Y-%m-%d_%H:%M:%S")
    echo $email_date

    email_subject=$email_subject"__"$email_date
    echo $email_subject

    cat $email_content | formail -I "From: $from" -I "MIME-Version:1.0" -I "Content-type:text/html;charset=gb2312" -I "Subject: $email_subject" | /usr/sbin/sendmail -oi $to

}

send_email

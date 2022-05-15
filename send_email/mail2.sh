# !/bin/sh

from_name="from@yanggang"
from="392184312@qq.com"
to="chengyanming@58.com"

email_title="Test Mail"
email_content="/Users/chengyanming/Desktop/Advised.xml"
email_subject="Top800_Games_Free_USA"

echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t

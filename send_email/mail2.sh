# !/bin/sh

from_name="from@yanggang"
from="yanggang@fruitsmobile.com"
to="yanggang_2050@163.com"

email_title="Test Mail"
email_content="/Users/chengyanming/Desktop/sss/report/report1/com.wuba.wsplatformsdk.dispatcher/index.html"
email_subject="Top800_Games_Free_USA"

echo -e "To: \"${email_title}\" <${to}>\nFrom: \"${from_name}\" <${from}>\nSubject: ${email_subject}\n\n`cat ${email_content}`" | /usr/sbin/sendmail -t

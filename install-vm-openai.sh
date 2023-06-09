#!/bin/bash

# Install dos2unix and more
apt install curl apt-transport-https gnupg jq sox flac dos2unix gnupg

# Download sendmail-openai and replace API_KEY
wget https://raw.githubusercontent.com/VitalPBX/vitalpbx-voicemail-transcription-openai/main/sendmail-openai -O /usr/sbin/sendmail-openai
read -p "Enter OpenAI API Key (platform.openai.com): " API_KEY
sed -i "s/API_KEY=\"\"/API_KEY=\"$API_KEY\"/" /usr/sbin/sendmail-openai

# Create voicemail__60-general.conf
cat << EOF > /etc/asterisk/vitalpbx/voicemail__60-general.conf
[general](+)
;You override the default program to send e-mail to use the script
mailcmd=/usr/sbin/sendmail-openai
EOF

# Set permissions for sendmail-openai
cd /usr/sbin/
chown asterisk:asterisk sendmail-openai
chmod 744 sendmail-openai
chmod 755 /usr/bin/dos2unix

# Reload app_voicemail.so module
asterisk -rx "module reload app_voicemail.so"
asterisk -rx "dialplan reload"
echo "Done. Enjoy the Voicemail Transcription!"

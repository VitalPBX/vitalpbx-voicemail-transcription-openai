# Send the Voicemail with a transcription with OpenAI Whisper
Next we show the steps to follow to send the Voicemail with the transcription of the content. There are two ways to do it, using the Script or doing it step by step.

## Prerequisites
- Have installed VitalPBX 4 and configured the sending of Email. This is done in ADMIN/System Settings/Email Settings.
- Create an OpenAI account.
- Create OpenAI API Key
- Have root access to the VitalPBX Server
- Disable conversion to MP3 in SETTING/Voicemail Settings/Voicemail Settings. If you have it enabled.

Install required dependencies
<pre>
apt install curl apt-transport-https gnupg jq sox flac dos2unix gnupg
</pre>

## Create OpenAI API Key
In order to create an API key in OpenAI, you need to have an account with a registered payment method. If you already have this, the next step is to go to the url:
<pre>
https://platform.openai.com/
</pre>
And with your OpenAI credentials you log in and in your account (upper right corner), select Manage account/API keys, and proceed to create API key. We copied it to use later.

## Instalation
Download the sendmail-gcloud file and copy it to /usr/sbin/
<pre>
wget https://raw.githubusercontent.com/VitalPBX/vitalpbx-voicemail-transcription-openai/main/sendmail-openai /usr/sbin/
</pre>

We edit the /usr/sbin/sendmail-openai file and add the API Key that we copied earlier.
<pre>
nano /usr/sbin/sendmail-openai
</pre>

<pre>
API_KEY=""
API_URL="https://api.openai.com/v1/audio/transcriptions"
</pre>

Later we create the file voicemail__60-general.conf in /etc/Asterisk/vitalpbx/ with the following content.
<pre>
nano /etc/asterisk/vitalpbx/voicemail__60-general.conf 
</pre>

Content
<pre>
[general](+)
;You override the default program to send e-mail to use the script
mailcmd=/usr/sbin/sendmail-openai
</pre>

Now we assign the corresponding permissions
<pre>
cd /usr/sbin/
chown asterisk:asterisk sendmail-openai
chmod 744 sendmail-openai
chmod 755 /usr/bin/dos2unix
</pre>

Finally we do a reload of the voicemail module
<pre>
asterisk -rx"module reload app_voicemail.so"
</pre>

Overall, voicemail transcription can be a useful tool for anyone who receives voicemails regularly, and it can provide several benefits, including time savings, improved accessibility, increased accuracy, and convenience.

For more details about the implementation of Google Cloud VoiceMail Transcription, visit the following Blog:

https://vitalpbx.com/blog/vitalpbx-voicemail-transcription-with-openai/

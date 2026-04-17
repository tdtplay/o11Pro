#!/bin/sh
apt update
apt install unrar -y
wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-7.0.2-amd64-static/
mv ffmpeg /usr/local/bin/
mv ffprobe /usr/local/bin/
cd /root
wget https://github.com/tdtplay/o11Pro/raw/refs/heads/main/o11Pro.rar
unrar x o11Pro.rar /home
chmod -R +x /home/o11Pro/
wget https://raw.githubusercontent.com/sibuk76/o11Pro/main/o11Pro.service
chmod +x o11Pro.service
mv ./o11Pro.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable o11Pro.service
systemctl start o11Pro.service

echo "Installation Complete"
echo "Please login http://YOURIP:6060"
echo "USERNAME/PASSWORD admin admin"

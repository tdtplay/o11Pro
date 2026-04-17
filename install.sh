#!/bin/bash

# 1. Limpeza profunda para evitar conflitos de versões anteriores
systemctl stop o11Pro.service >/dev/null 2>&1
rm -rf /home/o11Pro /root/o11Pro.rar* /root/o11Pro.service* /root/ffmpeg*

# 2. Instalação do motor de extração oficial e dependências
# O motor oficial da RARLab é o único que não dá "Unsupported Method"
apt update
apt install wget tar xz-utils p7zip-full -y
wget https://www.rarlab.com/rar/rarlinux-x64-621.tar.gz
tar -xzvf rarlinux-x64-621.tar.gz
cp rar/unrar /usr/bin/unrar
chmod +x /usr/bin/unrar

# 3. Instalação do FFMPEG Estático
wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-*-amd64-static/
mv ffmpeg ffprobe /usr/local/bin/
cd /root

# 4. Download do Painel (Caminho corrigido para evitar Erro 404)
wget -O o11Pro.rar https://github.com/tdtplay/o11Pro/raw/main/o11Pro.rar

# 5. Extração verificada (Garante o status "All OK")
mkdir -p /home/o11Pro
unrar x -y o11Pro.rar /home/

# 6. Configuração do Serviço e Porta 1337 automática
wget -O /etc/systemd/system/o11Pro.service https://raw.githubusercontent.com/tdtplay/o11Pro/main/o11Pro.service
sed -i 's/6060/1337/g' /etc/systemd/system/o11Pro.service

# 7. Correção da porta no arquivo interno de configuração
if [ -f /home/o11Pro/o11.cfg ]; then
    sed -i 's/6060/1337/g' /home/o11Pro/o11.cfg
fi

# 8. Permissões finais e Inicialização
chmod +x /home/o11Pro/o11Pro
chmod -R 777 /home/o11Pro/
systemctl daemon-reload
systemctl enable o11Pro.service
systemctl restart o11Pro.service

echo "--------------------------------------------------"
echo " INSTALAÇÃO À PROVA DE BALAS CONCLUÍDA! "
echo " ACESSE: http://$(wget -qO- eth0.me):1337 "
echo "--------------------------------------------------"

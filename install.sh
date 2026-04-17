#!/bin/bash

# 1. Limpeza total para evitar erros de "arquivo já existe"
systemctl stop o11Pro.service >/dev/null 2>&1
rm -rf /home/o11Pro o11Pro.rar* o11Pro.service* ffmpeg*

# 2. Instalação de dependências (p7zip-full é essencial para o seu .rar)
apt update
apt install p7zip-full wget tar xz-utils -y

# 3. Instalação do FFMPEG (Estático)
wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf ffmpeg-release-amd64-static.tar.xz
# Entra na pasta (o nome varia, por isso o *) e move os binários
cd ffmpeg-*-amd64-static/
mv ffmpeg ffprobe /usr/local/bin/
cd /root

# 4. Download do Painel do repositório correto
# Corrigido para tdtplay/o11Pro conforme sua última atualização
wget https://github.com/tdtplay/o11Pro/raw/main/o11Pro.rar

# 5. Extração sem erros (O 7z resolve o "Unsupported Method")
mkdir -p /home/o11Pro
7z x -y o11Pro.rar -o/home/

# 6. Configuração do Serviço e Porta 1337
wget https://raw.githubusercontent.com/tdtplay/o11Pro/main/o11Pro.service
# Troca a porta 6060 por 1337 no arquivo de serviço
sed -i 's/6060/1337/g' o11Pro.service
mv o11Pro.service /etc/systemd/system/

# 7. Ajuste de porta no config interno
if [ -f /home/o11Pro/o11.cfg ]; then
    sed -i 's/6060/1337/g' /home/o11Pro/o11.cfg
fi

# 8. Permissões e Start
chmod +x /home/o11Pro/o11Pro
chmod -R 777 /home/o11Pro/
systemctl daemon-reload
systemctl enable o11Pro.service
systemctl restart o11Pro.service

echo "--------------------------------------------------"
echo " INSTALAÇÃO CONCLUÍDA COM SUCESSO! "
echo " ACESSE: http://$(wget -qO- eth0.me):1337 "
echo " USUÁRIO: admin / SENHA: admin "
echo "--------------------------------------------------"

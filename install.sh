#!/bin/bash
clear
sitedwn=github.com/PhoenixxZ2023/paineldtunnel
IP=$(wget -qO- ipv4.icanhazip.com)
[[ "$(whoami)" != "root" ]] && {
echo
echo "VOCÊ PRECISA EXECUTAR INSTALAÇÃO COMO ROOT!"
echo
rm install.sh
exit 0
}

ubuntuV=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)

[[ $(($ubuntuV < 20)) = 1 ]] && {
clear
echo "FAVOR INSTALAR NO UBUNTU 20.04 OU 22.04! O SEU É $ubuntuV"
echo
rm /root/install.sh
exit 0
}
[[ -e /root/paineldtunnel/src/index.ts ]] && {
  clear
  echo "O Painel já está instalado. Deseja Removê-lo? (s/n)"
  read remo
  [[ $remo = @(s|S) ]] && {
  cd /root/paineldtunnel
  rm -r painelbackup > /dev/null
  mkdir painelbackup > /dev/null
  cp prisma/database.db painelbackup
  cp .env painelbackup
  zip -r painelbackup.zip painelbackup
  mv painelbackup.zip /root
  rm -r /root/paineldtunnel
  rm /root/install.sh
  echo "Removido com sucesso!"
  exit 0
  }
  exit 0
}
clear
echo "QUAL PORTA DESEJA ATIVAR?"
read porta
echo
echo "Instalando Painel Dtunnel Mod..."
echo
sleep 3
#========================
apt update -y
apt-get update -y
apt install wget -y
apt install curl -y
apt install zip -y
apt install cron -y
apt install unzip -y
apt install screen -y
apt install git -y
curl -fsSL https://deb.nodesource.com/setup_20.x | bash
apt-get install -y nodejs -y
#=========================
git clone https://github.com/PhoenixxZ2023/paineldtunnel.git
cd /root/paineldtunnel
chmod 777 pon poff menudt backmod
mv pon poff menudt backmod /bin
echo "PORT=$porta" > .env
echo "NODE_ENV=\"production\"" >> .env
echo "DATABASE_URL=\"file:./database.db\"" >> .env
token1=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
token2=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
token3=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
echo "CSRF_SECRET=\"$token1\"" >> .env
echo "JWT_SECRET_KEY=\"$token2\"" >> .env
echo "JWT_SECRET_REFRESH=\"$token3\"" >> .env
echo "ENCRYPT_FILES=\"7223fd56-e21d-4191-8867-f3c67601122a\"" >> .env
npm install
npx prisma generate
npx prisma migrate deploy
#=========================
clear
echo
echo
echo "PAINEL DTUNNEL MOD INSTALADO COM SUCESSO!"
echo "Os Arquivos Ficam Na Pasta /root/paineldtunnel"
echo
echo "Comando para ATIVAR: pon"
echo "Comando para DESATIVAR: poff"
echo
echo "Digite comando--> menudt (Para ver o Menu do Painel)"
echo
rm /root/install.sh
pon
else
clear
echo
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
fi

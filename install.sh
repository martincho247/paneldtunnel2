#!/bin/bash
clear
sitedwn=github.com/PhoenixxZ2023/paineldtunnel
IP=$(wget -qO- ipv4.icanhazip.com)
[[ "$(whoami)" != "root" ]] && {
echo
echo "Instale Com Usuário Root!"
echo
rm install.sh
exit 1
}

ubuntuV=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)

[[ $(($ubuntuV < 20)) = 1 ]] && {
clear
echo "A Versão Do Ubuntu Tem Que Ser No Mínimo 20. A Sua É $ubuntuV"
echo
rm /root/install.sh
exit 1
}
[[ -e /root/paineldtunnel/src/index.ts ]] && {
  clear
  echo "O Painel já está instalado. Deseja removê-lo? (s/n)"
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
echo "QUAL PORTA DESEJA USAR?: "
read port
echo
echo "Instalando Painel Dtunnel Mod..."
echo
sleep 3
#========================
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install wget -y
sudo apt-get install curl -y
sudo apt-get install zip -y
sudo apt-get install cron -y
sudo apt-get install unzip -y > /dev/null 2>&1
sudo apt-get install npm -y > /dev/null 2>&1
sudo apt-get install screen -y
sudo apt-get install git -y
curl -fsSL https://deb.nodesource.com/setup_20.x | bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y nodejs -y > /dev/null 2>&1
#=========================
[[ ! -d /etc/paineldtunnel ]] && mkdir /etc/paineldtunnel
cd /etc/paineldtunnel || exit
wget $sitedwn/paineldtunnel.zip > /dev/null 2>&1
unzip -o paineldtunnel.zip > /dev/null 2>&1
rm paineldtunnel.zip > /dev/null 2>&1
cd || exit
chmod 777 -R /etc/paineldtunnel > /dev/null 2>&1
cd /root/paineldtunnel
chmod 777 pon poff menudt backmod
mv pon poff menudt backmod /bin
echo "PORT=$port" > .env
echo "NODE_ENV=\"production\"" >> .env
echo "DATABASE_URL=\"file:./database.db\"" >> .env
token1=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
token2=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
token3=$(node -e "console.log(require('crypto').randomBytes(256).toString('base64'));")
echo "CSRF_SECRET=\"$token1\"" >> .env > /dev/null 2>&1
echo "JWT_SECRET_KEY=\"$token2\"" >> .env > /dev/null 2>&1
echo "JWT_SECRET_REFRESH=\"$token3\"" >> .env > /dev/null 2>&1
echo "ENCRYPT_FILES=\"7223fd56-e21d-4191-8867-f3c67601122a\"" >> .env
npm install
npx prisma generate
npx prisma migrate deploy
#=========================
clear
echo
echo
echo "PAINEL DTUNNELMOD INSTALADO COM SUCESSO!"
echo "Os Arquivos Ficam Na Pasta /root/paineldtunnel"
echo
echo "Comando para ATIVAR: pon"
echo "Comando para DESATIVAR: poff"
echo
echo "Digite menudt Para ver o menu"
echo
rm /root/install.sh
pon
echo
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP\033[0m"
echo
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mao prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
clear
fi

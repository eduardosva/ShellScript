#!/bin/bash
#
# Desenvolvido por Eduardo C. Silva
#
# usage: MysqlBackup.sh

# Define o formato do nome do arquivo
ARQUIVO="Arquivo_$(date +%d_%m_%Y-%H_%M)"

# variáveis do MySQL
HOST="localhost"
USER="root"
PWD_BD="SENHA"
DATABASE="aplicattionBD"
CAMINHO="/usr/backup/"
CAMINHO_COPIA="/usr/backup/copia_backup"

# variaveis do FTP
ATIVA_FTP="nao"
FTPSERVER="192.168.0.196"
USERNAME="user"
PWD_FTP="pass"
LOCALDIR="/bkp_saturno"

f_efetua_transmissao()
{
# conecte-se ao servidor FTP e envie o arquivo
ftp -ni $FTPSERVER <<FIM
user $USERNAME $PWD_FTP
cd $LOCALDIR
mdelete *.tar.gz
mput $ARQUIVO.tar.gz
bye
FIM
}

# utiliza o programa mysqldump para efetuar backup no banco de dados do servidor de MySQL,
# direcionando a saída para o arquivo de backup. O sinal '&&' no final do
# comando significa que o próximo comando só será executado caso este seja realizado
# com sucesso.
mysqldump -h $HOST -u $USER -p$PWD_BD $DATABASE > ${CAMINHO}${ARQUIVO}.sql &&

# Compactando o arquivo de backup
cd ${CAMINHO}
tar -cvzf ${ARQUIVO}.tar.gz ${ARQUIVO}.sql

cp -rf ${ARQUIVO}.tar.gz $CAMINHO_COPIA

# removendo o arquivo original para liberar espaço
rm -f ${CAMINHO}${ARQUIVO}.sql

# espere por 10 segundos
sleep 10

if [ $ATIVA_FTP = "sim" ]; then
        f_efetua_transmissao
else
        echo "Backup Efetuado com sucesso!!!"
fi


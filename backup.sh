#!/bin/bash

CONFIG_FILE="/root/.backup_config"

# Cek apakah file konfigurasi sudah ada
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Masukkan Bot Token :"
    read -r BOT_TOKEN
    echo "Masukkan ID Telegram :"
    read -r ADMIN_ID

    # Simpan ke file konfigurasi
    echo "BOT_TOKEN=\"$BOT_TOKEN\"" > "$CONFIG_FILE"
    echo "ADMIN_ID=\"$ADMIN_ID\"" >> "$CONFIG_FILE"

    echo "Konfigurasi disimpan. Anda tidak perlu memasukkan ulang saat backup berikutnya."
fi

# Pastikan variabel sudah terisi
if [[ -z "$BOT_TOKEN" || -z "$ADMIN_ID" ]]; then
    echo "Error: BOT_TOKEN atau ADMIN_ID tidak valid. Silakan cek file $CONFIG_FILE."
    exit 1
fi

# Mendapatkan tanggal dan IP
date=$(date +"%Y-%m-%d")
IP=$(wget -qO- ipv4.icanhazip.com)

echo "Mohon Menunggu, Proses Backup sedang berlangsung !!"

# Persiapan folder backup
rm -rf /root/backup
mkdir /root/backup

# Copy file konfigurasi penting
cp -r /etc/passwd /root/backup/ &> /dev/null
cp -r /etc/group /root/backup/ &> /dev/null
cp -r /etc/shadow /root/backup/ &> /dev/null
cp -r /etc/gshadow /root/backup/ &> /dev/null
cp -r /usr/bin/idchat /root/backup/ &> /dev/null
cp -r /usr/bin/token /root/backup/ &> /dev/null
cp -r /etc/per/id /root/backup/ &> /dev/null
cp -r /etc/per/token /root/backup/token2 &> /dev/null
cp -r /etc/perlogin/id /root/backup/loginid &> /dev/null
cp -r /etc/perlogin/token /root/backup/logintoken &> /dev/null
cp -r /etc/xray/config.json /root/backup/xray &> /dev/null
cp -r /etc/xray/ssh /root/backup/ssh &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html &> /dev/null
cp -r /etc/xray/sshx /root/backup/sshx &> /dev/null
cp -r /etc/xray/noob /root/backup/noob &> /dev/null
cp -r /etc/vmess /root/backup/vmess &> /dev/null
cp -r /etc/vless /root/backup/vless &> /dev/null
cp -r /etc/trojan /root/backup/trojan &> /dev/null
cp -r /etc/trojan-go /root/backup/trojan-go &> /dev/null
cp -r /etc/issue.net /root/backup/issue &> /dev/null

# Buat file ZIP backup
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1

# Kirim file backup ke bot Telegram
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
    -F "chat_id=$ADMIN_ID" \
    -F "document=@/root/$IP-$date.zip" \
    -F "caption= Vps Data Backup Done ✅"
    -F "parse_mode=Markdown"

# Hapus file backup setelah dikirim
rm -rf /root/backup
rm -r /root/$IP-$date.zip

echo "Backup selesai dan telah dikirim ke bot Telegram."

#!/bin/bash

echo "List file backup yang tersedia di /root/:"
ls /root/*.tar.gz 2>/dev/null

echo "Masukkan nama file backup yang ingin di-restore (contoh: 192.168.1.1-2025-03-03.zip):"
read -r FILE_NAME

# Pastikan file ada
if [[ ! -f "/root/$FILE_NAME" ]]; then
    echo "Error: File backup tidak ditemukan!"
    exit 1
fi

# Ekstrak file backup
echo "Menyiapkan proses restore..."
rm -rf /root/restore
mkdir /root/restore
tar -xzf /root/$FILE_NAME -C /root/restore

# Restore file ke lokasi aslinya
cp -r /root/restore/passwd /etc/ &> /dev/null
cp -r /root/restore/group /etc/ &> /dev/null
cp -r /root/restore/shadow /etc/ &> /dev/null
cp -r /root/restore/gshadow /etc/ &> /dev/null
cp -r /root/restore/idchat /usr/bin/ &> /dev/null
cp -r /root/restore/token /usr/bin/ &> /dev/null
cp -r /root/restore/per /etc/ &> /dev/null
cp -r /root/restore/perlogin /etc/ &> /dev/null
cp -r /root/restore/xray /etc/ &> /dev/null
cp -r /root/restore/public_html /home/vps/ &> /dev/null
cp -r /root/restore/vmess /etc/ &> /dev/null
cp -r /root/restore/vless /etc/ &> /dev/null
cp -r /root/restore/trojan /etc/ &> /dev/null
cp -r /root/restore/trojan-go /etc/ &> /dev/null
cp -r /root/restore/issue /etc/ &> /dev/null

# Bersihkan file sementara
rm -rf /root/restore

echo "✅ Restore selesai! Silakan restart VPS untuk menerapkan perubahan."
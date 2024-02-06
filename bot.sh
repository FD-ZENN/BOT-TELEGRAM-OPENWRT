#!/bin/sh

# Host yang digunakan
host="xl-unlimited.fdesign-performance.my.id"
hostname="$(uci -q get system.@system[0].hostname)"
uptime=$(echo $(date "+%H:%M:%S"))
wan=$(ip r | awk '/default/ {print $5,$9}')
trafik1=$(vnstat -i br-lan -tr | awk '$1 == "rx" {print $2,$3}')
trafik2=$(vnstat -i br-lan -tr | awk '$1 == "tx" {print $2,$3}')
kouta=$(vnstat -i br-lan -m | awk '$1 == "estimated" {print $5,$6}')
crontab=$(crontab -l)
ping=$(ping -c 1 104.18.225.52 | grep from* | wc -l)
device=$(ip neigh | grep br-lan | grep lladdr | awk '{print $1,$6}')
firewall_Status=$(/etc/init.d/firewall status)
dnsmasq_Status=$(/etc/init.d/dnsmasq status)
openclash_Status=$(/etc/init.d/openclash enabled)
zerotier_Status=$(/etc/init.d/zerotier status)
cloudflared_Status=$(/etc/init.d/cloudflared status)
# Bot Telegram token dan chat ID
bot_token="isi bot token anda"
chat_id="isi chat id anda"

# Fungsi untuk mengirim pesan ke bot Telegram
send_telegram_message() {
    message="$1"
    curl -s -X POST https://api.telegram.org/bot$bot_token/sendMessage -d chat_id=$chat_id -d text="$message"
}

# Fungsi untuk restart layanan
restart_service() {
    service_name="$1"
    /etc/init.d/$service_name restart
}

# Memeriksa koneksi
ping -c 1 $host > /dev/null

# Jika ping berhasil
if [ $? -eq 0 ]; then
    echo "Berhasil terkoneksi ke $host."
    restart_service zerotier
    restart_service cloudflared
    sleep 30
    send_telegram_message "
===TELEGRAM-BOT====

// Check Service
// 🆗 $hostname
// 🆗 Berhasil terkoneksi
// 🆗 Ke CDN

// Layanan Aktif
// 🆙 Firewall $firewall_Status
// 🆙 DNSMasq $dnsmasq_Status
// 🆙 Openclash $openclash_Status
// 🆙 Zerotier $zerotier_Status
// 🆙 Cloudflared $cloudflared_Status

// Estimasi Pemakaian
// 🔄 $uptime
// 🔄 $wan
// 🔄 U $trafik1
// 🔄 D $trafik2
// 🔄 Q $kouta

// FD-ZENN @ 2024
=================
"
    exit 0
fi

# Jika ping gagal
echo "Ping ke $host gagal. Merestart layanan dan mengirim pesan notifikasi ke Telegram..."
# Restart layanan-layanan yang ditentukan
restart_service firewall
restart_service dnsmasq
restart_service openclash
restart_service zerotier
restart_service cloudflared

# Kirim pesan notifikasi ke Telegram
sleep 30
send_telegram_message "
===TELEGRAM-BOT====

// Check Service
// 🚫 $hostname
// 🚫 Gagal terkoneksi
// 🚫 Ke CDN

// Layanan Aktif
// 🚫 Firewall $firewall_Status
// 🚫 DNSMasq $dnsmasq_Status
// 🚫 Openclash $openclash_Status
// 🚫 Zerotier $zerotier_Status
// 🚫 Cloudflared $cloudflared_Status

// Estimasi Pemakaian
// 🔄 $uptime
// 🔄 $wan
// 🔄 U $trafik1
// 🔄 D $trafik2
// 🔄 Q $kouta

// FD-ZENN @ 2024
=================
"

check_service_status "firewall"
check_service_status "dnsmasq"
check_service_status "openclash"
check_service_status "zerotier"
check_service_status "cloudflared"

# Jika Crontab Hilang (Tambahkan Crontab)
crontab -l ; echo "0 * * * * /sbin/bot.sh" | crontab -

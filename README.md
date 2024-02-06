Script ini adalah skrip Shell yang digunakan untuk memantau dan mengelola berbagai layanan pada sebuah sistem. Berikut adalah ringkasan singkat dari fungsionalitas skrip:

Konfigurasi Host:

Skrip menetapkan variabel host ke alamat host tertentu.
Mengambil nama host sistem menggunakan uci dan menyimpannya dalam variabel hostname.
Mengumpulkan informasi tentang uptime, koneksi WAN, lalu lintas, kuota, dan rincian status lainnya.
Pemeriksaan Status Layanan:

Memeriksa koneksi ke host yang ditentukan menggunakan perintah ping.
Jika ping berhasil, skrip akan me-restart layanan tertentu (zerotier dan cloudflared), kemudian mengirimkan pesan keberhasilan ke bot Telegram.
Integrasi Bot Telegram:

Mendefinisikan fungsi (send_telegram_message) untuk mengirim pesan ke bot Telegram menggunakan perintah curl.
Mengirim pesan status ke chat ID Telegram yang dikonfigurasi, termasuk informasi tentang status layanan, uptime, detail WAN, dan lainnya.
Fungsi Restart Layanan:

Mendefinisikan fungsi (restart_service) untuk me-restart layanan tertentu menggunakan /etc/init.d/[service_name] restart.
Penanganan Kegagalan:

Jika ping ke host gagal, skrip akan me-restart beberapa layanan (firewall, dnsmasq, openclash, zerotier, dan cloudflared) dan mengirim pesan kegagalan ke bot Telegram.
Pemeriksaan Crontab:

Memeriksa apakah crontab berisi skrip (/sbin/bot.sh). Jika tidak, menambahkan entri crontab untuk menjalankan skrip setiap jam.
Fungsi Pemeriksaan Status Layanan:

Ada pemanggilan ke fungsi check_service_status untuk setiap layanan (firewall, dnsmasq, openclash, zerotier, cloudflared), tetapi fungsi itu sendiri tidak diberikan dalam skrip.
Token dan ID Chat Bot Telegram:

Token dan ID chat bot Telegram didefinisikan sebagai variabel di awal skrip.
Catatan:

Pastikan untuk menggantikan nilai-nilai tempat penampung seperti isi bot token anda dan isi chat id anda dengan token dan ID chat Telegram yang sesungguhnya.
Pastikan bahwa perintah-perintah yang diperlukan (vnstat, ip, ping, dll.) tersedia di sistem Anda.

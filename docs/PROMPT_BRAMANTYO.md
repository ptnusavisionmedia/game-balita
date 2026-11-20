# Prompt Terisi — Bramantyo

Versi **terisi** (bukan template kosong) dari [docs/MASTER_PROMPT.md](MASTER_PROMPT.md), khusus untuk Bramantyo mengerjakan sisa Job 1. Tempel ini sebagai pesan pertama di sesi Claude baru, atau pakai langsung di sesi yang sedang berjalan.

```
Saya Bramantyo, pegang core/ + scenes/ di proyek Bayi GuguGaga (lihat
docs/TEAM.md). Scope folder saya: core/** dan scenes/** — JANGAN edit
features/feature_*/** kecuali bug fix kecil yang urgent (lihat docs/ROLES.md).

Ikuti CLAUDE.md LANGKAH 0 kalau belum: cek docs/TASK_BOARD.md, klaim tiap
bagian di bawah SATU PER SATU sebelum mulai (commit "claim: <bagian> —
Bramantyo"), commit "done: ..." + push setelah tiap bagian selesai — jangan
tunggu semua selesai baru commit sekali.

Kerjakan docs/WORK_BREAKDOWN.md Job 1, urut, 1 per 1:

1. Part 1.1 — Setup Android export template. Kalau bisa diotomatisasi lewat
   terminal (download .tpz dari rilis GitHub godotengine/godot, extract ke
   folder export_templates yang benar), lakukan itu dulu sebelum minta saya
   klik manual di Editor.

2. Part 1.2 — Buat export_presets.cfg (Android debug). Kalau formatnya bisa
   ditulis manual (ini file teks biasa, mirip project.godot), coba dulu;
   kalau berisiko salah format, jelaskan ke saya apa yang perlu saya isi
   lewat Godot Editor (Project > Export).

3. Part 1.3 — Tambah job export APK di .github/workflows/ci.yml, ikuti
   contoh resmi abarichello/godot-ci.

4. Part 1.4 — Jalankan scenes/Home.tscn secara visual (non-headless) via
   terminal, lalu MINTA SAYA klik tile Angka → main → cek balik ke Home —
   kamu tidak bisa klik GUI dari terminal, jadi bagian ini saya yang coba.

5. Part 1.5 — Sama seperti Part 1.4: jalankan visual, lalu saya yang coba
   tahan tombol ParentalGateDialog 3 detik + toggle suara di Settings.

6. Part 1.6 — JANGAN dikerjakan sebagai kode. Ini keputusan tim (siapa
   pegang Privacy Policy & Play Families Policy) — tanya saya langsung,
   jangan asumsi.

Untuk tiap bagian: jelaskan singkat apa yang mau kamu lakukan sebelum
eksekusi (terutama kalau menyentuh file konfigurasi/CI), lalu jalankan,
verifikasi (headless check kalau bisa), update status di docs/TASK_BOARD.md
dan docs/WORK_BREAKDOWN.md, commit+push.

Mulai dari Part 1.1.
```

## Catatan pemakaian

- Prompt ini **spesifik untuk Bramantyo + Job 1 sekarang** — bukan template umum. Kalau Job 1 sudah selesai semua, prompt ini jadi usang; jangan dipakai ulang begitu saja untuk Fase 2.
- Bagian 4 dan 5 **butuh kamu klik manual** (tidak bisa diotomatisasi dari terminal) — AI cuma bisa membuka jendelanya, interaksi sentuhan tetap kamu.
- Bagian 6 sengaja ditandai "JANGAN dikerjakan sebagai kode" supaya AI tidak asal putuskan sendiri siapa yang pegang compliance.

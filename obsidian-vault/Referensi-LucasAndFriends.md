# Referensi: Lucas & Friends (Kids Games)

Sumber: Notion — [Referensi: Lucas & Friends (Kids Games)](https://app.notion.com/p/Referensi-Lucas-Friends-Kids-Games-41a9d69ed35a814495ccd894b5832be9), analisis dibuat dengan menjalankan aplikasi asli (RV AppStudios) di tablet fisik via ADB. Disalin ringkasannya ke sini (2026-11-21) supaya tim tidak perlu akses Notion buat lihat insight-nya, dan supaya tercatat di git bareng keputusan desain yang dipicu olehnya.

## Ringkasan alur kompetitor

Splash (4 maskot) → Menu Utama ("Main" ungu besar + "Pilih Mode" biru + tombol sekunder: Bahasa/Hadiah/Pengaturan/Untuk Orang Tua) → **Main = rangkaian mini-game TANPA AKHIR** (tombol X oranye = lanjut ke game lain, bukan keluar — tombol back Android diblokir total selama gameplay).

## Mini-game yang ditemukan

| Mini-game | Mekanik |
|---|---|
| Hitung & Cocokkan | Drag angka ke kotak "?" sesuai jumlah objek, tanpa limit waktu, tanpa state "salah" terlihat |
| Selesaikan Polanya | Pola ABAB, drag jawaban dari rak pilihan |
| Pilih Stempel | Free-play murni, tap stempel → stiker muncul, tanpa skor/target |

## Kekuatan yang dicontoh

- Tanpa teks baca di dalam gameplay — instruksi lewat gambar/suara
- Target sentuh besar (≥120px), berjarak renggang
- Feedback instan & selalu positif, tidak pernah ada "gagal"
- Alur infinity (X = lanjut terus) — tidak ada tekanan menang/kalah
- Mode bebas diselingi di antara mini-game bertujuan

## Kelemahan yang dihindari

- Parent gate "Untuk Orang Tua" **tanpa verifikasi** — cuma halaman brand-story
- Tidak ada tombol "keluar aplikasi" yang jelas (X cuma skip)
- Tidak ada indikator durasi bermain

## Palet warna (perkiraan)

| Elemen | Warna | Catatan |
|---|---|---|
| Langit/background | Biru muda (~#6FD1F2) | Dominan, menenangkan |
| Rumput/tanah | Hijau segar (~#8BD44C) | 2 tingkat buat kedalaman |
| Tombol utama | Ungu-magenta (~#B14FE0) | Paling mencolok |
| Tombol aksi/exit | Oranye-coral (~#F2764A) | Konsisten di SEMUA tombol tekan |
| Maskot | Kuning-oranye (~#F4B23E) | Kontras dari latar dingin |

**Prinsip inti**: warna dingin (biru/hijau) = latar/dekorasi, warna hangat jenuh = elemen interaktif — balita bisa bedain tanpa baca.

## Temuan lanjutan (sesi eksplorasi ke-2 kompetitor)

- Gate sesungguhnya ada di "PILIH MODE" (bukan "Untuk Orang Tua"): kode dieja dalam **kata** ("Tujuh, Lima, Lima, Tujuh" = 7557), bukan dilihat sebagai digit — pre-reader tidak bisa mengeja kata jadi angka, mekanisme COPPA-friendly.
- Di baliknya: panel kurasi ±40 kategori mini-game (checkbox pilih yang mana boleh tampil) — 1 mesin game, puluhan skin aset.
- Ikon X ambigu (berarti "lanjut" di gameplay tapi "tutup panel" di menu) — sumber bingung.
- Tidak ada kontrol durasi/screen-time di panel manapun.
- "Hadiah" = galeri koleksi 3-tab (Mainan/Stiker/Stempel) terkunci — lapisan retensi independen dari sesi main.

## Yang sudah diadopsi ke Wawa (2026-11-21)

- [x] **Prinsip warna**: tambah `AppColors.SKY`/`GRASS`/`GRASS_DARK` + `core/scripts/game_background.gd` (`GameBackground`) — background "langit+rumput" dipasang di Home + 6 `feature_*` (sebelumnya banyak scene gameplay tidak punya background sama sekali, polos warna default kosong).
- [x] **Target sentuh besar**: `BigRoundButton` dinaikkan dari 88px → 120px, keping/slot `feature_puzzle` dinaikkan ke 110-120px.
- [x] Alur infinity (X/Play = lanjut terus) — **sudah match** dari awal lewat `GameFlow.start_random_game()`, konfirmasi desain kita sudah di jalur yang benar.
- [x] Mode bebas diselingi mini-game bertujuan — **sudah match** lewat `feature_musik`/`feature_mewarnai` (sengaja tanpa soal benar/salah).
- [x] Feedback selalu positif, tidak pernah "gagal" terlihat — **sudah match**, bahkan lebih jauh (sudah hapus skor/bintang juga, lihat Decisions Log 2026-11-20/21).

## Belum diadopsi (dicatat sebagai ide, bukan keputusan — perlu dibahas dulu)

- [ ] Parent gate kita (soal tambah + keypad digit) secara teori masih bisa "ditembus" trial-error acak (range jawaban kecil). Kompetitor pakai kode dieja KATA (pre-reader tidak bisa mengeja). **Belum diubah** — ini perubahan ke fitur yang baru selesai dites, jangan ubah tanpa diminta eksplisit.
- [ ] Tombol "Keluar Aplikasi" yang benar-benar keluar, terpisah dari navigasi "lanjut" — app kita belum punya exit eksplisit (cuma 🏠 = balik Home). Perlu dipikirkan apakah relevan buat app kita (kompetitor punya alasan: X mereka ambigu, 🏠 kita sudah jelas "bukan keluar app").
- [ ] Panel kurasi konten orang tua (checkbox pilih kategori yang boleh tampil) — fitur besar, belum ada rencana headcount/scope.
- [ ] Kontrol durasi/screen-time — peluang diferensiasi, belum masuk roadmap manapun.
- [ ] Lapisan koleksi/hadiah terpisah dari sesi main — disebut selaras dengan "Toko Kiko" yang katanya sudah direncanakan di proyek/dokumen lain (di luar repo ini) — perlu klarifikasi user apa itu & apakah relevan ke Wawa.
- [ ] Maskot karakter — app kita belum punya maskot sama sekali, cuma ikon vektor abstrak (`ModuleIcon`). Ini butuh ilustrasi asli dari Asset 1, bukan sesuatu yang bisa dibuat lewat kode.

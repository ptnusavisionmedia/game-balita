# Spec: feature_puzzle

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 4 (`docs/TEAM.md`), modul kedua Dev 4 setelah `feature_mewarnai`.

Interaksi utama: **Update 2026-11-21 (ke-3) — Tap pilih, lalu tap taruh** (bukan drag asli). Drag asli Godot (`Control._get_drag_data`/`_can_drop_data`/`_drop_data`) ternyata **tidak reliable** di setup canvas-stretch project ini — 3 percobaan beda (lihat Decisions Log 2026-11-21) semuanya area klik/drop-nya tidak sinkron dengan yang kelihatan di layar, dilaporkan user langsung. Diganti ke tap-pilih-lalu-taruh pakai `Button` biasa (terbukti konsisten di semua modul lain), yang juga **lebih sesuai motorik anak 1-5 tahun** dibanding drag gesture asli — bukan cuma workaround teknis. `docs/UI_UX_DESIGN.md` tabel interaksi diupdate menyesuaikan.

## Aturan main level 1

- Tampilkan 1 gambar sederhana dipecah jadi **3-4 keping** (bukan langsung 6 — mulai lebih mudah, naikkan jumlah keping di level selanjutnya begitu base model lolos).
- Keping (kotak warna) ditaruh berantakan di baris bawah, slot target (outline kosong) ditampilkan di baris atas, urutan slot **tidak sama** dengan urutan keping supaya anak benar-benar mencocokkan.
- Anak **tap 1 keping** (jadi "terpilih", ditandai border emas) → **tap 1 slot** yang warnanya cocok → keping "masuk" ke slot (slot terisi warna, keping aslinya disembunyikan). Tap keping lagi buat ganti pilihan sebelum menaruh.
- Tap slot yang **tidak cocok** dengan keping terpilih → **diam saja**, tidak ada animasi/suara "gagal", keping tetap terpilih (anak boleh coba slot lain atau ganti pilihan keping).

## Jumlah "soal" per sesi → diganti jadi jumlah keping

- 1 gambar = 1 sesi (3-4 keping buat level 1). Selesai kalau semua keping sudah di slot yang benar.
- Beda dari modul lain: **tidak ada pengulangan "soal ke-2, ke-3"** dalam 1 sesi — 1 puzzle yang diselesaikan = 1 sesi penuh (karena menyusun ulang 1 puzzle sudah makan waktu/usaha cukup buat 1 sesi, beda dari tebak 1 soal cepat di `feature_angka`/`feature_hewan`).

## Kondisi selesai

- Semua keping di tempat benar → `StarRewardOverlay` (confetti + ikon ✓, tanpa jumlah bintang) → `ProgressRepository.record_result("feature_puzzle", ...)` → auto-lanjut `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 wajib ada — **penting khusus modul ini** karena 1 sesi bisa makan waktu lebih lama dari modul lain, anak/orang tua harus tetap bisa keluar kapan saja tanpa harus selesaikan puzzle dulu.

## Feedback

- Keping ditaruh di slot benar: suara "benar" ringan, slot berubah jadi warna penuh.
- Tap slot yang tidak cocok dengan keping terpilih: **diam saja**, tidak ada suara negatif, tidak ada hitungan "percobaan gagal".
- Ini modul paling pas buat **scaffolding Vygotsky** (lihat `docs/PLAN_TUMBUH_KEMBANG.md` bagian 1.4 & 3) — orang tua bisa bantu dikit ("coba potongan yang bentuknya mirip ini dulu") pas anak diam lama tanpa progres, tapi ini murni lewat kartu Panduan Orang Tua yang sudah ada (`core/data/parent_guide.json`), **bukan** mekanik 2-mode seperti `feature_hewan` — modul ini tetap 1 mekanik gameplay.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| 1 gambar sederhana + versi terpotong 3-4 keping | gambar | Bentuk simpel (kontras jelas antar keping), mulai 1 gambar cukup |
| `sfx_correct.mp3` | audio | Reuse dari modul lain |
| Data posisi/bentuk keping | data | 1 file per gambar di `features/feature_puzzle/data/` |

## Catatan lain

- Level 1 pakai **4 keping** — angka "≤6" di `docs/UI_UX_DESIGN.md` itu batas atas buat level awal secara umum, bukan target wajib. Naikkan jumlah keping cuma kalau sesi 4 keping sudah terasa gampang pas dites.
- **Tidak pakai drag & drop** `Control._get_drag_data()` dkk — lihat alasan di atas (tidak reliable di canvas-stretch setup project ini). Kalau modul lain nanti butuh drag sungguhan, uji dulu di device/resolusi nyata sebelum percaya pola ini jalan, jangan asumsikan otomatis beres cuma karena ditulis sesuai dokumentasi Godot.

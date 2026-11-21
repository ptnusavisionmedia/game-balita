# Spec: feature_puzzle

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 4 (`docs/TEAM.md`), modul kedua Dev 4 setelah `feature_mewarnai`.

Interaksi utama: **Drag**, potongan besar (≤6 keping untuk level awal), **snap longgar** (lihat `docs/UI_UX_DESIGN.md` tabel interaksi).

## Aturan main level 1

- Tampilkan 1 gambar sederhana dipecah jadi **3-4 keping** (bukan langsung 6 — mulai lebih mudah, naikkan jumlah keping di level selanjutnya begitu base model lolos).
- Keping ditaruh berantakan di area bawah/samping, outline target (siluet kosong) ditampilkan di tengah.
- Anak drag 1 keping ke outline target yang cocok. **Snap longgar**: kalau keping dilepas dalam radius toleransi besar (bukan harus pas piksel), otomatis "snap" ke posisi benar.
- Kalau keping dilepas jauh dari slot manapun → keping tetap di posisi situ (bukan otomatis kembali/dilempar balik), anak boleh coba drag lagi kapan saja — **tidak ada animasi/suara "gagal"** kalau belum pas, cukup diam saja sampai berhasil snap.

## Jumlah "soal" per sesi → diganti jadi jumlah keping

- 1 gambar = 1 sesi (3-4 keping buat level 1). Selesai kalau semua keping sudah di slot yang benar.
- Beda dari modul lain: **tidak ada pengulangan "soal ke-2, ke-3"** dalam 1 sesi — 1 puzzle yang diselesaikan = 1 sesi penuh (karena menyusun ulang 1 puzzle sudah makan waktu/usaha cukup buat 1 sesi, beda dari tebak 1 soal cepat di `feature_angka`/`feature_hewan`).

## Kondisi selesai

- Semua keping di tempat benar → `StarRewardOverlay` (confetti + ikon ✓, tanpa jumlah bintang) → `ProgressRepository.record_result("feature_puzzle", ...)` → auto-lanjut `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 wajib ada — **penting khusus modul ini** karena 1 sesi bisa makan waktu lebih lama dari modul lain, anak/orang tua harus tetap bisa keluar kapan saja tanpa harus selesaikan puzzle dulu.

## Feedback

- Keping snap ke tempat benar: suara "benar" ringan + animasi kecil (keping "klik" ke posisi).
- Keping belum pas: **diam saja**, tidak ada suara negatif, tidak ada hitungan "percobaan gagal".
- Ini modul paling pas buat **scaffolding Vygotsky** (lihat `docs/PLAN_TUMBUH_KEMBANG.md` bagian 1.4 & 3) — orang tua bisa bantu dikit ("coba potongan yang bentuknya mirip ini dulu") pas anak diam lama tanpa progres, tapi ini murni lewat kartu Panduan Orang Tua yang sudah ada (`core/data/parent_guide.json`), **bukan** mekanik 2-mode seperti `feature_hewan` — modul ini tetap 1 mekanik gameplay.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| 1 gambar sederhana + versi terpotong 3-4 keping | gambar | Bentuk simpel (kontras jelas antar keping), mulai 1 gambar cukup |
| `sfx_correct.mp3` | audio | Reuse dari modul lain |
| Data posisi/bentuk keping | data | 1 file per gambar di `features/feature_puzzle/data/` |

## Catatan lain

- Level 1 pakai **3-4 keping**, bukan langsung maksimal 6 seperti disebut di `docs/UI_UX_DESIGN.md` — angka "≤6" itu batas atas buat level awal secara umum, bukan target wajib di percobaan pertama. Naikkan jumlah keping cuma kalau sesi 3-4 keping sudah terasa gampang pas dites.
- Drag & drop pakai `Control._get_drag_data()`/`_drop_data()` bawaan Godot (lihat `docs/LIBRARIES.md` — tidak perlu addon gestur tambahan).

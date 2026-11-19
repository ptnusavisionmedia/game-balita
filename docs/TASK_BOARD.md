# Task Board

Living document — **wajib diupdate**, bukan cuma dibaca. Lihat cara klaim task di [CLAUDE.md](../CLAUDE.md) (LANGKAH 0 — wajib di setiap conversation/sesi baru, sebelum kerja apa pun). Status: `Open` (belum diambil) → `Claimed` (sudah diambil, belum selesai) → `Done`.

Commit klaim pakai format `claim: <nama task> — <nama orang>`, commit selesai pakai `done: <nama task> — <nama orang>`.

Tidak diurutkan per tanggal — diurutkan per modul/area. Tambah baris baru kalau ada task baru yang belum tercatat, jangan hapus baris `Done` (biar ada histori).

> **2026-11-19**: stack diganti dari Flutter/Dart ke **Godot/GDScript** (lihat Decisions Log). Semua baris `Done` versi Flutter dihapus bersama kodenya; baris di bawah ini sudah versi Godot.

| Task | Role | Area | Status | PIC | Tgl klaim | Catatan |
|---|---|---|---|---|---|---|
| `AppColors`, `StarRewardOverlay`, `ParentalGateDialog`, `ProgressRepository`, `SfxService`/`AudioService` (Godot) | Dev | core | Done | (sesi AI, 2026-11-19) | 2026-11-19 | `core/scripts/`, `core/scenes/` — belum dicoba di Godot Editor sungguhan |
| Wiring navigasi Home ↔ Settings ↔ mini-game | Dev | scenes | Done | Dev App | 2026-11-19 | `scenes/home.gd` |
| `Settings.tscn` (toggle suara) | Dev | scenes | Done | Dev App | 2026-11-19 | `scenes/settings.gd` |
| `feature_angka`: UI + logic soal (pilot base model) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | `features/feature_angka/angka.gd` |
| `feature_angka`: wiring ke core (reward/sfx/progress) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | StarRewardOverlay + ProgressRepository + SfxService sudah terpasang |
| Placeholder scene 5 modul lain (Warna/Hewan/Musik/Mewarnai/Puzzle) | Dev | feature_* | Done | (sesi AI, 2026-11-19) | 2026-11-19 | Cuma tombol "Kembali", isi logic-nya di Job 4-8 |
| CI/Docker untuk Godot (export headless) | Dev | infra | Open | Bramantyo | | belum dibuat ulang setelah reset — lihat docs/DOCKER.md, image `barichello/godot-ci` |
| Verifikasi: buka project di Godot Editor/headless, cek semua scene lolos | Dev | base model | Done | (sesi AI, 2026-11-19) | 2026-11-19 | Godot 4.7.2 — semua 8 scene exit 0 headless; export APK/interaksi sentuhan asli masih belum dicoba |
| CI/Docker untuk Godot (export headless) | Dev | infra | Claimed | (sesi AI, 2026-11-19) | 2026-11-19 | `.github/workflows/ci.yml` sudah ditulis & binary/flag terverifikasi (validate step), export job (APK) masih belum — lanjutannya milik Bramantyo |
| Spek + asset list `feature_warna` | Dev | feature_warna | Open | Dev Warna | | |
| Spek + asset list `feature_hewan` | Dev | feature_hewan | Open | Dev 3 | | |
| Spek + asset list `feature_musik` | Dev | feature_musik | Open | Dev Musik | | |
| Spek + asset list `feature_mewarnai` | Dev | feature_mewarnai | Open | Dev 4 | | |
| Spek + asset list `feature_puzzle` | Dev | feature_puzzle | Open | Dev Puzzle | | |
| `docs/QA_CHECKLIST.md` + pertimbangkan addon GUT | Dev | lintas-modul | Open | Dev Testing | | lihat JOBS_BASE_MODEL Job 9 |
| Style guide ilustrasi | Asset | branding | Open | Asset 1 | | acuan semua modul berikutnya |
| Ilustrasi `feature_angka` (1-5 objek, ganti ikon hati placeholder) + app icon/splash draft | Asset | feature_angka | Open | Asset 1 | | |
| SFX dasar (tap/benar/coba-lagi) | Asset | core | Open | Asset 2 | | dipakai via SfxService, format .wav/.ogg |
| VO angka 1-5 (Bahasa Indonesia) | Asset | feature_angka | Open | Asset 2 | | |
| Riset referensi video + draft konsep promo | Asset | marketing | Open | Asset 3 | | |
| Draft listing Play Store Console (belum publish) | Asset | marketing | Open | Asset 3 | | koordinasi Bramantyo + Dev App untuk export APK |
| Assist ilustrasi (tunggu style guide) | Asset | feature_warna | Open | Asset 4 | | lihat JOBS_BASE_MODEL Job 13 |
| Assist audio (tunggu spek feature_musik) | Asset | feature_musik | Open | Asset 5 | | lihat JOBS_BASE_MODEL Job 14 |
| Assist riset referensi + dokumentasi asset pipeline | Asset | marketing | Open | Asset 6 | | lihat JOBS_BASE_MODEL Job 15 |
| Tentukan pemegang Privacy Policy & Play Families Policy | — | compliance | Open | (belum ditentukan) | | wajib sebelum submit Play Store, lihat docs/TEAM.md |

## Setelah base model demo lolos

Baris Fase 2 (coding modul kedua per dev, produksi asset full per modul) ditambahkan di sini saat base model selesai — jangan buat board baru, tambah ke tabel ini.

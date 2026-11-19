# Task Board

Living document — **wajib diupdate**, bukan cuma dibaca. Lihat cara klaim task di [CLAUDE.md](../CLAUDE.md) (LANGKAH 0 — wajib di setiap conversation/sesi baru, sebelum kerja apa pun). Status: `Open` (belum diambil) → `Claimed` (sudah diambil, belum selesai) → `Done`.

Commit klaim pakai format `claim: <nama task> — <nama orang>`, commit selesai pakai `done: <nama task> — <nama orang>`.

Tidak diurutkan per tanggal — diurutkan per modul/area. Tambah baris baru kalau ada task baru yang belum tercatat, jangan hapus baris `Done` (biar ada histori).

| Task | Role | Area | Status | PIC | Tgl klaim | Catatan |
|---|---|---|---|---|---|---|
| AppTheme/AppColors, StarRewardOverlay, SfxService, Docker+CI scaffold | Dev | core / infra | Done | (sesi AI, 2026-11-19) | 2026-11-19 | Lihat docs/LIBRARIES.md, docs/DOCKER.md |
| `ProgressRepository` (ChangeNotifier + shared_preferences) | Dev | core | Done | Bramantyo | 2026-11-19 | lihat docs/JOBS_BASE_MODEL.md Job 1 |
| `ParentalGateDialog` | Dev | core | Done | Bramantyo | 2026-11-19 | tahan tombol 3 detik, `packages/core/lib/src/widgets/parental_gate_dialog.dart` |
| Wiring navigasi Home ↔ Settings ↔ mini-game | Dev | app | Done | Dev App | 2026-11-19 | `packages/app/lib/main.dart` |
| `SettingsScreen` (toggle suara) | Dev | app | Done | Dev App | 2026-11-19 | `packages/app/lib/src/settings_screen.dart` |
| `feature_angka`: UI + logic soal (pilot base model) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | `packages/feature_angka/lib/src/angka_screen.dart` |
| `feature_angka`: wiring ke core (reward/sfx/progress) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | StarRewardOverlay + ProgressRepository + SfxService sudah terpasang |
| Spek + asset list `feature_warna` | Dev | feature_warna | Open | Dev Warna | | |
| Spek + asset list `feature_hewan` | Dev | feature_hewan | Open | Dev 3 | | |
| Spek + asset list `feature_musik` | Dev | feature_musik | Open | Dev Musik | | |
| Spek + asset list `feature_mewarnai` | Dev | feature_mewarnai | Open | Dev 4 | | |
| Spek + asset list `feature_puzzle` | Dev | feature_puzzle | Open | Dev Puzzle | | |
| `docs/QA_CHECKLIST.md` + unit/widget test `core` | Dev | lintas-modul | Open | Dev Testing | | lihat JOBS_BASE_MODEL Job 9 |
| Style guide ilustrasi | Asset | branding | Open | Asset 1 | | acuan semua modul berikutnya |
| Ilustrasi `feature_angka` (buah 1-5) + app icon/splash draft | Asset | feature_angka | Open | Asset 1 | | |
| SFX dasar (tap/benar/coba-lagi) | Asset | core | Open | Asset 2 | | dipakai via SfxService |
| VO angka 1-5 (Bahasa Indonesia) | Asset | feature_angka | Open | Asset 2 | | |
| Riset referensi video + draft konsep promo | Asset | marketing | Open | Asset 3 | | |
| Draft listing Play Store Console (belum publish) | Asset | marketing | Open | Asset 3 | | koordinasi Bramantyo + Dev App untuk APK |
| Assist ilustrasi (tunggu style guide) | Asset | feature_warna | Open | Asset 4 | | lihat JOBS_BASE_MODEL Job 13 |
| Assist audio (tunggu spek feature_musik) | Asset | feature_musik | Open | Asset 5 | | lihat JOBS_BASE_MODEL Job 14 |
| Assist riset referensi + dokumentasi asset pipeline | Asset | marketing | Open | Asset 6 | | lihat JOBS_BASE_MODEL Job 15 |
| Tentukan pemegang Privacy Policy & Play Families Policy | — | compliance | Open | (belum ditentukan) | | wajib sebelum submit Play Store, lihat docs/TEAM.md |

## Setelah base model demo lolos

Baris Fase 2 (coding modul kedua per dev, produksi asset full per modul) ditambahkan di sini saat base model selesai — jangan buat board baru, tambah ke tabel ini.

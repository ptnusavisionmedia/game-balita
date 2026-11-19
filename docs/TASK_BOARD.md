# Task Board

Living document — **wajib diupdate**, bukan cuma dibaca. Lihat cara klaim task di [CLAUDE.md](../CLAUDE.md). Status: `Open` (belum diambil) → `Claimed` (sudah diambil, belum selesai) → `Done`.

Tidak diurutkan per tanggal — diurutkan per modul/area. Tambah baris baru kalau ada task baru yang belum tercatat, jangan hapus baris `Done` (biar ada histori).

| Task | Role | Area | Status | PIC | Tgl klaim | Catatan |
|---|---|---|---|---|---|---|
| AppTheme/AppColors, StarRewardOverlay, SfxService, Docker+CI scaffold | Dev | core / infra | Done | (sesi AI, 2026-11-19) | 2026-11-19 | Lihat docs/LIBRARIES.md, docs/DOCKER.md |
| `ProgressRepository` (ChangeNotifier + shared_preferences) | Dev | core | Open | Bramantyo | | lihat docs/JOBS_BASE_MODEL.md Job 1 |
| `ParentalGateDialog` | Dev | core | Open | Bramantyo | | |
| Wiring navigasi Home ↔ Settings ↔ mini-game | Dev | app | Open | Bramantyo | | |
| `SettingsScreen` (toggle suara) | Dev | app | Open | Bramantyo | | |
| `feature_angka`: UI + logic soal (pilot base model) | Dev | feature_angka | Open | Dev 2 | | |
| `feature_angka`: wiring ke core (reward/sfx/progress) | Dev | feature_angka | Open | Dev 2 | | tunggu ProgressRepository |
| Spek + asset list `feature_warna` | Dev | feature_warna | Open | Dev 2 | | |
| Spek + asset list `feature_hewan` | Dev | feature_hewan | Open | Dev 3 | | |
| Spek + asset list `feature_musik` | Dev | feature_musik | Open | Dev 3 | | |
| Spek + asset list `feature_mewarnai` | Dev | feature_mewarnai | Open | Dev 4 | | |
| Spek + asset list `feature_puzzle` | Dev | feature_puzzle | Open | Dev 4 | | |
| Style guide ilustrasi | Asset | branding | Open | Asset 1 | | acuan semua modul berikutnya |
| Ilustrasi `feature_angka` (buah 1-5) + app icon/splash draft | Asset | feature_angka | Open | Asset 1 | | |
| SFX dasar (tap/benar/coba-lagi) | Asset | core | Open | Asset 2 | | dipakai via SfxService |
| VO angka 1-5 (Bahasa Indonesia) | Asset | feature_angka | Open | Asset 2 | | |
| Riset referensi video + draft konsep promo | Asset | marketing | Open | Asset 3 | | |
| Draft listing Play Store Console (belum publish) | Asset | marketing | Open | Asset 3 | | koordinasi Bramantyo untuk APK |

## Setelah base model demo lolos

Baris Fase 2 (coding modul kedua per dev, produksi asset full per modul) ditambahkan di sini saat base model selesai — jangan buat board baru, tambah ke tabel ini.

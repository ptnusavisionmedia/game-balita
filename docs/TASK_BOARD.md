# Task Board

Living document — **wajib diupdate**, bukan cuma dibaca. Lihat cara klaim task di [CLAUDE.md](../CLAUDE.md) (LANGKAH 0 — wajib di setiap conversation/sesi baru, sebelum kerja apa pun). Status: `Open` (belum diambil) → `Claimed` (sudah diambil, belum selesai) → `Done`.

Commit klaim pakai format `claim: <nama task> — <nama orang>`, commit selesai pakai `done: <nama task> — <nama orang>`.

Tidak diurutkan per tanggal — diurutkan per modul/area. Tambah baris baru kalau ada task baru yang belum tercatat, jangan hapus baris `Done` (biar ada histori).

> **2026-11-19**: tim di-ramping dari 15 orang (9 dev + 6 asset) jadi **8 orang (5 dev + 3 asset)** — lihat Decisions Log. PIC "Dev App"/"Dev Warna"/"Dev Musik"/"Dev Puzzle"/"Asset 4-6" di baris lama digabung ke Bramantyo/Dev 2-4/Asset 1-3.

| Task | Role | Area | Status | PIC | Tgl klaim | Catatan |
|---|---|---|---|---|---|---|
| `AppColors`, `StarRewardOverlay`, `ParentalGateDialog`, `ProgressRepository`, `SfxService`/`AudioService` | Dev | core | Done | Bramantyo | 2026-11-19 | `core/scripts/`, `core/scenes/` |
| Wiring navigasi Home ↔ Settings ↔ mini-game | Dev | scenes | Done | Bramantyo | 2026-11-19 | `scenes/home.gd` |
| `Settings.tscn` (toggle suara) | Dev | scenes | Done | Bramantyo | 2026-11-19 | `scenes/settings.gd` |
| `feature_angka`: UI + logic soal (pilot base model) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | `features/feature_angka/angka.gd` |
| `feature_angka`: wiring ke core (reward/sfx/progress) | Dev | feature_angka | Done | Dev 2 | 2026-11-19 | StarRewardOverlay + ProgressRepository + SfxService sudah terpasang |
| Placeholder scene 5 modul lain (Warna/Hewan/Musik/Mewarnai/Puzzle) | Dev | feature_* | Done | Bramantyo | 2026-11-19 | Cuma tombol "Kembali", isi logic-nya nanti di modul masing-masing |
| Verifikasi: buka project di Godot Editor/headless, cek semua scene lolos | Dev | base model | Done | Bramantyo | 2026-11-19 | Godot 4.7.2 — semua 8 scene exit 0 headless; export APK/interaksi sentuhan asli masih belum |
| CI headless validate (`.github/workflows/ci.yml`) | Dev | infra | Done | Bramantyo | 2026-11-19 | binary `godot` + `--quit-after` terverifikasi |
| Part 1.1-1.3 (export template, export_presets.cfg, CI export job) | Dev | infra | Done | Bramantyo | 2026-11-20 | APK debug export BERHASIL lokal (app-debug.apk, ~27MB, ter-sign). CI job belum pernah dijalankan sungguhan (cuma ditulis ikut pola resmi) |
| Spek + asset list `feature_warna` | Dev | feature_warna | Open | Dev 2 | | |
| Spek + asset list `feature_hewan` | Dev | feature_hewan | Open | Dev 3 | | |
| Spek + asset list `feature_musik` | Dev | feature_musik | Open | Dev 3 | | |
| Spek + asset list `feature_mewarnai` | Dev | feature_mewarnai | Open | Dev 4 | | |
| Spek + asset list `feature_puzzle` | Dev | feature_puzzle | Open | Dev 4 | | |
| `docs/QA_CHECKLIST.md` + pertimbangkan addon GUT | Dev | lintas-modul | Open | Dev Testing | | lihat JOBS_BASE_MODEL Job 5 |
| Test interaktif `feature_angka` di laptop (desktop, bukan device Android) | Dev | feature_angka | Done | (sesi AI + user, 2026-11-19) | 2026-11-19 | 4 soal dijawab benar, reward+confetti muncul, progress.cfg terisi nyata |
| Test interaktif `feature_angka` di device/emulator Android asli | Dev | feature_angka | Open | Dev Testing | | yang di atas baru di desktop Windows, belum di Android |
| Style guide ilustrasi | Asset | branding | Open | Asset 1 | | acuan semua modul berikutnya |
| Ikon vector tile Home (ModuleIcon, placeholder kode) | Dev | scenes | Done | (sesi AI, 2026-11-20) | 2026-11-20 | `core/scripts/module_icon.gd` — generate image AI gagal (butuh plan berbayar), diganti gambar vector |
| Redesign Home (tombol "▶ Play" tengah, mode acak infinite) + `GameFlow` autoload + Splash + fade transisi + debounce + tombol darurat 🏠 | Dev | scenes/core | Done | (sesi AI, 2026-11-20) | 2026-11-20 | `core/scripts/game_flow.gd` (baru), `scenes/home.gd` (rewrite), `scenes/splash.gd`+`Splash.tscn` (baru), semua `feature_*.gd` ganti ke `GameFlow.go_home()`/`finish_game_session()`. Headless-verified semua scene lolos. Menunggu hasil test interaktif user |
| Ilustrasi `feature_angka` (1-5 objek, ganti ikon hati placeholder) + app icon/splash draft | Asset | feature_angka | Open | Asset 1 | | ModuleIcon di Home cuma placeholder, bukan pengganti ilustrasi asli ini |
| SFX dasar (tap/benar/coba-lagi) | Asset | core | Open | Asset 2 | | dipakai via SfxService, format .wav/.ogg |
| VO angka 1-5 (Bahasa Indonesia) | Asset | feature_angka | Open | Asset 2 | | |
| Riset referensi video + draft konsep promo | Asset | marketing | Open | Asset 3 | | |
| Draft listing Play Store Console (belum publish) | Asset | marketing | Open | Asset 3 | | koordinasi Bramantyo untuk export APK |
| Tentukan pemegang Privacy Policy & Play Families Policy | — | compliance | Open | (belum ditentukan) | | wajib sebelum submit Play Store, lihat docs/TEAM.md |

## Setelah base model demo lolos

Baris Fase 2 (coding modul kedua per dev, produksi asset full per modul) ditambahkan di sini saat base model selesai — jangan buat board baru, tambah ke tabel ini.

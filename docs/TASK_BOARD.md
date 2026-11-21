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
| Spek `feature_warna` (tap, cocokkan warna) | Dev | feature_warna | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `obsidian-vault/Specs/feature_warna.md` — implementasi + asset list masih Open |
| `feature_warna`: implementasi UI+logic + asset list (6 warna/benda) | Dev | feature_warna | Open | Dev 2 | | lihat `obsidian-vault/Specs/feature_warna.md` |
| Spek `feature_hewan` (2 mekanik: Mandiri + Bareng Orang Tua) | Dev | feature_hewan | Done | (sesi AI + user, 2026-11-21) | 2026-11-21 | `obsidian-vault/Specs/feature_hewan.md` — asset list masih Open di baris bawah |
| `feature_hewan`: implementasi UI+logic (2 mekanik) + data 6 hewan | Dev | feature_hewan | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `features/feature_hewan/hewan.gd` + `data/hewan_data.json`. Headless-verified 2 mekanik. **Placeholder**: emoji ganti ilustrasi asli, `SfxService.play(null)` ganti SFX asli — lihat baris asset di bawah |
| Asset list `feature_hewan` (6 ilustrasi hewan + 6 SFX suara) | Asset | feature_hewan | Open | Asset 1 + Farel | | lihat tabel Asset di `obsidian-vault/Specs/feature_hewan.md` — ganti placeholder emoji/silent di `hewan_data.json` |
| Spek `feature_musik` (tap bebas, tanpa soal benar/salah) | Dev | feature_musik | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `obsidian-vault/Specs/feature_musik.md` — implementasi + asset list masih Open |
| `feature_musik`: implementasi UI+logic + asset list (4-6 nada) | Dev | feature_musik | Open | Dev 3 | | lihat `obsidian-vault/Specs/feature_musik.md` |
| Spek `feature_mewarnai` (isi area, tanpa soal benar/salah) | Dev | feature_mewarnai | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `obsidian-vault/Specs/feature_mewarnai.md` — implementasi + asset list masih Open |
| `feature_mewarnai`: implementasi UI+logic + asset list (1-2 gambar area) | Dev | feature_mewarnai | Open | Dev 4 | | lihat `obsidian-vault/Specs/feature_mewarnai.md` |
| Spek `feature_puzzle` (drag, snap longgar, 3-4 keping) | Dev | feature_puzzle | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `obsidian-vault/Specs/feature_puzzle.md` — implementasi + asset list masih Open |
| `feature_puzzle`: implementasi UI+logic + asset list (1 gambar 3-4 keping) | Dev | feature_puzzle | Open | Dev 4 | | lihat `obsidian-vault/Specs/feature_puzzle.md` |
| `docs/QA_CHECKLIST.md` + pertimbangkan addon GUT | Dev | lintas-modul | Open | Dev Testing | | lihat JOBS_BASE_MODEL Job 5 |
| Test interaktif `feature_angka` di laptop (desktop, bukan device Android) | Dev | feature_angka | Done | (sesi AI + user, 2026-11-19) | 2026-11-19 | 4 soal dijawab benar, reward+confetti muncul, progress.cfg terisi nyata |
| Test interaktif `feature_angka` di device/emulator Android asli | Dev | feature_angka | Open | Dev Testing | | yang di atas baru di desktop Windows, belum di Android |
| Style guide ilustrasi | Asset | branding | Open | Asset 1 | | acuan semua modul berikutnya |
| Ikon vector tile Home (ModuleIcon, placeholder kode) | Dev | scenes | Done | (sesi AI, 2026-11-20) | 2026-11-20 | `core/scripts/module_icon.gd` — generate image AI gagal (butuh plan berbayar), diganti gambar vector |
| Redesign Home (tombol "▶ Play" tengah, mode acak infinite) + `GameFlow` autoload + Splash + fade transisi + debounce + tombol darurat 🏠 | Dev | scenes/core | Done | (sesi AI, 2026-11-20) | 2026-11-20 | `core/scripts/game_flow.gd` (baru), `scenes/home.gd` (rewrite), `scenes/splash.gd`+`Splash.tscn` (baru), semua `feature_*.gd` ganti ke `GameFlow.go_home()`/`finish_game_session()`. Headless-verified + **test interaktif user: semua 4 poin checklist lolos (2026-11-20)** |
| Ilustrasi `feature_angka` (1-5 objek, ganti ikon hati placeholder) + app icon/splash draft | Asset | feature_angka | Open | Asset 1 | | ModuleIcon di Home cuma placeholder, bukan pengganti ilustrasi asli ini |
| SFX dasar (tap/benar/coba-lagi) | Asset | core | Open | Farel | | dipakai via SfxService, format .wav/.ogg |
| VO angka 1-5 (Bahasa Indonesia) | Asset | feature_angka | Open | Farel | | |
| Riset referensi video + draft konsep promo | Asset | marketing | Open | Asset 3 | | |
| Draft listing Play Store Console (belum publish) | Asset | marketing | Open | Asset 3 | | koordinasi Bramantyo untuk export APK |
| Tentukan pemegang Privacy Policy & Play Families Policy | — | compliance | Done | Bramantyo | 2026-11-20 | Keputusan diambil; dokumen Privacy Policy/Play Families Policy itu sendiri belum ditulis — itu task terpisah |
| Tulis draft Privacy Policy & Play Families Policy | — | compliance | Done | Bramantyo | 2026-11-20 | Draft di `docs/PRIVACY_POLICY.md` — isi kontak & publish ke URL publik masih Open di baris bawah |
| Isi kontak + publish `docs/PRIVACY_POLICY.md` ke URL publik (GitHub Pages/situs tim) | — | compliance | Open | Bramantyo | | wajib sebelum submit Play Store (Play Console minta link publik, bukan file repo) |
| Fitur tumbuh-kembang — Fase A: tulis konten 6 kartu "Panduan Orang Tua" (`core/data/parent_guide.json` atau `.tres`) | Dev | core | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `core/data/parent_guide.json` — konten awal, boleh direvisi Fase D |
| Fitur tumbuh-kembang — Fase B: scene `ParentGuide.tscn`+`parent_guide.gd`, akses dari Settings di belakang `ParentalGateDialog` | Dev | scenes/core | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `scenes/ParentGuide.tscn`+`parent_guide.gd`, tombol baru di `settings.gd`. Tombol "Mulai main bareng" cuma muncul di kartu yang punya `guided_scene` terisi (sekarang cuma `feature_hewan`). Headless-verified |
| `GameFlow`: tambah state `guided_mode` + fungsi `start_guided_game(...)` (dipakai tombol "Mulai main bareng" di `ParentGuide`) | Dev | core | Done | (sesi AI, 2026-11-21) | 2026-11-21 | `core/scripts/game_flow.gd` — belum ada pemanggil-nya (tunggu `ParentGuide.tscn` di Fase B), tapi `feature_hewan.gd` sudah baca flag-nya |
| Fitur tumbuh-kembang — Fase C: audit "bisa dimainkan tanpa baca" per modul (mulai `feature_angka`) | Dev | feature_* | Open | Dev 2-4 + Dev Testing | | checklist di `docs/PLAN_TUMBUH_KEMBANG.md` bagian 2.2, masuk juga ke `docs/QA_CHECKLIST.md` begitu dibuat |
| Fitur tumbuh-kembang — Fase D: review isi 6 kartu panduan oleh tim/manusia yang paham anak usia dini sebelum publish | — | compliance/konten | Open | (belum ditentukan) | | wajib, bukan nasihat medis — lihat `docs/PLAN_TUMBUH_KEMBANG.md` bagian 6 |
| Ilustrasi kartu "Panduan Orang Tua" (opsional, teks dulu boleh) | Asset | branding | Open | Asset 1 | | lihat `docs/PLAN_TUMBUH_KEMBANG.md` bagian 5 |

## Setelah base model demo lolos

Baris Fase 2 (coding modul kedua per dev, produksi asset full per modul) ditambahkan di sini saat base model selesai — jangan buat board baru, tambah ke tabel ini.

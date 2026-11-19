# Peran & Batas File (Roles & Scope)

Dokumen ini jawaban konkret untuk "siapa boleh edit apa". Kalau `docs/TEAM.md` bilang **siapa** pegang **modul mana**, dokumen ini bilang **folder/file persis** mana yang boleh disentuh tiap peran — supaya "jangan acak file lain" bisa dicek, bukan cuma diomongkan.

## Daftar peran & scope file

| Peran | Siapa (lihat TEAM.md) | Boleh edit | **Tidak boleh** edit |
|---|---|---|---|
| Core/App maintainer | Bramantyo | `packages/core/**`, `packages/app/**`, `.github/**`, `Dockerfile`, `docker-compose.yml`, `melos.yaml` | `packages/feature_*/**` (minta Dev modul terkait), `marketing/**` |
| Mini-game Developer A | Dev 2 | `packages/feature_angka/**`, `packages/feature_warna/**` | `packages/core/**`, `packages/app/**`, `packages/feature_hewan|musik|mewarnai|puzzle/**` |
| Mini-game Developer B | Dev 3 | `packages/feature_hewan/**`, `packages/feature_musik/**` | folder modul lain, `core`, `app` |
| Mini-game Developer C | Dev 4 | `packages/feature_mewarnai/**`, `packages/feature_puzzle/**` | folder modul lain, `core`, `app` |
| Ilustrator | Asset 1 | `packages/*/assets/images/**`, `obsidian-vault/Specs/style-guide-ilustrasi.md` | file `.dart` apa pun, `assets/audio/**` |
| Audio/VO | Asset 2 | `packages/*/assets/audio/**` | file `.dart` apa pun, `assets/images/**` |
| Video/Marketing | Asset 3 | `marketing/**` | `packages/**` (semua) |

**Semua peran** boleh edit (karena ini koordinasi bersama, bukan kode produk):
- `docs/TASK_BOARD.md` — khusus baris task sendiri (klaim/update status).
- `obsidian-vault/Specs/<modul-sendiri>.md` — spek modul/area sendiri.
- `obsidian-vault/Decisions Log.md` — **hanya nambah entri baru di akhir**, jangan edit/hapus entri lama.

## Kalau butuh sesuatu di luar scope kamu

Jangan edit langsung. Ada 2 cara yang benar:
1. **Minta ke pemegangnya** (chat/koordinasi), dia yang edit & PR.
2. **Buat Issue di GitHub** describe kebutuhannya, biar masuk antrian task pemegang folder itu.

Ini bukan soal "tidak percaya" — ini supaya 1 orang/1 sesi AI tetap jadi satu-satunya yang paham penuh isi 1 folder, jadi reviewnya cepat dan tidak ada 2 pemahaman berbeda soal file yang sama.

## Kenapa ini aman dari tabrakan — 3 lapis, bukan cuma "saling percaya"

1. **Struktural (duluan)**: scope di atas nyaris tidak overlap sama sekali antar peran — modul berbeda = folder berbeda = file berbeda. Secara teknis susah tabrakan walau tidak ada yang mengatur.
2. **Koordinasi (TASK_BOARD)**: sebelum mulai, klaim task di `docs/TASK_BOARD.md` (lihat `CLAUDE.md` LANGKAH 0). Ini mencegah 2 orang/2 sesi AI kerja **task yang sama** di modul yang sama secara bersamaan.
3. **Teknis/dipaksa GitHub (terakhir, bukan cuma janji)**:
   - `.github/CODEOWNERS` sudah memetakan tiap folder ke pemiliknya.
   - **Setelah ini diaktifkan oleh admin repo** (langkah manual, sekali saja — lihat di bawah), GitHub akan **menolak merge** PR yang menyentuh folder orang lain sampai pemilik folder itu kasih approve. Jadi walau ada yang kelepasan edit folder orang lain, kodenya **tidak bisa masuk ke `main`** tanpa izin pemiliknya.
   - CI (`scope-check`, lihat `.github/workflows/ci.yml`) otomatis **gagal** kalau 1 PR menyentuh lebih dari 1 folder `packages/<modul>` sekaligus — mendeteksi "mengacak-acak file lain" secara otomatis, sebelum manusia sempat review.

### Setup sekali oleh admin repo (supaya lapis 3 aktif)

Di GitHub: **Settings → Branches → Add branch protection rule** untuk `main`:
- ✅ Require a pull request before merging
- ✅ Require review from Code Owners
- ✅ Require status checks to pass before merging → pilih job `analyze-test` dan `scope-check`

Tanpa langkah ini, CODEOWNERS cuma jadi "auto-assign reviewer" (masih bagus, tapi bisa di-skip). Dengan langkah ini, aturan "jangan acak file orang lain" **ditegakkan GitHub sendiri**, bukan cuma aturan tertulis.

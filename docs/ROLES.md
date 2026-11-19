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

Normalnya: **minta ke pemegangnya** (chat/koordinasi) atau **buat Issue di GitHub**, biar masuk antrian task pemegang folder itu, bukan diedit langsung.

**Kecuali untuk bug fix kecil yang urgent** — boleh langsung edit folder orang lain kalau perlu (jangan sampai aturan ini menghalangi fix bug cepat). Syaratnya cuma:
1. PR terpisah (jangan digabung dengan kerjaan modul sendiri).
2. Tag/mention pemilik folder itu di PR-nya (lihat `docs/TEAM.md`) biar dia tahu & sempat cek, meskipun approval-nya bukan syarat wajib untuk merge.
3. Tulis di deskripsi PR kenapa fix-nya mendesak / tidak sempat nunggu pemiliknya.

Ini bukan soal "tidak percaya" — defaultnya tetap 1 orang/1 sesi AI yang paham penuh isi 1 folder, cuma tidak dibuat kaku sampai bug sepele jadi lambat ditangani.

## Kenapa ini aman dari tabrakan — 2 lapis

1. **Struktural**: scope di atas nyaris tidak overlap sama sekali antar peran — modul berbeda = folder berbeda = file berbeda. Secara teknis susah tabrakan walau tidak ada yang memaksa.
2. **Koordinasi (TASK_BOARD)**: sebelum mulai, klaim task di `docs/TASK_BOARD.md` (lihat `CLAUDE.md` LANGKAH 0). Ini mencegah 2 orang/2 sesi AI kerja **task yang sama** di modul yang sama secara bersamaan.

`.github/CODEOWNERS` tetap ada, tapi fungsinya cuma **auto-assign reviewer** (biar PR ke folder tertentu otomatis minta review ke pemiliknya) — bukan gate yang bisa blok merge. Sengaja tidak dipasang branch protection/CI yang memaksa, supaya bug fix atau perubahan mendesak tidak terhambat proses.

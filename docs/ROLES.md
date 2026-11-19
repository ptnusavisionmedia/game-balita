# Peran & Batas File (Roles & Scope)

Dokumen ini jawaban konkret untuk "siapa boleh edit apa". Kalau `docs/TEAM.md` bilang **siapa** pegang **modul mana**, dokumen ini bilang **folder/file persis** mana yang boleh disentuh tiap peran — supaya "jangan acak file lain" bisa dicek, bukan cuma diomongkan.

## Daftar peran & scope file

| Peran | Siapa (lihat TEAM.md) | Boleh edit | **Tidak boleh** edit |
|---|---|---|---|
| Core + App maintainer | Bramantyo | `core/**`, `scenes/**`, `.github/**`, `project.godot` | `features/feature_*/**`, `marketing/**` |
| Mini-game Developer | Dev 2 | `features/feature_angka/**`, `features/feature_warna/**` | folder modul lain, `core`, `scenes` |
| Mini-game Developer | Dev 3 | `features/feature_hewan/**`, `features/feature_musik/**` | folder modul lain, `core`, `scenes` |
| Mini-game Developer | Dev 4 | `features/feature_mewarnai/**`, `features/feature_puzzle/**` | folder modul lain, `core`, `scenes` |
| Testing/Bugfix (lintas-modul) | Dev Testing | `features/*/tests/**` (kalau ada, lihat docs/LIBRARIES.md soal GUT) + boleh fix bug di `core/**`/`features/**`/`scenes/**` manapun kalau ada laporan — **wajib** PR terpisah + tag pemilik modul (lihat aturan "bug fix urgent" di bawah) | menambah fitur baru (bukan scope-nya — itu punya pemilik modul masing-masing) |
| Asset/Design | Asset 1-3 | `features/*/assets/images/**`, `features/*/assets/audio/**`, `marketing/**` (fleksibel, bisa saling bantu — lihat TEAM.md) | file `.gd`/`.tscn` apa pun |

**Semua peran** boleh edit (karena ini koordinasi bersama, bukan kode produk):
- `docs/TASK_BOARD.md` — khusus baris task sendiri (klaim/update status).
- `obsidian-vault/Specs/<modul-sendiri>.md` — spek modul/area sendiri.
- `obsidian-vault/Decisions Log.md` — **hanya nambah entri baru di akhir**, jangan edit/hapus entri lama.

## Kalau butuh sesuatu di luar scope kamu

Normalnya: **minta ke pemegangnya** (chat/koordinasi) atau **buat Issue di GitHub**, biar masuk antrian task pemegang folder itu, bukan diedit langsung.

**Kecuali untuk bug fix kecil yang urgent** (ini scope resmi Dev Testing, tapi siapa pun boleh kalau mendesak) — boleh langsung edit folder orang lain. Syaratnya cuma:
1. PR terpisah (jangan digabung dengan kerjaan modul sendiri).
2. Tag/mention pemilik folder itu di PR-nya (lihat `docs/TEAM.md`) biar dia tahu & sempat cek, meskipun approval-nya bukan syarat wajib untuk merge.
3. Tulis di deskripsi PR kenapa fix-nya mendesak / tidak sempat nunggu pemiliknya.

Ini bukan soal "tidak percaya" — defaultnya tetap 1 orang/1 sesi AI yang paham penuh isi 1 folder, cuma tidak dibuat kaku sampai bug sepele jadi lambat ditangani.

## Kenapa ini aman dari tabrakan — 2 lapis

1. **Struktural**: scope di atas nyaris tidak overlap sama sekali antar peran — modul berbeda = folder berbeda = file berbeda. Dev 2-4 masing-masing pegang 2 modul (bukan 1), tapi 2 modul itu tetap eksklusif milik dia — tidak ada yang pegang modul yang sama. Dev Testing adalah satu-satunya yang scope-nya lintas-modul, dan itu disengaja (perannya memang testing & bugfix, bukan menambah fitur).
2. **Koordinasi (TASK_BOARD)**: sebelum mulai, klaim task di `docs/TASK_BOARD.md` (lihat `CLAUDE.md` LANGKAH 0). Ini mencegah 2 orang/2 sesi AI kerja **task yang sama** di modul yang sama secara bersamaan.

`.github/CODEOWNERS` tetap ada, tapi fungsinya cuma **auto-assign reviewer** (biar PR ke folder tertentu otomatis minta review ke pemiliknya) — bukan gate yang bisa blok merge. Sengaja tidak dipasang branch protection/CI yang memaksa, supaya bug fix atau perubahan mendesak tidak terhambat proses.

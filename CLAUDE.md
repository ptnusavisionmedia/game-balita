# Wawa — Panduan untuk AI/siapa pun yang baru mulai sesi di repo ini

> **Nama app resmi: "Wawa"** (diputuskan 2026-11-22, ganti dari working title "Bayi GuguGaga" — lihat `obsidian-vault/Decisions Log.md`). Nama folder/repo (`bayi-gugugaga/`) sengaja TIDAK diganti, cuma nama tampilan app-nya.

App game edukatif Android untuk anak 1-5 tahun. Dibangun di **Godot 4 (GDScript)**, struktur feature-first (lihat `obsidian-vault/Decisions Log.md` untuk histori pergantian stack dari Flutter). 8 orang: 5 developer (termasuk 1 dev testing lintas-modul) + 3 asset/design creator (ilustrasi/audio/video, fleksibel — tidak coding).

> **Kamu manusia yang baru mau mulai sesi?** Tempel [docs/MASTER_PROMPT.md](docs/MASTER_PROMPT.md) (isi dulu sesuai dirimu) sebagai pesan pertama — itu kasih tahu Claude siapa kamu & scope kamu, dokumen ini (`CLAUDE.md`) baru kasih tahu Claude aturan umumnya.

## LANGKAH 0 — WAJIB di setiap conversation/sesi BARU, sebelum apa pun lain

Ini bukan saran, ini urutan tetap. Setiap kali sesi AI baru dibuka di repo ini (conversation baru, context baru), sebelum baca kode atau mulai kerja apa pun:

1. Buka **[docs/TASK_BOARD.md](docs/TASK_BOARD.md)**. Lihat task mana yang `Open`, `Claimed`, `Done`.
2. Kalau user (orang yang chat sekarang) **sudah bilang** task/modul mana yang mau dikerjakan → cocokkan ke baris yang sesuai di board.
   Kalau **belum bilang** → **tanya ke user dulu** task mana yang dimaksud (lihat `docs/TEAM.md` untuk tahu role/modul siapa). Jangan menebak atau asal pilih task orang lain.
3. Begitu task sudah jelas: edit baris itu di `docs/TASK_BOARD.md` — ubah status jadi `Claimed`, isi kolom **PIC dengan nama orang yang chat** (bukan "Dev 1"/"Asset 2" generik lagi kalau namanya sudah diketahui dari `docs/TEAM.md`) dan kolom tanggal.
4. **Commit perubahan INI SENDIRIAN dulu**, commit message wajib pakai format:
   ```
   claim: <nama task> — <nama orang>
   ```
   contoh: `claim: ProgressRepository — Bramantyo`
5. **Push commit klaim ini ke `main` duluan**, SEBELUM mulai coding/kerja task-nya — supaya sesi/orang lain yang buka repo setelahnya langsung lihat task itu sudah diambil, dan tidak kerja dobel.
6. Baru setelah itu lanjut baca dokumen pendukung & mulai kerja (lihat daftar di bawah).
7. Setelah task selesai & PR di-merge: balik ke `TASK_BOARD.md`, ubah jadi `Done`, commit lagi dengan format `done: <nama task> — <nama orang>`, push.

Kalau ragu task mana yang dimaksud, atau user cuma bilang "lanjut kerja" tanpa nama task spesifik: **tanya**, jangan asumsi.

## Baca selanjutnya, sesuai kebutuhan task yang diklaim

1. **[docs/TEAM.md](docs/TEAM.md)** — siapa pegang modul/role apa. **[docs/ROLES.md](docs/ROLES.md)** — folder/file persis apa yang boleh/tidak boleh kamu sentuh.
2. **[obsidian-vault/Decisions Log.md](obsidian-vault/Decisions%20Log.md)** — keputusan yang sudah diambil & alasannya. Jangan buka ulang diskusi yang sudah diputuskan tanpa alasan baru.
3. **[docs/GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md)** — cara branch/commit/PR. Wajib, semua role.
4. Kalau role developer: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** (aturan dependensi antar modul).
5. Dokumen pendukung lain: [docs/LIBRARIES.md](docs/LIBRARIES.md), [docs/UI_UX_DESIGN.md](docs/UI_UX_DESIGN.md), [docs/DOCKER.md](docs/DOCKER.md), [docs/PLAN_BASE_MODEL.md](docs/PLAN_BASE_MODEL.md), [docs/JOBS_BASE_MODEL.md](docs/JOBS_BASE_MODEL.md), [docs/WORK_BREAKDOWN.md](docs/WORK_BREAKDOWN.md) (langkah detail per bagian job).

## Aturan keras

- **Jangan edit file di luar scope task yang kamu klaim**, kecuali bug fix kecil yang urgent. Scope persis per peran (folder mana boleh, mana tidak) ada di **[docs/ROLES.md](docs/ROLES.md)** — baca itu kalau ragu. Dijaga 2 lapis: struktur folder (hampir tidak overlap) + klaim di TASK_BOARD sebelum kerja. Sengaja **tidak** dipasang gate otomatis (CI/branch protection yang blok merge) supaya fix mendesak tidak terhambat.
- **Developer**: jangan edit folder modul yang bukan milikmu (lihat `docs/TEAM.md` + `docs/ROLES.md`) kecuali bug fix urgent (PR terpisah + tag pemiliknya), jangan push langsung ke `main` (selalu lewat PR, lihat `docs/GIT_WORKFLOW.md`) — **kecuali** commit yang HANYA mengubah baris status di `docs/TASK_BOARD.md` (klaim/done), itu boleh push langsung ke `main` supaya klaim cepat terlihat orang lain.
- **Asset creator**: taruh aset di `features/feature_xxx/assets/images/` atau `assets/audio/` modul yang sesuai (lihat spek di `obsidian-vault/Specs/<modul>.md`), atau di `marketing/` untuk konten promosi — bukan di lokasi lain.
- Butuh sesuatu di luar scope kamu (bukan bug fix urgent)? Jangan edit langsung — minta ke pemegangnya atau buat Issue (lihat `docs/ROLES.md`).
- Dependency/library baru → catat alasannya di `docs/LIBRARIES.md` (jangan tambah tanpa catatan, lihat prinsip "jangan tulis kode sendiri kalau ada library lebih optimal" di sana).
- Keputusan besar/berubah arah → tambah entri **baru** di `obsidian-vault/Decisions Log.md` (jangan edit/hapus entri lama).
- Fase sekarang: **Base Model** (lihat `docs/PLAN_BASE_MODEL.md`) — jangan mulai coding 6 modul paralel sebelum base model (`feature_angka`) lolos demo.

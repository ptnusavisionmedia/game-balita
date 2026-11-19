# Bayi GuguGaga — Panduan untuk AI/siapa pun yang baru mulai sesi di repo ini

App game edukatif Android (+iOS/web) untuk anak 1-5 tahun. Monorepo Flutter (Melos), 7 orang: 4 developer + 3 asset creator (ilustrasi/audio/video — tidak coding).

## Baca dulu, urutan ini, sebelum menyentuh apa pun

1. **[docs/TEAM.md](docs/TEAM.md)** — siapa pegang modul/role apa. Cek posisi kamu di sini.
2. **[docs/TASK_BOARD.md](docs/TASK_BOARD.md)** — task mana `Open`/`Claimed`/`Done`. **Klaim task di sini SEBELUM mulai kerja** (caranya di bawah).
3. **[obsidian-vault/Decisions Log.md](obsidian-vault/Decisions%20Log.md)** — keputusan yang sudah diambil & alasannya. Jangan buka ulang diskusi yang sudah diputuskan tanpa alasan baru.
4. **[docs/GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md)** — cara branch/commit/PR. Wajib, semua role.
5. Kalau role developer: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** (aturan dependensi antar modul).
6. Dokumen pendukung sesuai kebutuhan task yang diklaim: [docs/LIBRARIES.md](docs/LIBRARIES.md), [docs/UI_UX_DESIGN.md](docs/UI_UX_DESIGN.md), [docs/DOCKER.md](docs/DOCKER.md), [docs/PLAN_BASE_MODEL.md](docs/PLAN_BASE_MODEL.md), [docs/JOBS_BASE_MODEL.md](docs/JOBS_BASE_MODEL.md).

## Cara klaim task (WAJIB — supaya tidak ada 2 orang/2 sesi AI kerja hal yang sama)

1. Buka `docs/TASK_BOARD.md`.
2. Cari baris berstatus `Open` yang cocok role/modul kamu.
3. Ubah jadi `Claimed`, isi kolom PIC & tanggal.
4. **Commit & push perubahan INI SENDIRIAN dulu** (`git commit -m "claim: <nama task>"`) sebelum mulai kerja task-nya — sinyal ke orang/sesi lain bahwa task itu sudah diambil.
5. Setelah selesai & PR di-merge: balik ke `TASK_BOARD.md`, ubah jadi `Done`, commit lagi.

Kalau kamu sesi AI yang baru masuk **tanpa instruksi spesifik dari user** tentang task mana yang dikerjakan: tanya ke user dulu task mana yang dimaksud, jangan asal klaim task orang lain di board.

## Aturan keras

- **Developer**: jangan edit folder modul yang bukan milikmu (lihat `docs/TEAM.md`), jangan push langsung ke `main` (selalu lewat PR, lihat `docs/GIT_WORKFLOW.md`).
- **Asset creator**: taruh aset di `packages/feature_xxx/assets/images/` atau `assets/audio/` modul yang sesuai (lihat spek di `obsidian-vault/Specs/<modul>.md`), atau di `marketing/` untuk konten promosi — bukan di lokasi lain.
- Dependency/library baru → catat alasannya di `docs/LIBRARIES.md` (jangan tambah tanpa catatan, lihat prinsip "jangan tulis kode sendiri kalau ada library lebih optimal" di sana).
- Keputusan besar/berubah arah → tambah entri **baru** di `obsidian-vault/Decisions Log.md` (jangan edit/hapus entri lama).
- Fase sekarang: **Base Model** (lihat `docs/PLAN_BASE_MODEL.md`) — jangan mulai coding 6 modul paralel sebelum base model (`feature_angka`) lolos demo.

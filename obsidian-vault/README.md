# Obsidian Vault — Bayi GuguGaga

Ini bukan dokumentasi teknis (itu ada di [[../docs/ARCHITECTURE|docs/ARCHITECTURE.md]] dkk). Folder ini khusus untuk **context yang mudah hilang kalau cuma disimpan di kepala/chat**: keputusan, alasan di baliknya, dan progres per orang — supaya siapa pun (termasuk sesi Claude baru) bisa cepat "nyambung" tanpa baca ulang seluruh percakapan lama.

## Cara pakai

1. Buka Obsidian → **Open folder as vault** → pilih folder **root repo** (`bayi-gugugaga/`), bukan folder `obsidian-vault/` ini sendiri — supaya link ke `docs/...` di bawah bisa dibuka langsung dari Obsidian.
2. Isi update kerja terkini di sini, bukan cuma di chat — kalau cuma di chat, hilang begitu sesi/tab ditutup.
3. Setiap kali ada keputusan penting (ganti stack, ganti pendekatan, dsb), tambahkan entri baru di `Decisions Log.md` — jangan edit/hapus entri lama, cukup tambah entri baru kalau keputusan berubah.
4. Semua file di sini di-commit & push ke git seperti kode — jadi history-nya juga tersimpan di GitHub.

## Isi vault

- [[Decisions Log]] — log keputusan, urut tanggal, append-only.
- [[Project Overview]] — ringkasan 1 halaman: apa produknya, siapa target, status sekarang.
- [[Specs/]] — spek 1 halaman per mini-game (diisi tiap dev modul, lihat `docs/JOBS_BASE_MODEL.md`).

Dokumen rencana & pembagian kerja tetap di `docs/` (bagian dari source code, direview lewat PR):
- `docs/PLAN_BASE_MODEL.md`
- `docs/JOBS_BASE_MODEL.md`
- `docs/ARCHITECTURE.md`
- `docs/TEAM.md`
- `docs/AI_WORKFLOW.md`

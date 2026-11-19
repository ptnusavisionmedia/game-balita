# Contributing

## Setup

1. Install [Godot 4](https://godotengine.org/download) (minimal versi 4.3, stable).
2. Buka folder repo ini lewat **Project > Import** di Godot Editor, pilih `project.godot`.

Tidak ada langkah "install dependency" terpisah — Godot tidak punya package manager seperti pub/npm untuk kebutuhan dasar (lihat [docs/LIBRARIES.md](docs/LIBRARIES.md)).

## Branch

`feature/<modul>-<deskripsi-singkat>` — contoh: `feature/warna-shape-matching`, `feature/core-audio-service`.

## Commit

Pakai gaya singkat: `<modul>: <apa yang berubah>`
Contoh: `angka: tambah animasi bintang saat jawaban benar`

## Pull Request

- 1 PR = 1 modul (`features/<nama>`, atau `core`/`scenes`). Jangan campur perubahan `core` dengan `feature_*` dalam satu PR.
- Pastikan sebelum minta review:
  - Buka project di Godot Editor, cek tidak ada error merah di panel Output/Debugger.
  - Kalau ada automated test (addon GUT, lihat `docs/LIBRARIES.md`), jalankan dan pastikan lolos.
- Isi PR template (lihat `.github/PULL_REQUEST_TEMPLATE.md`).
- Minta review ke pemegang modul terkait, atau Bramantyo (`core`) / Dev App (`scenes`) kalau PR menyentuh situ.

## Aturan arsitektur (wajib dipatuhi reviewer)

- `features/feature_*` tidak boleh saling reference scene/script `feature_*` lain.
- Semua yang dibagi ke >1 modul harus lewat `core/`, bukan copy-paste.
- Area sentuh interaktif minimal ~64dp (target pengguna anak 1-5 tahun) — pakai `BigRoundButton` dari `core/scenes/`, jangan buat tombol custom kecil.

Detail lengkap: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), [docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md).

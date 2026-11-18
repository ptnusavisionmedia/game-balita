# Contributing

## Setup

```bash
dart pub global activate melos
melos bootstrap
```

## Branch

`feature/<modul>-<deskripsi-singkat>` — contoh: `feature/warna-shape-matching`, `feature/core-audio-service`.

## Commit

Pakai gaya singkat: `<modul>: <apa yang berubah>`
Contoh: `angka: tambah animasi bintang saat jawaban benar`

## Pull Request

- 1 PR = 1 modul (`packages/<nama>`). Jangan campur perubahan `core` dengan `feature_*` dalam satu PR.
- Pastikan lolos sebelum minta review:
  ```bash
  melos run analyze
  melos run test
  ```
- Isi PR template (lihat `.github/PULL_REQUEST_TEMPLATE.md`).
- Minta review ke pemegang modul terkait, atau pemegang `core`/`app` kalau PR menyentuh `core`.

## Aturan arsitektur (wajib dipatuhi reviewer)

- `feature_*` tidak boleh import package `feature_*` lain.
- Semua yang dibagi ke >1 modul harus lewat `core`, bukan copy-paste.
- Area sentuh interaktif minimal ~64dp (target pengguna anak 1-5 tahun).

Detail lengkap: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), [docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md).

# Marketing & Store Assets

Dikelola Asset 3 (lihat [docs/TEAM.md](../docs/TEAM.md), [docs/JOBS_BASE_MODEL.md](../docs/JOBS_BASE_MODEL.md) Job 12). Isi folder ini **bukan** aset yang dipakai app (itu di `features/feature_xxx/assets/`), tapi untuk promosi & listing Play Store.

```
marketing/
├── references/    # referensi video/app kompetitor (link atau screenshot, bukan video orang lain full)
├── videos/        # video promo/trailer FINAL (sudah di-compress), bukan file mentah/raw
├── screenshots/   # screenshot untuk Play Store listing
└── play-store/    # draft teks listing (judul, deskripsi), ikon store
```

## Penting: jangan taruh file mentah/besar di sini

Git (dan GitHub) tidak cocok untuk file video mentah (bisa berGB). Taruh di sini **hanya hasil final yang sudah di-compress** (misal <20MB per video). File mentah/raw footage simpan di Google Drive/penyimpanan lain, dan taruh link-nya di `obsidian-vault/Specs/` atau catatan terkait — bukan di-commit ke git.

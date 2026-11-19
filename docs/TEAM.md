# Pembagian tim (7 orang — 4 developer + 3 asset creator)

Prinsip: developer kerja per modul (bisa pegang >1 modul kalau jumlah dev lebih sedikit dari jumlah modul), asset creator kerja per **jenis konten** lintas modul (ilustrasi, audio, video/marketing) — bukan dipaksa coding. Lihat [[../obsidian-vault/Decisions Log|alasan restructure ini]].

## Developer (4 orang)

| # | Nama (isi) | Modul (`packages/...`) | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 1 | Bramantyo | `core` + `app` | Design system, state/persistence bersama, navigasi utama, parental gate, CI/Docker, integrasi semua fitur, review PR yang menyentuh `core` | `@bramantyo` |
| 2 | Dev 2 | `feature_angka` + `feature_warna` | `feature_angka` jadi **pilot base model** (dikerjakan dulu, lihat docs/JOBS_BASE_MODEL.md), `feature_warna` nyusul setelah base model lolos | `@dev-angka-warna` |
| 3 | Dev 3 | `feature_hewan` + `feature_musik` | 2 modul, coding paralel setelah base model lolos | `@dev-hewan-musik` |
| 4 | Dev 4 | `feature_mewarnai` + `feature_puzzle` | 2 modul, coding paralel setelah base model lolos | `@dev-mewarnai-puzzle` |

## Asset Creator (3 orang) — TIDAK coding

| # | Nama (isi) | Fokus | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 5 | Asset 1 — Ilustrator | Gambar/ikon untuk semua 6 modul + app icon + splash | Bikin style guide ilustrasi dulu (1x, jadi acuan semua modul), lalu produksi ilustrasi per modul sesuai spek di `obsidian-vault/Specs/<modul>.md`, taruh file di `packages/feature_xxx/assets/images/` | `@asset-ilustrasi` |
| 6 | Asset 2 — Audio/VO | SFX, voice-over, musik latar untuk semua 6 modul | Rekam/cari SFX (tap/benar/coba-lagi) & VO (angka, nama warna/hewan, dst) sesuai spek modul, taruh file di `packages/feature_xxx/assets/audio/` | `@asset-audio` |
| 7 | Asset 3 — Video/Marketing | Video promo, konten Play Store, upload listing | Video trailer/demo, screenshot & video untuk Play Store listing, koordinasi dengan Bramantyo soal APK untuk recording, upload ke `marketing/` | `@asset-video` |

> Isi "Nama (isi)" dengan nama asli dan `@...` dengan username GitHub asli, lalu pastikan `.github/CODEOWNERS` tetap sinkron.

## Kenapa restructure dari "7 developer" ke "4 dev + 3 asset creator"

Kualitas app anak sangat bergantung ilustrasi/audio/video yang menarik — bukan skill yang otomatis dimiliki developer, dan memaksa semua orang coding 1 modul penuh tidak efisien kalau sebenarnya kekuatan tim lebih ke konten. 3 modul yang tersisa (6 modul, 3 dev selain Bramantyo) dibagi 2 modul/orang — tetap realistis karena base model (lihat docs/PLAN_BASE_MODEL.md) membuktikan pola dulu sebelum modul lain digarap, dan asset creator sudah menyiapkan materi dari awal supaya begitu dev mulai coding modul ke-2/ke-3, aset sudah siap (tidak nunggu).

## Role lintas-modul yang tetap perlu disepakati (bisa dirangkap)

- **QA lintas modul** sebelum rilis: bisa bergilir, atau Asset 3 (yang paling dekat ke "produk jadi" lewat perekaman video).
- **Release manager** (build & sign APK): Bramantyo.
- **Publish ke Play Store Console**: Asset 3, tapi APK final dari Bramantyo — jadi wajib koordinasi, bukan kerja sendiri-sendiri.

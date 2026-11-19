# Pembagian tim (15 orang — 9 developer, 6 asset/design creator)

Prinsip diminta user: **5 developer baru + 3 asset/design creator baru**, ditambah ke 7 orang yang sudah ada (3 dev + 1 core/app + 3 asset) = **15 orang**. Developer fokus coding (fitur maupun platform/app), asset/design creator fokus konten (gambar/video/sound, fleksibel bukan super-spesialis 1 jenis media saja). Lihat [[../obsidian-vault/Decisions Log|alasan & histori perubahan]].

## Developer (9 orang) — semua coding

| # | Nama (isi) | Modul/area | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 1 | Bramantyo | `packages/core/**` | Design system, state/persistence bersama (`ProgressRepository` — sudah selesai), parental gate | `@bramantyo` |
| 2 | **Dev App (baru)** | `packages/app/**` | Navigasi, Home menu, Settings screen, wiring parental gate — dipisah dari Bramantyo supaya `core`+`app` tidak numpuk di 1 orang | `@dev-app` |
| 3 | Dev 2 | `feature_angka` | **Pilot base model** — fokus 1 modul saja (`feature_warna` dilepas ke Dev baru) | `@dev-angka` |
| 4 | **Dev Warna (baru)** | `feature_warna` | 1 modul, coding paralel setelah base model lolos | `@dev-warna` |
| 5 | Dev 3 | `feature_hewan` | 1 modul (`feature_musik` dilepas ke Dev baru) | `@dev-hewan` |
| 6 | **Dev Musik (baru)** | `feature_musik` | 1 modul, coding paralel setelah base model lolos | `@dev-musik` |
| 7 | Dev 4 | `feature_mewarnai` | 1 modul (`feature_puzzle` dilepas ke Dev baru) | `@dev-mewarnai` |
| 8 | **Dev Puzzle (baru)** | `feature_puzzle` | 1 modul, coding paralel setelah base model lolos | `@dev-puzzle` |
| 9 | **Dev Testing (baru)** | lintas-modul (test + bugfix) | Nulis unit/widget test untuk semua modul, fix bug yang dilaporkan — **bukan** peran non-coding, tetap nulis kode (test & fix), bukan cuma melaporkan | `@dev-testing` |

Hasil: 6 modul `feature_*` sekarang **1 modul = 1 developer** (sebelumnya 2 modul/orang), `core` dan `app` dipisah jadi 2 orang, dan ada 1 dev khusus testing/bugfix lintas-modul.

## Asset/Design Creator (6 orang) — TIDAK coding, fleksibel lintas media

| # | Nama (isi) | Fokus utama | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 10 | Asset 1 | Ilustrasi (lead) | Style guide ilustrasi + produksi gambar `feature_angka` duluan | `@asset-1` |
| 11 | Asset 2 | Audio/VO (lead) | SFX + VO semua modul, mulai `feature_angka` | `@asset-2` |
| 12 | Asset 3 | Video/Marketing (lead) | Video promo, Play Store listing, upload | `@asset-3` |
| 13 | **Asset 4 (baru)** | Fleksibel (gambar/video/sound) | Assist produksi sesuai kebutuhan — prioritas bantu Asset 1 untuk ilustrasi modul kedua (`feature_warna`, dst) begitu spek siap | `@asset-4` |
| 14 | **Asset 5 (baru)** | Fleksibel (gambar/video/sound) | Assist produksi sesuai kebutuhan — prioritas bantu Asset 2 untuk audio modul kedua | `@asset-5` |
| 15 | **Asset 6 (baru)** | Fleksibel (gambar/video/sound) | Assist produksi sesuai kebutuhan — prioritas bantu Asset 3 untuk video/marketing & dokumentasi asset pipeline | `@asset-6` |

Asset 4-6 **tidak dibatasi 1 jenis media** seperti Asset 1-3 — tugas awalnya ditentukan di atas (assist siapa duluan), tapi bisa pindah fokus sesuai kebutuhan paling mendesak (misal Asset 4 bantu video kalau Asset 3 lagi kebanjiran kerjaan).

## Kenapa 8 orang baru ini (5 dev + 3 asset/design)

- **5 dev baru** → 6 modul `feature_*` jadi 1:1 per orang (lebih cepat & fokus dibanding 2 modul/orang), `app` dipisah dari `core` (Bramantyo tidak numpuk), dan 1 dev khusus testing/bugfix supaya kualitas tidak cuma diperiksa pas sempat.
- **3 asset/design baru** → 3 orang lama (ilustrasi/audio/video) gampang jadi bottleneck begitu 6 modul dibuka paralel di Fase 2. Ditambah sebagai generalist fleksibel (bukan spesialis super-sempit) supaya bisa dialihkan ke mana yang paling butuh.

## Role lintas-modul yang masih perlu disepakati (dirangkap, belum ada headcount khusus)

Tim ini sengaja dibuat lean (coding + asset saja, tanpa role non-coding terpisah seperti QA Tester/UI-UX Designer/DevOps/Compliance Officer). Beberapa hal berikut tetap perlu ada yang pegang, dirangkap oleh orang di atas:
- **Testing manual di device nyata**: Dev Testing + giliran siapa saja sebelum rilis.
- **CI/Docker maintenance**: tetap Bramantyo untuk sekarang (lihat `docs/DOCKER.md`), bisa dialihkan nanti kalau terasa berat.
- **Privacy Policy & Google Play Families Policy** (wajib sebelum publish ke Play Store, app anak punya aturan ekstra): belum ada pemegang jelas — **harus diputuskan sebelum submit ke Play Store**, lihat `docs/JOBS_BASE_MODEL.md`.
- **Release manager** (build & sign APK, publish listing): Bramantyo + Asset 3, koordinasi bareng.

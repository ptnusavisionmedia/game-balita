# Pembagian tim (8 orang — 5 developer, 3 asset/design creator)

Tim di-ramping ulang dari 15 orang jadi **8 orang: 5 developer (coding) + 3 asset/design creator**. Developer fokus coding (fitur maupun platform/infra), asset/design creator fokus konten (gambar/video/sound, fleksibel). Lihat [[../obsidian-vault/Decisions Log|alasan & histori perubahan]].

## Developer (5 orang) — semua coding

| # | Nama (isi) | Modul/area | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 1 | Bramantyo | `core/**` + `scenes/**` | Design system, state/persistence bersama (`ProgressRepository`), navigasi Home/Settings, parental gate — infra & platform digabung 1 orang (tim sudah ramping, tidak perlu dipisah Dev App terpisah) | `@bramantyo` |
| 2 | Dev 2 | `features/feature_angka/**` + `features/feature_warna/**` | `feature_angka` = **pilot base model** (fokus duluan), `feature_warna` nyusul setelah base model lolos | `@dev-angka-warna` |
| 3 | Dev 3 | `features/feature_hewan/**` + `features/feature_musik/**` | 2 modul, coding paralel setelah base model lolos | `@dev-hewan-musik` |
| 4 | Dev 4 | `features/feature_mewarnai/**` + `features/feature_puzzle/**` | 2 modul, coding paralel setelah base model lolos | `@dev-mewarnai-puzzle` |
| 5 | Dev Testing | lintas-modul (test + bugfix) | Checklist QA, test tiap modul begitu demo-able, fix bug yang dilaporkan — **tetap coding** (test & fix langsung), bukan peran non-coding yang cuma melaporkan | `@dev-testing` |

6 modul `feature_*` dibagi 2 modul/orang (Dev 2-4), ditambah Bramantyo pegang `core`+`scenes`, dan 1 dev khusus testing/bugfix lintas-modul.

## Asset/Design Creator (3 orang) — TIDAK coding, fleksibel lintas media

| # | Nama (isi) | Fokus | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 6 | Asset 1 | Ilustrasi | Style guide ilustrasi + produksi gambar `feature_angka` duluan, lanjut modul lain begitu spek siap | `@asset-1` |
| 7 | Farel | Audio/VO | SFX + VO semua modul, mulai `feature_angka` | `@asset-2` |
| 8 | Asset 3 | Video/Marketing | Video promo, Play Store listing, upload | `@asset-3` |

Tidak ada lagi Asset 4-6 generalist tambahan (dihapus saat ramping dari 15 ke 8) — Asset 1-3 fleksibel membantu satu sama lain kalau salah satu kebanjiran kerjaan, tapi defaultnya 1 orang pegang 1 jenis media penuh untuk semua 6 modul.

## Kenapa 8 orang (5 dev + 3 asset), bukan 15

Tim 15 orang (9 dev + 6 asset) dirasa terlalu besar untuk base model — banyak role (QA/UI-UX/DevOps/Compliance, Asset 4-6 generalist, Dev App terpisah) yang menambah koordinasi tanpa menambah kecepatan sebanding di fase awal ini. Struktur 8 orang ini lebih dekat ke ukuran tim awal proyek, tapi tetap mempertahankan 1 perbaikan penting dari iterasi sebelumnya: **Dev Testing sebagai role coding terpisah** (bukan dirangkap developer modul lain), supaya kualitas tidak cuma diperiksa "kalau sempat".

## Role lintas-modul yang masih perlu disepakati (dirangkap, belum ada headcount khusus)

- **Testing manual di device nyata**: Dev Testing + giliran siapa saja sebelum rilis.
- **CI/Godot export maintenance**: Bramantyo untuk sekarang (lihat `docs/DOCKER.md`), bisa dialihkan nanti kalau terasa berat.
- **Privacy Policy & Google Play Families Policy** (wajib sebelum publish ke Play Store, app anak punya aturan ekstra): **diputuskan 2026-11-20 — Bramantyo** (rangkap dengan infra/release manager yang sudah dia pegang), lihat `docs/WORK_BREAKDOWN.md` Part 1.6 dan `obsidian-vault/Decisions Log.md`.
- **Release manager** (export APK, publish listing): Bramantyo + Asset 3, koordinasi bareng.

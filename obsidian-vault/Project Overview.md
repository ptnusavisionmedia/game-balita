# Project Overview

**Nama**: Bayi GuguGaga *(working title — belum final, user masih mempertimbangkan nama lain)*
**Apa**: App game edukatif Android (+ iOS/web) untuk anak usia 1-5 tahun — kumpulan mini-game: angka, warna, hewan, musik, mewarnai, puzzle. Berangkat dari teori tumbuh-kembang anak (CDC milestones, Piaget, Erikson, Vygotsky, Montessori — lihat [[../docs/PLAN_TUMBUH_KEMBANG|docs/PLAN_TUMBUH_KEMBANG.md]]), bukan cuma kumpulan mini-game biasa.
**Target user**: anak 1-5 tahun (main), orang tua (parental gate, settings, panduan main bareng).
**Tim**: 8 orang dibantu AI/Claude — 5 developer (Bramantyo pegang core+scenes, Dev 2-4 @ 2 modul `feature_*`, 1 dev testing lintas-modul) + 3 asset/design creator (Asset 1 ilustrasi, Farel audio/VO, Asset 3 video/marketing). Lihat [[../docs/TEAM|docs/TEAM.md]].
**Repo**: https://github.com/ptnusavisionmedia/game-balita
**Stack**: Godot 4.7.2 (GDScript) — bukan Flutter/Dart lagi, lihat [[Decisions Log]] untuk histori pergantian.

## Status sekarang (2026-11-21)

### Fondasi app (selesai, headless-verified)
- `core/`: `AppColors`, `ProgressRepository` (progres lokal via `ConfigFile`), `SfxService`/`AudioService`, `StarRewardOverlay` (confetti + ikon ✓, **tanpa** jumlah bintang/skor — auto-lanjut, bukan tombol manual), `ParentalGateDialog` (soal tambah + keypad, bukan tahan-tombol), `GameFlow` (autoload pusat navigasi + katalog game + mode acak infinite + `guided_mode`).
- `scenes/`: `Splash` → `Home` (1 tombol "▶ Play" tengah = mode acak infinite, "Pilih Game" sekunder = manual, ⚙ Settings) → `Settings` (toggle suara + "Panduan Orang Tua") → `ParentGuide` (kartu scaffolding per modul, akses di belakang `ParentalGateDialog`).
- **Orientasi: LANDSCAPE** (bukan portrait — direvisi user 2026-11-21), `window/stretch/mode="canvas_items"` + `aspect="expand"` supaya UI konsisten proporsinya di HP & tablet.
- Tidak ada menang/kalah, tidak ada skor ditampilkan ke anak di mana pun — ini bukan cuma gaya, selaras teori (Erikson: usia 1-5 masih bangun rasa percaya diri; CDC: konsep menang-kalah baru matang kognitif ~5 tahun). Lihat [[Decisions Log]] entri 2026-11-20/21.

### 6 modul mini-game — **SEMUA sudah ada kode, 2026-11-21**
| Modul | Spek | Kode | Catatan |
|---|---|---|---|
| `feature_angka` | ✅ | ✅ **selesai, dites interaktif** | Pilot/pola rujukan. Placeholder: ikon hati (bukan ilustrasi final), SFX `null` |
| `feature_hewan` | ✅ | ✅ **selesai** | **2 mekanik** (satu-satunya): Mandiri (lewat Home, self-correcting) + Bareng Orang Tua (lewat ParentGuide → "Mulai main bareng", reveal manual tanpa benar/salah). Placeholder: emoji, SFX `null` |
| `feature_warna` | ✅ | ✅ **selesai (belum dites interaktif)** | 1 mekanik, tap cocokkan warna, reuse `AppColors`. Placeholder: emoji |
| `feature_musik` | ✅ | ✅ **selesai (belum dites interaktif)** | Sengaja **tanpa** soal benar/salah — tap bebas 6 nada, selesai di 8 ketukan |
| `feature_mewarnai` | ✅ | ✅ **selesai (belum dites interaktif)** | Sengaja **tanpa** soal benar/salah — isi 4 area (gambar "Kelinci"), bukan freehand. Placeholder: kotak warna |
| `feature_puzzle` | ✅ | ✅ **selesai, dites interaktif — bug drag diperbaiki jadi tap-pilih-taruh** | 4 keping, match warna (bukan potongan gambar asli dulu). Interaksi **bukan drag** — lihat Decisions Log 2026-11-21 |

Semua spek lengkap di `obsidian-vault/Specs/feature_*.md`. **Base model + Fase 2 kode-nya kini SEMUA ada** (headless-verified 10 scene) — yang tersisa murni aset asli (ilustrasi/SFX/VO, semua masih placeholder emoji/kotak warna/`null`) dan test interaktif sentuhan asli untuk 4 modul terbaru (baru `feature_angka` yang sudah dites manusia beneran).

### Fitur tumbuh-kembang (baru, 2026-11-21)
`docs/PLAN_TUMBUH_KEMBANG.md` — 2 mode dalam 1 app, bukan 2 app:
- **Fase A** (konten kartu) ✅ — `core/data/parent_guide.json`, 6 kartu.
- **Fase B** (scene `ParentGuide`) ✅ — `scenes/ParentGuide.tscn`+`parent_guide.gd`.
- **Fase C** (audit "bisa dimainkan tanpa baca" per modul) ⬜ Open.
- **Fase D** (review konten oleh manusia yang paham anak usia dini — **wajib**, bukan nasihat medis) ⬜ Open, PIC belum ditentukan.

### Infra & compliance
- Export Android debug APK **sudah terbukti jalan** lokal (~27MB, ter-sign) — CI export job ditulis, belum diverifikasi jalan sungguhan di GitHub Actions.
- `docs/PRIVACY_POLICY.md` — draft ditulis (Bramantyo pegang), **belum** diisi kontak & **belum** dipublikasikan ke URL publik (wajib sebelum submit Play Store).
- `.gitignore` — gradle build cache (`packages/app/android/.gradle/`) ditambahkan setelah ketahuan ikut mau ke-commit.

### Belum dikerjakan / terbuka
- Semua ilustrasi asli (baru ada 1: ikon vector `ModuleIcon` buat tile Home) & semua SFX/VO asli — semuanya masih placeholder (emoji/kotak warna/`null`), lihat baris Asset per modul di `docs/TASK_BOARD.md`.
- Test interaktif sentuhan asli untuk `feature_warna`/`feature_musik`/`feature_mewarnai`/`feature_puzzle` — kodenya sudah ada & headless-verified, tapi belum pernah dicoba klik/drag sungguhan oleh manusia.
- Test interaktif di device/emulator Android **asli** (baru di desktop Windows).
- `docs/QA_CHECKLIST.md` belum dibuat.
- Nama app final belum diputuskan (masih "Bayi GuguGaga" sementara).

## Keputusan besar (ringkasan — detail lengkap di [[Decisions Log]])

- Stack: Godot 4 (GDScript), bukan Flutter/Dart.
- Navigasi dipusatkan lewat `GameFlow` autoload — jangan `get_tree().change_scene_to_file()` langsung di mana pun.
- Pola "anchor 1-titik tanpa offset" buat center container itu **jebakan** (bikin size kolaps ke 0,0) — selalu pakai `CenterContainer`. Ketemu 2x (`ParentalGateDialog`, `StarRewardOverlay` lama), sudah jadi catatan standar.
- Tidak ada menang/kalah/skor ditampilkan ke anak, di modul apa pun, selamanya — ini prinsip keras, bukan preferensi yang bisa digeser per modul.
- `feature_hewan` boleh punya 2 mekanik karena memang diminta — **bukan pola default**, modul lain tetap 1 mekanik kecuali ada permintaan serupa.

## Link cepat

- [[../docs/ARCHITECTURE|Arsitektur]]
- [[../docs/TEAM|Pembagian tim]]
- [[../docs/PLAN_BASE_MODEL|Plan Base Model]]
- [[../docs/PLAN_TUMBUH_KEMBANG|Plan Fitur Tumbuh Kembang]]
- [[../docs/JOBS_BASE_MODEL|Jobs Base Model]]
- [[../docs/WORK_BREAKDOWN|Work Breakdown (detail per bagian)]]
- [[../docs/UI_UX_DESIGN|UI/UX Design & Color Palette]]
- [[../docs/PRIVACY_POLICY|Privacy Policy (draft)]]
- [[../docs/TASK_BOARD|Task Board (klaim task di sini)]]
- [[../docs/ROLES|Peran & batas file]]
- [[Specs/feature_angka|Spek feature_angka]] · [[Specs/feature_hewan|feature_hewan]] · [[Specs/feature_warna|feature_warna]] · [[Specs/feature_musik|feature_musik]] · [[Specs/feature_mewarnai|feature_mewarnai]] · [[Specs/feature_puzzle|feature_puzzle]]
- [[../CLAUDE|CLAUDE.md — entry point sesi AI baru]]

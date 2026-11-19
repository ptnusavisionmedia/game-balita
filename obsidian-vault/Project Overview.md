# Project Overview

**Nama**: Bayi GuguGaga
**Apa**: App game edukatif Android (+ iOS/web) untuk anak usia 1-5 tahun — kumpulan mini-game: angka, warna, hewan, musik, mewarnai, puzzle.
**Target user**: anak 1-5 tahun (main), orang tua (parental gate, settings).
**Tim**: 15 orang dibantu AI/Claude — 9 developer (1 modul `feature_*`/orang + core/app terpisah + 1 dev testing lintas-modul) + 6 asset/design creator (ilustrasi/audio/video, fleksibel, tidak coding). Lihat [[../docs/TEAM|docs/TEAM.md]].
**Repo**: https://github.com/ptnusavisionmedia/game-balita

## Status sekarang (2026-11-19)

**Stack diganti dari Flutter/Dart ke Godot 4/GDScript** — base model Flutter sempat selesai & terverifikasi jalan, lalu dihapus total atas permintaan user, ditulis ulang di Godot (lihat [[Decisions Log]] untuk histori lengkap).

- [x] Repo + struktur folder Godot (`core/`, `scenes/`, `features/feature_*`) ter-scaffold & ter-push.
- [x] `core/`: `AppColors`, `ProgressRepository`, `SfxService`/`AudioService`, `StarRewardOverlay` (confetti via `CPUParticles2D`), `ParentalGateDialog` — semua ditulis ulang di GDScript (lihat [[../docs/LIBRARIES|docs/LIBRARIES.md]]).
- [x] `scenes/Home.tscn` + `Settings.tscn` wiring navigasi + parental gate.
- [x] `features/feature_angka` (pilot) implementasi penuh.
- [x] Placeholder scene untuk 5 modul lain (`feature_warna/hewan/musik/mewarnai/puzzle`).
- [ ] **Belum pernah dibuka/dicoba di Godot Editor sungguhan** — sesi AI ini tidak install Godot untuk reset ini (beda dari base model Flutter sebelumnya yang sempat diinstall & diverifikasi). Lihat Definition of Done di [[../docs/PLAN_BASE_MODEL|docs/PLAN_BASE_MODEL.md]].
- [ ] CI/Docker untuk Godot — ditulis (`docs/DOCKER.md`, `.github/workflows/ci.yml`) tapi juga belum diverifikasi.
- [ ] Fase 2 (belum mulai): 5 modul lain coding paralel mengikuti pola dari base model.

## Keputusan besar

Lihat [[Decisions Log]] untuk detail & alasan lengkap (termasuk histori kenapa sempat pakai Flutter lalu ganti). Ringkasan terkini:
- Stack: **Godot 4 (GDScript)** — bukan Flutter/Dart lagi.
- State/persistence: autoload singleton (`ProgressRepository`) + `ConfigFile` bawaan Godot.
- Pembagian tim: **per fitur/modul**, bukan per layer (FE/BE/QA) — prinsip ini tidak berubah walau stack ganti.

## Link cepat

- [[../docs/ARCHITECTURE|Arsitektur]]
- [[../docs/TEAM|Pembagian tim]]
- [[../docs/AI_WORKFLOW|Cara kerja tim dengan AI]]
- [[../docs/PLAN_BASE_MODEL|Plan Base Model]]
- [[../docs/JOBS_BASE_MODEL|Jobs Base Model]]
- [[../docs/LIBRARIES|Analisis Libraries]]
- [[../docs/UI_UX_DESIGN|UI/UX Design & Color Palette]]
- [[../docs/DOCKER|Docker]]
- [[../docs/GIT_WORKFLOW|Cara Kolaborasi Git (pemula)]]
- [[../docs/TASK_BOARD|Task Board (klaim task di sini)]]
- [[../docs/ROLES|Peran & batas file (kenapa tidak tabrakan)]]
- [[../CLAUDE|CLAUDE.md — entry point sesi AI baru]]

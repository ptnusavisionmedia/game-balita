# Project Overview

**Nama**: Bayi GuguGaga
**Apa**: App game edukatif Android (+ iOS/web) untuk anak usia 1-5 tahun — kumpulan mini-game: angka, warna, hewan, musik, mewarnai, puzzle.
**Target user**: anak 1-5 tahun (main), orang tua (parental gate, settings).
**Tim**: 15 orang dibantu AI/Claude — 9 developer (1 modul `feature_*`/orang + core/app terpisah + 1 dev testing lintas-modul) + 6 asset/design creator (ilustrasi/audio/video, fleksibel, tidak coding). Lihat [[../docs/TEAM|docs/TEAM.md]].
**Repo**: https://github.com/ptnusavisionmedia/game-balita

## Status sekarang (2026-11-19)

- [x] Repo + struktur monorepo Flutter (Melos) ter-scaffold & ter-push.
- [x] 6 package `feature_*` + `core` + `app` ada, tapi isinya masih placeholder/screen kosong.
- [x] `core`: `AppTheme`/`AppColors` (palet & font), `StarRewardOverlay` (confetti), `SfxService`+`AudioService` sudah di-scaffold dengan library optimized (lihat [[../docs/LIBRARIES|docs/LIBRARIES.md]]).
- [x] Docker (`Dockerfile`, `docker-compose.yml`) + CI (`.github/workflows/ci.yml`) untuk environment konsisten (lihat [[../docs/DOCKER|docs/DOCKER.md]]) — Docker Desktop sendiri belum terinstall, perlu dijalankan manual per laptop.
- [ ] **Sedang dikerjakan: Fase 1 — Base Model** (lihat [[../docs/PLAN_BASE_MODEL|docs/PLAN_BASE_MODEL.md]]). Sisa: `ProgressRepository`, `ParentalGateDialog`, `SettingsScreen`, wiring `feature_angka` end-to-end.
- [ ] Fase 2 (belum mulai): 6 modul lain coding paralel mengikuti pola dari base model.

## Keputusan besar

Lihat [[Decisions Log]] untuk detail & alasan. Ringkasan:
- Stack: **Flutter + Dart**, monorepo feature-first (Melos).
- State management fase 1: **`ChangeNotifier` bawaan Flutter** (sengaja belum pakai Riverpod/Bloc).
- Pembagian tim: **per fitur/modul**, bukan per layer (FE/BE/QA).

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

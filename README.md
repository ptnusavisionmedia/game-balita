# Bayi GuguGaga

Aplikasi permainan edukatif untuk anak usia 1-5 tahun: mengenal angka, warna, bentuk, hewan, musik, mewarnai, dan puzzle sederhana — ringan, aman, dan ramah disentuh anak kecil.

## Tech stack

**Flutter (Dart)**, dengan struktur monorepo *feature-first* yang dikelola lewat [Melos](https://melos.invertase.dev/).

Alasan dipilih untuk tim 7 orang yang semuanya dibantu AI (Claude):

- **Ringan**: APK bisa di-split per ABI, tree-shaking ikon, AOT compile — cocok untuk device low-end yang biasa dipegang anak/ortu.
- **Satu codebase** untuk Android, iOS, dan web (berguna untuk demo cepat ke stakeholder tanpa build APK).
- **Dart kuat tipe & mudah dibaca** — AI model & developer baru sama-sama cepat paham kode orang lain, gampang nebak di mana bug-nya.
- **Modular per fitur** (lihat [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)) — tiap mini-game adalah package Dart terpisah, jadi 7 orang (+ 7 sesi Claude yang berbeda) bisa kerja paralel tanpa rebutan file dan tanpa perlu baca seluruh codebase.
- **Hot reload** mempercepat iterasi animasi/audio untuk UI anak-anak.
- **Ekosistem matang** untuk kebutuhan game anak: `flutter_animate`, `rive`/`lottie` (animasi karakter), `audioplayers` (efek suara & VO), `just_audio`.

## Struktur project

```
bayi-gugugaga/
├── packages/
│   ├── core/              # design system, model, service bersama (dipakai semua modul)
│   ├── app/                # shell app: navigasi, home menu, parental gate, settings
│   ├── feature_angka/      # mini-game berhitung
│   ├── feature_warna/      # mini-game warna & bentuk
│   ├── feature_hewan/      # mini-game suara hewan
│   ├── feature_musik/      # mini-game musik/piano sederhana
│   ├── feature_mewarnai/   # mini-game mewarnai
│   └── feature_puzzle/     # mini-game puzzle & mencocokkan
├── docs/                   # arsitektur, pembagian tim, cara kerja dengan AI
└── melos.yaml
```

Aturan dependensi: `feature_*` hanya boleh depend ke `core`, **tidak boleh** saling depend antar `feature_*`. `app` meng-assemble semua fitur. Ini yang membuat 7 modul benar-benar independen.

## Mulai development

Project ini di-scaffold strukturnya tapi **belum** di-generate dengan `flutter create` (SDK Flutter belum terpasang di environment ini). Langkah pertama untuk siapa pun yang pegang laptop dengan Flutter SDK terpasang:

```bash
dart pub global activate melos
melos bootstrap
```

Lalu generate platform folder (android/ios/web) untuk package `app` dan tiap `feature_*` / `core` sebagai package Flutter biasa:

```bash
cd packages/app
flutter create . --platforms=android,ios,web --org com.gugugaga
```

(Setiap package `feature_*` dan `core` juga perlu di-`flutter create .` sekali agar punya `pubspec.yaml` yang valid sebagai Flutter package — isi `pubspec.yaml` contoh sudah disiapkan, tinggal disesuaikan.)

Sesi AI/developer baru: mulai dari [CLAUDE.md](CLAUDE.md) (entry point wajib — urutan dokumen & cara klaim task).

Baca selanjutnya:
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — kenapa modular, aturan dependensi, cara menambah modul baru
- [docs/TEAM.md](docs/TEAM.md) — pembagian tim: 4 developer + 3 asset creator
- [docs/TASK_BOARD.md](docs/TASK_BOARD.md) — task mana yang Open/Claimed/Done
- [docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md) — cara kerja tim yang semua pakai Claude/AI tanpa saling tabrakan
- [docs/PLAN_BASE_MODEL.md](docs/PLAN_BASE_MODEL.md) — plan fase sekarang (base model)
- [docs/JOBS_BASE_MODEL.md](docs/JOBS_BASE_MODEL.md) — tugas tiap orang untuk fase base model
- [docs/LIBRARIES.md](docs/LIBRARIES.md) — analisis & pilihan library (kenapa pakai ini, bukan tulis sendiri)
- [docs/UI_UX_DESIGN.md](docs/UI_UX_DESIGN.md) — prinsip UX, information architecture, color palette
- [docs/DOCKER.md](docs/DOCKER.md) — environment konsisten lewat Docker untuk analyze/test/build
- [docs/GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md) — **baru pertama kolaborasi lewat Git? mulai dari sini** — panduan lengkap step-by-step biar tidak tabrakan
- [CONTRIBUTING.md](CONTRIBUTING.md) — branch, commit, PR (versi singkat)

## Context & decisions (Obsidian)

Folder [obsidian-vault/](obsidian-vault/) menyimpan context yang mudah hilang kalau cuma di chat: log keputusan ([obsidian-vault/Decisions Log.md](obsidian-vault/Decisions%20Log.md)) dan spek tiap mini-game ([obsidian-vault/Specs/](obsidian-vault/Specs/)). Buka folder **root repo ini** sebagai vault di Obsidian (bukan sub-foldernya) supaya link antar dokumen bisa diklik. Isi vault ikut di-commit ke git seperti kode.

# Bayi GuguGaga

Aplikasi permainan edukatif untuk anak usia 1-5 tahun: mengenal angka, warna, bentuk, hewan, musik, mewarnai, dan puzzle sederhana — ringan, aman, dan ramah disentuh anak kecil.

## Tech stack

**Godot 4 (GDScript)**, struktur *feature-first* — 1 scene/folder per mini-game, mirip prinsip modular yang sebelumnya dipakai di percobaan Flutter (lihat `obsidian-vault/Decisions Log.md` untuk histori penggantian stack).

Alasan dipilih untuk tim 15 orang yang semuanya dibantu AI (Claude):

- **Game engine sungguhan**: particle system (confetti reward), node 2D, audio latensi rendah bawaan — semua "rasa game" yang di Flutter perlu digabung dari banyak package pihak ketiga, di Godot sudah native. Lihat [docs/LIBRARIES.md](docs/LIBRARIES.md).
- **Scene-based**: 1 mini-game = 1 scene (`.tscn` + `.gd`) di foldernya sendiri — modular secara alami, cocok untuk tim besar kerja paralel tanpa rebutan file.
- **GDScript mudah dibaca**: sintaks mirip Python, developer baru & AI cepat paham kode orang lain.
- **Editor visual**: non-programmer (illustrator, UI/UX designer) bisa bantu susun scene lewat Godot Editor tanpa harus baca kode.
- **Ringan & open source**: export APK kecil, tidak ada lisensi/biaya engine.

## Struktur project

```
bayi-gugugaga/
├── project.godot           # config utama Godot
├── core/
│   ├── scripts/             # autoload singleton: ProgressRepository, SfxService, AudioService, AppColors
│   └── scenes/               # scene reusable: BigRoundButton, StarRewardOverlay, ParentalGateDialog
├── scenes/
│   ├── Home.tscn             # menu utama
│   └── Settings.tscn         # pengaturan (lewat parental gate)
├── features/
│   ├── feature_angka/        # mini-game berhitung (pilot base model)
│   ├── feature_warna/        # mini-game warna & bentuk
│   ├── feature_hewan/        # mini-game suara hewan
│   ├── feature_musik/        # mini-game musik/piano sederhana
│   ├── feature_mewarnai/     # mini-game mewarnai
│   └── feature_puzzle/       # mini-game puzzle & mencocokkan
├── docs/                    # arsitektur, pembagian tim, cara kerja dengan AI
└── obsidian-vault/          # decisions log, spek tiap mini-game
```

Aturan dependensi: `features/feature_*` hanya boleh pakai `core/` (autoload singleton + scene reusable), **tidak boleh** saling depend antar `feature_*`. `scenes/Home.tscn` jadi titik masuk yang meng-assemble semua fitur. Ini yang membuat 6 modul benar-benar independen — detail di [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Mulai development

1. Install [Godot 4](https://godotengine.org/download) (versi stable terbaru, minimal 4.3) — download zip "standard" (bukan .NET/Mono), extract ke folder manapun.
2. **(Opsional, disarankan)** supaya bisa ketik `godot` dari terminal mana pun:
   - Buat file `godot.bat` di folder tempat extract, isinya: `@echo off` lalu baris `"%~dp0Godot_v4.x.x-stable_win64_console.exe" %*` (sesuaikan nama file `.exe`-nya).
   - Tambahkan folder itu ke PATH (Windows: Environment Variables → User variables → `Path` → New). Perlu buka terminal/editor baru supaya PATH terbaca.
3. Buka folder repo ini lewat **Project > Import** di Godot Editor, pilih `project.godot`.
4. Godot akan generate folder `.godot/` (cache, sudah di-`.gitignore`) saat pertama dibuka — ini normal.
5. Scene utama: `scenes/Home.tscn` (sudah di-set sebagai `run/main_scene` di `project.godot`) — tekan F5 atau tombol Play untuk coba jalan.

Base model (`feature_angka` sebagai pilot + core services) sudah **terverifikasi lolos headless** (Godot 4.7.2, semua 8 scene exit 0, 1 bug ketemu & diperbaiki) — tapi belum pernah dicoba interaktif (sentuhan asli) atau export APK. Lihat `obsidian-vault/Decisions Log.md` untuk status verifikasi lengkap.

Sesi AI/developer baru: mulai dari [CLAUDE.md](CLAUDE.md) (entry point wajib — urutan dokumen & cara klaim task).

Baca selanjutnya:
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — kenapa modular, aturan dependensi, cara menambah modul baru
- [docs/TEAM.md](docs/TEAM.md) — pembagian tim: 9 developer + 6 asset/design creator
- [docs/ROLES.md](docs/ROLES.md) — folder/file persis apa yang boleh/tidak boleh disentuh tiap peran, dan kenapa tidak akan tabrakan
- [docs/TASK_BOARD.md](docs/TASK_BOARD.md) — task mana yang Open/Claimed/Done
- [docs/AI_WORKFLOW.md](docs/AI_WORKFLOW.md) — cara kerja tim yang semua pakai Claude/AI tanpa saling tabrakan
- [docs/PLAN_BASE_MODEL.md](docs/PLAN_BASE_MODEL.md) — plan fase sekarang (base model)
- [docs/JOBS_BASE_MODEL.md](docs/JOBS_BASE_MODEL.md) — tugas tiap orang untuk fase base model
- [docs/LIBRARIES.md](docs/LIBRARIES.md) — fitur bawaan Godot yang dipakai (kenapa jarang butuh addon pihak ketiga)
- [docs/UI_UX_DESIGN.md](docs/UI_UX_DESIGN.md) — prinsip UX, information architecture, color palette
- [docs/DOCKER.md](docs/DOCKER.md) — environment konsisten lewat Docker untuk export/CI headless
- [docs/GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md) — **baru pertama kolaborasi lewat Git? mulai dari sini** — panduan lengkap step-by-step biar tidak tabrakan
- [CONTRIBUTING.md](CONTRIBUTING.md) — branch, commit, PR (versi singkat)

## Context & decisions (Obsidian)

Folder [obsidian-vault/](obsidian-vault/) menyimpan context yang mudah hilang kalau cuma di chat: log keputusan ([obsidian-vault/Decisions Log.md](obsidian-vault/Decisions%20Log.md)) dan spek tiap mini-game ([obsidian-vault/Specs/](obsidian-vault/Specs/)). Buka folder **root repo ini** sebagai vault di Obsidian (bukan sub-foldernya) supaya link antar dokumen bisa diklik. Isi vault ikut di-commit ke git seperti kode.

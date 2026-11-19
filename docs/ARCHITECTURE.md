# Arsitektur

## Kenapa monorepo feature-first?

Tim ada 15 orang, semua dibantu AI (Claude). Masalah paling umum di tim sebesar ini bukan "kodenya salah", tapi **rebutan file dan merge conflict**, plus tiap sesi AI yang harus membaca seluruh codebase untuk paham konteks. Feature-first monorepo menyelesaikan dua masalah itu sekaligus:

- Satu mini-game = satu package Dart (`packages/feature_xxx`). Isinya lengkap: UI, logic, asset, test.
- Developer (dan sesi Claude-nya) yang pegang `feature_angka` **tidak perlu** buka folder `feature_musik` sama sekali.
- Conflict antar modul = 0, karena tidak ada file yang di-share kecuali lewat `core`.

## Aturan dependensi (wajib)

```
feature_* ──depends on──> core
app       ──depends on──> core, feature_angka, feature_warna, feature_hewan,
                           feature_musik, feature_mewarnai, feature_puzzle
feature_* ──TIDAK BOLEH depend ke feature_* lain──
```

`core` berisi yang benar-benar dipakai bersama saja:
- Design tokens (warna, ukuran, font untuk UI anak — tombol besar, kontras tinggi)
- Widget umum (`BigRoundButton`, `StarRewardOverlay`, `ParentalGateDialog`)
- Service umum (audio player wrapper, progress/save-state lokal, analytics ringan)
- Model data umum (`ChildProfile`, `GameResult`)

Kalau sebuah fitur butuh sesuatu dari `core` yang belum ada: **tambahkan ke `core`, jangan import langsung antar-feature package**. Perubahan di `core` wajib lewat PR yang di-review pemilik `core`/`app` (lihat `docs/TEAM.md`), karena dia satu-satunya titik yang menyentuh semua modul.

## Tiap mini-game sebagai package

Struktur standar tiap `feature_*`:

```
packages/feature_angka/
├── pubspec.yaml
├── lib/
│   ├── feature_angka.dart     # satu-satunya file yang di-export, public API
│   └── src/
│       ├── angka_screen.dart
│       ├── angka_controller.dart
│       └── widgets/
├── assets/
│   ├── images/
│   └── audio/
└── test/
```

`app` hanya tahu satu widget per fitur (contoh: `AngkaGameScreen`) yang di-export dari `feature_angka.dart`. Internal (`src/`) bebas diubah pemilik modul tanpa mempengaruhi siapa pun.

## Menambah modul baru

1. Copy struktur folder `feature_puzzle` sebagai template.
2. Tambahkan path baru di `melos.yaml` (biasanya otomatis ter-detect kalau polanya `packages/*`).
3. Daftarkan di `pubspec.yaml` milik `app` + panggil widget export-nya di menu utama.
4. Update `docs/TEAM.md` dan `.github/CODEOWNERS`.

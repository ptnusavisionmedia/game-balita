# Arsitektur

## Kenapa feature-first?

Tim ada 8 orang, semua dibantu AI (Claude). Masalah paling umum di tim sebesar ini bukan "kodenya salah", tapi **rebutan file dan merge conflict**, plus tiap sesi AI yang harus membaca seluruh codebase untuk paham konteks. Struktur feature-first menyelesaikan dua masalah itu sekaligus:

- Satu mini-game = satu folder (`features/feature_xxx/`). Isinya lengkap: scene (`.tscn`), script (`.gd`), asset.
- Developer (dan sesi Claude-nya) yang pegang `feature_angka` **tidak perlu** buka folder `feature_musik` sama sekali.
- Conflict antar modul = 0, karena tidak ada file yang di-share kecuali lewat `core/`.

## Aturan dependensi (wajib)

```
features/feature_* ──pakai──> core/ (autoload singleton + scene reusable)
scenes/Home.tscn    ──pakai──> core/, features/feature_angka, feature_warna, feature_hewan,
                                feature_musik, feature_mewarnai, feature_puzzle
features/feature_* ──TIDAK BOLEH saling depend antar feature_* lain──
```

`core/` berisi yang benar-benar dipakai bersama saja:
- **Autoload singleton** (`project.godot` `[autoload]`, dipanggil global lewat nama-nya): `ProgressRepository` (simpan/baca progres & setting suara), `SfxService` (SFX pendek), `AudioService` (musik/VO panjang).
- **Scene reusable** (`core/scenes/`): `BigRoundButton.tscn`, `StarRewardOverlay.tscn`, `ParentalGateDialog.tscn`.
- **Konstanta/tema** (`core/scripts/app_colors.gd`): palet warna (lihat `docs/UI_UX_DESIGN.md`).

Kalau sebuah fitur butuh sesuatu dari `core/` yang belum ada: **tambahkan ke `core/`, jangan copy-paste logic ke tiap feature**. Perubahan di `core/` wajib lewat PR yang di-review Bramantyo (pemegang `core`, lihat `docs/TEAM.md`), karena dia satu-satunya titik yang menyentuh semua modul.

## Tiap mini-game sebagai folder sendiri

Struktur standar tiap `feature_*`:

```
features/feature_angka/
├── Angka.tscn         # scene utama, 1 file ini yang dipanggil dari Home
├── angka.gd           # script scene, semua logic mini-game ini
└── assets/
    ├── images/
    └── audio/
```

`scenes/home.gd` hanya tahu path ke 1 scene per fitur (`res://features/feature_angka/Angka.tscn`), dipanggil lewat `get_tree().change_scene_to_file(...)`. Isi dalam folder fitur bebas diubah pemilik modul tanpa mempengaruhi siapa pun — tidak ada konsep "public API file" seperti di Flutter karena tiap fitur cuma 1 scene yang dipanggil dari luar.

## Menambah modul baru

1. Copy struktur folder `features/feature_puzzle` sebagai template.
2. Tambah 1 baris di `_GAMES` di `scenes/home.gd` (nama + path scene).
3. Update `docs/TEAM.md`.

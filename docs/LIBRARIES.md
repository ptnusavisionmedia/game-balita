# Analisis Libraries / Fitur Engine

Prinsip yang sama seperti sebelumnya (dulu ditulis untuk Flutter, tetap berlaku): **jangan tulis kode sendiri untuk hal yang Godot sudah punya built-in & teruji**. Bedanya, di Godot kebutuhan dasar game anak-anak ini hampir semuanya **sudah ada bawaan engine** — jarang perlu addon pihak ketiga sama sekali.

## Kebutuhan dasar, sudah built-in Godot (tidak perlu addon)

| Kebutuhan | Fitur Godot bawaan | Kenapa, bukan tulis/pakai library sendiri |
|---|---|---|
| SFX pendek, sering dipicu | `AudioStreamPlayer` (node) | Latensi rendah secara default di engine, beda dengan web/Flutter yang butuh trik tambahan (dulu `soundpool` di percobaan Flutter). |
| Musik/VO panjang | `AudioStreamPlayer` (node terpisah dari SFX) | Sama, tapi dipisah node supaya SFX tidak motong musik yang sedang main. |
| Animasi reward/perayaan (confetti) | `CPUParticles2D` / `GPUParticles2D` | Particle system native engine — jauh lebih optimal daripada particle buatan sendiri, dan tidak perlu package `confetti` seperti di Flutter. |
| Micro-interaction (bounce, fade) | `Tween` / `AnimationPlayer` | API bawaan untuk animasi UI, menghindari kode manual `_process()` yang rawan bug timing. |
| Font ramah anak | Import file font (`.ttf`/`.otf`) langsung sebagai `FontFile` resource | Godot native dukung custom font tanpa package tambahan (beda dengan Flutter yang butuh `google_fonts` untuk lazy-load). |
| Ikon/ilustrasi vektor | Import `.svg` langsung — Godot rasterize otomatis saat import | Tidak perlu `flutter_svg` atau sejenisnya. |
| Progres/setting sederhana (simpan ke disk) | `ConfigFile` (built-in, dipakai `ProgressRepository`) | Setara `shared_preferences` di Flutter, tapi bawaan engine, tidak perlu plugin. |
| Drag & drop (nanti untuk `feature_puzzle`/`feature_mewarnai`) | `Control._get_drag_data()` / `_drop_data()`, atau fisika `RigidBody2D` kalau butuh fisika nyata | Bawaan, tidak perlu library gestur tambahan. |

## Sengaja TIDAK ditambah addon (base model)

- **Addon particle/animasi pihak ketiga** — `CPUParticles2D`/`Tween` bawaan sudah cukup untuk base model. Addon dari Asset Library baru dipertimbangkan kalau ada kebutuhan spesifik yang benar-benar tidak tercover (misal shader custom kompleks).
- **State management framework** — Godot sudah punya pola node tree + signal + autoload singleton yang setara "state management" tanpa perlu framework tambahan (beda dengan Flutter yang butuh diskusi ChangeNotifier vs Riverpod).
- **Testing framework (GUT)** — belum ditambah di base model. Kalau Dev Testing (lihat `docs/TEAM.md`) merasa perlu automated test di Fase 2, addon [GUT (Godot Unit Test)](https://github.com/bitwes/Gut) jadi pilihan pertama, bukan ditulis sendiri.

## Perubahan dari rencana Flutter sebelumnya

Base model sebelumnya (Flutter) sempat merencanakan `soundpool`, `confetti`, `flutter_animate`, `google_fonts`, `flutter_svg`, `shared_preferences`, `mocktail`. Semua kebutuhan itu **sudah tercover fitur bawaan Godot** di tabel atas — tidak ada package pengganti 1:1 yang perlu dicari, karena bukan soal "cari library setara di Godot", tapi "fiturnya sudah ada di engine".

# Analisis Libraries

Prinsip: **jangan tulis kode sendiri untuk hal yang sudah ada library teruji & lebih optimal** (audio engine, particle/confetti, easing animasi, font rendering). Tapi juga jangan tambah dependency untuk hal yang Flutter SDK sendiri sudah cukup bagus (haptic feedback, `ChangeNotifier`, `Draggable`/`DragTarget`) — itu cuma nambah ukuran APK & permukaan bug tanpa manfaat nyata.

## Dependency final untuk base model

| Kebutuhan | Pilihan | Kenapa, bukan tulis sendiri |
|---|---|---|
| SFX pendek, sering dipicu (benar/salah/tap) | **`soundpool: ^2.4.0`** | Pakai native `SoundPool` (Android) / low-latency API (iOS) — latensi jauh lebih rendah dari play ulang file lewat `audioplayers` untuk suara pendek yang dipicu berkali-kali tiap detik. Custom audio-pool sendiri = reinvent `SoundPool`. |
| Musik/VO panjang (background, instruksi suara) | **`audioplayers: ^6.0.0`** (sudah ada) | Cocok untuk audio panjang/streaming, tidak perlu latensi se-ekstrem SFX. Dipisah dari SFX supaya tiap service punya tanggung jawab jelas. |
| Animasi reward/perayaan (bintang, confetti) | **`confetti: ^0.7.0`** | Particle system yang sudah dioptimasi (object pooling, physics sederhana) — nulis particle system sendiri gampang jadi jank di device low-end, yang justru target utama app ini. |
| Micro-interaction (bounce saat tap, fade transisi) | **`flutter_animate: ^4.5.0`** | API deklaratif, menghindari boilerplate `AnimationController`/`Tween` manual yang rawan lupa `dispose()` (memory leak klasik di Flutter). |
| Font ramah anak (rounded, mudah dibaca) | **`google_fonts: ^6.2.0`** (font **Baloo 2**) | Font di-cache & di-load lazy secara otomatis oleh package-nya; tidak perlu urus embedding file font manual per platform. |
| Ikon/ilustrasi vektor (tombol, ikon menu) | **`flutter_svg: ^2.0.0+1`** | Satu file SVG scalable tajam di semua kerapatan layar, lebih kecil dari taruh 4-5 varian PNG per aset. |
| Progres/setting sederhana (on/off, flag) | **`shared_preferences: ^2.2.0`** (sudah ada) | Cukup untuk key-value sederhana di base model. |
| Unit test `core` tanpa platform channel asli | **`mocktail: ^1.0.3`** (dev) | Mock `SharedPreferences`/`AudioService` tanpa perlu nulis fake class manual. |

## Sengaja TIDAK ditambah (base model)

- **Flame (game engine)** — mini-game di base model cuma tap/drag + audio + animasi ringan, tidak butuh game loop/physics/camera milik Flame. Kalau nanti modul tertentu (misal `feature_puzzle` butuh drag-fisika, atau `feature_musik` butuh visualizer real-time) benar-benar butuh render loop, baru pertimbangkan Flame **khusus modul itu** (Flame bisa ditanam sebagai widget di 1 screen saja, tidak perlu migrasi seluruh app).
- **Riverpod/Bloc** — `ChangeNotifier` bawaan Flutter SDK sudah "library" yang teruji dan cukup untuk skala `ProgressRepository` base model. Upgrade state management itu sendiri adalah biaya (belajar + migrasi), jadi hanya dilakukan kalau ada sinyal nyata `ChangeNotifier` kurang (bukan diasumsikan di awal).
- **Rive** — bagus untuk animasi karakter/mascot kompleks, tapi butuh designer yang bikin file `.riv`. Dicatat sebagai upgrade path Fase 2+ kalau sudah ada aset dari asset artist, bukan base model.
- **Haptic feedback library** — `HapticFeedback` bawaan `flutter/services.dart` sudah cukup, tidak perlu package tambahan.

## Perubahan di `packages/core`

- `AudioService` (sudah ada, `audioplayers`) → sekarang didokumentasikan sebagai **khusus musik/VO panjang**.
- **Baru**: `SfxService` (`soundpool`) → khusus efek suara pendek yang sering dipicu.
- **Baru**: `StarRewardOverlay` di-reimplementasi pakai `confetti`, bukan particle system manual.
- **Baru**: `AppTheme`/`AppColors` pakai `google_fonts` untuk tipografi (lihat [docs/UI_UX_DESIGN.md](UI_UX_DESIGN.md) untuk palet & rasional warna).

Semua ini masuk ke scope **Job 1** di [docs/JOBS_BASE_MODEL.md](JOBS_BASE_MODEL.md) — sudah disiapkan sebagian oleh sesi ini supaya Job 1 tidak mulai dari nol.

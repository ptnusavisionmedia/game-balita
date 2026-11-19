# Docker

## Kenapa

Tim ada 15 orang, semua pakai laptop berbeda. Masalah klasik: "di laptop saya `flutter pub get` jalan, di laptop kamu error" karena versi Flutter/Dart beda. Docker di sini dipakai supaya **semua orang (dan CI) pakai versi Flutter yang sama persis**, tanpa perlu install Flutter SDK manual di tiap laptop.

## Yang BISA dilakukan lewat Docker

- `flutter pub get` (resolve dependency semua package, lewat Dart/Flutter native workspace)
- `flutter analyze`
- `flutter test`
- `flutter build apk` (build APK release — tidak butuh emulator, cukup Android SDK yang sudah ada di image)

## Yang TIDAK bisa lewat Docker

- **Menjalankan app interaktif di emulator/device** (`flutter run`, hot reload). Android emulator butuh GPU/virtualisasi langsung ke OS, tidak praktis dijalankan di dalam Docker di Windows. Untuk coding sehari-hari dengan hot reload, tetap install Flutter SDK + Android Studio/emulator **native** di laptop masing-masing — Docker cuma menjamin hasil `analyze`/`test`/`build` konsisten, bukan pengganti environment development interaktif.

## Install Docker Desktop (sekali per laptop)

Docker Desktop di Windows butuh WSL2 + restart — **jalankan sendiri** langkah ini (bukan sesuatu yang aman dilakukan otomatis dari sesi AI):

```powershell
wsl --install
winget install Docker.DockerDesktop
```

Restart laptop, buka Docker Desktop sekali untuk menyelesaikan setup awal, baru lanjut ke bawah.

## Pakai

```bash
docker compose build
docker compose run --rm dev flutter pub get
docker compose run --rm dev dart run melos run analyze
docker compose run --rm dev dart run melos run test
```

(Pakai `dart run melos ...`, bukan `melos` langsung — Melos di proyek ini cuma dev_dependency lokal, bukan di-global-activate. `flutter pub get` sudah resolve dependency semua package sekaligus lewat Dart/Flutter native workspace.)

Atau masuk shell interaktif di dalam kontainer (tetap tidak bisa `flutter run` ke emulator, tapi enak untuk debug dependency):

```bash
docker compose run --rm dev bash
```

CI (GitHub Actions) pakai image yang sama (lihat `.github/workflows/ci.yml`) supaya hasil lokal dan di CI konsisten.

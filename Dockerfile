# Environment Flutter yang SAMA untuk semua developer + CI.
# Tujuan: hindari masalah "di laptop saya jalan" karena beda versi Flutter/Dart.
# Image ini TIDAK untuk menjalankan app di emulator (lihat docs/DOCKER.md) —
# cuma untuk `flutter pub get`, `dart run melos ...`, `flutter analyze`,
# `flutter test`, `flutter build apk`.
#
# Melos TIDAK di-global-activate — sejak v7, Melos jadi dev_dependency biasa
# di root pubspec.yaml, otomatis ke-fetch lewat `flutter pub get` di bawah.
# Jalankan scriptnya lewat `dart run melos run <nama>` (lihat README/pubspec.yaml).
#
# Versi WAJIB >= yang bundling Dart >=3.6 (native pub workspaces — lihat
# `workspace:` di root pubspec.yaml). Flutter 3.50.0 (Dart 3.14) sudah
# terverifikasi jalan (flutter pub get, analyze, test, build web).

FROM ghcr.io/cirruslabs/flutter:3.50.0

WORKDIR /workspace

COPY . .

RUN flutter pub get

CMD ["bash"]

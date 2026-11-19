# Environment Flutter yang SAMA untuk semua developer + CI.
# Tujuan: hindari masalah "di laptop saya jalan" karena beda versi Flutter/Dart.
# Image ini TIDAK untuk menjalankan app di emulator (lihat docs/DOCKER.md) —
# cuma untuk `melos bootstrap`, `flutter analyze`, `flutter test`, `flutter build apk`.

FROM ghcr.io/cirruslabs/flutter:3.24.3

WORKDIR /workspace

RUN dart pub global activate melos 1.0.1

COPY . .

CMD ["bash"]

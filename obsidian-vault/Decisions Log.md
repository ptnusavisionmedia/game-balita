# Decisions Log

Append-only. Jangan edit/hapus entri lama — kalau keputusan berubah, tambah entri baru yang menyatakan perubahannya (dan kenapa).

---

## 2026-11-18 — Stack: Flutter + monorepo feature-first

**Keputusan**: pakai Flutter (Dart), struktur monorepo `packages/` dikelola Melos, 1 package per mini-game.

**Alasan**: APK ringan (AOT, tree-shaking, split per ABI), satu codebase Android/iOS/web, Dart kuat tipe jadi mudah dibaca developer baru & AI, dan yang paling penting — modular per fitur bikin 7 orang bisa kerja paralel tanpa rebutan file, tiap sesi Claude cukup diberi konteks 1 folder saja.

**Alternatif yang dipertimbangkan**: native Android (Kotlin) — lebih ringan tapi tidak cross-platform & lebih lambat iterasi tim besar. React Native — kurang ideal untuk game.

## 2026-11-18 — Pembagian tim: per fitur, bukan per layer

**Keputusan**: 7 orang = 7 modul (1 lead pegang `core`+`app`, 6 dev masing-masing 1 mini-game), bukan dibagi FE/BE/Asset/QA.

**Alasan**: tiap mini-game kecil & hampir berdiri sendiri (tidak ada backend, state antar-fitur minim). Pembagian per layer bikin 1 fitur butuh koordinasi banyak orang untuk hal sepele.

## 2026-11-19 — Godot dipertimbangkan, tetap pakai Flutter

**Keputusan**: tetap Flutter, tidak pindah ke Godot.

**Alasan**: Godot lebih "game-engine-native" (particle effect, animasi sprite kompleks, scene editor visual untuk artist), tapi scope mini-game di app ini sederhana (tap/drag + audio + animasi ringan), dan scaffold Flutter sudah jalan — pindah engine berarti buang kerjaan dan mulai dari nol. Dicatat sebagai opsi kalau ke depan butuh fitur game-feel yang jauh lebih kompleks.

## 2026-11-19 — Fase 1 fokus "base model" dulu, bukan 7 modul paralel langsung

**Keputusan**: sebelum 6 dev mulai coding mini-game masing-masing, dulukan 1 vertical slice (`feature_angka` sebagai pilot) yang jalan end-to-end (navigasi, state/persistence, reward, audio, parental gate, settings). Lihat `docs/PLAN_BASE_MODEL.md` & `docs/JOBS_BASE_MODEL.md`.

**Alasan**: kalau 7 orang langsung coding paralel tanpa pola yang terbukti jalan, hasilnya 7 cara berbeda pakai `core` yang harus dirapikan ulang. 5 dev yang belum pegang modul coding selama fase ini mengerjakan spek + daftar asset dulu (lihat `Specs/`), supaya tidak nganggur dan begitu base model lolos, mereka langsung jalan tanpa delay.

**State management**: sengaja pakai `ChangeNotifier` bawaan Flutter dulu untuk `ProgressRepository`, bukan Riverpod/Bloc — alasan: barrier masuk rendah untuk tim dengan level campuran. Revisit kalau base model kerasa kurang.

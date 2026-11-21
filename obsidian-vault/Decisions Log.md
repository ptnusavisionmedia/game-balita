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

## 2026-11-19 — Pilih library optimized daripada tulis sendiri (audio, reward, font)

**Keputusan**: `soundpool` untuk SFX pendek (bukan `audioplayers` yang latensinya lebih tinggi untuk suara berulang), `confetti` untuk animasi reward (bukan particle system manual), `flutter_animate` untuk micro-interaction (bukan `AnimationController` manual), `google_fonts` (Baloo 2) untuk tipografi, `flutter_svg` untuk ikon vektor. Tetap **tidak** menambah Flame/Riverpod/Rive di base model — dianggap belum perlu (lihat `docs/LIBRARIES.md` untuk rasional lengkap tiap pilihan).

**Alasan**: ini area yang "mudah dipertanyakan optimasinya" kalau ditulis sendiri (latensi audio, performa particle system di device low-end) — pakai library teruji lebih aman daripada reinvent.

## 2026-11-19 — Color palette & tipografi ditetapkan

**Keputusan**: palet warna hangat-kontras-tinggi (sunshine `#FFC93C`, cream `#FFFDF5`, ink `#2B2D42`, leaf/coral/gold untuk feedback, 6 warna aksen per mini-game), font Baloo 2. Detail & rasional lengkap (termasuk kenapa bukan merah untuk "salah") di `docs/UI_UX_DESIGN.md`. Implementasi: `packages/core/lib/src/theme/`.

**Keputusan tambahan**: tidak ada dark mode untuk base model — app anak selalu pakai tema cerah terlepas dari system theme.

## 2026-11-19 — Docker untuk konsistensi environment (analyze/test/build, bukan untuk `flutter run`)

**Keputusan**: pakai image Docker (`ghcr.io/cirruslabs/flutter:3.24.3`) yang sama di CI dan lokal (`docker-compose.yml`) untuk `melos bootstrap`/`analyze`/`test`/`build apk`. **Tidak** dipakai untuk `flutter run` ke emulator (butuh GPU/virtualisasi native, tidak praktis di Docker Windows) — dev tetap install Flutter SDK native untuk kerja harian dengan hot reload.

**Alasan**: menghindari masalah "beda versi Flutter antar laptop" di tim 7 orang. Instalasi Docker Desktop sendiri (butuh WSL2 + restart) sengaja tidak dijalankan otomatis — itu aksi sistem yang harus dijalankan manual oleh tiap orang, lihat `docs/DOCKER.md`.

## 2026-11-19 — Restructure tim: 4 developer + 3 asset creator (bukan 7 developer)

**Keputusan**: dari 7 orang, 4 jadi developer (Dev 1 pegang `core`+`app`, Dev 2-4 masing-masing pegang 2 modul `feature_*`), 3 jadi asset creator penuh (Asset 1 ilustrasi, Asset 2 audio/VO, Asset 3 video/marketing & Play Store listing) — **tidak coding**. Detail di `docs/TEAM.md`, tugas konkret per orang di `docs/JOBS_BASE_MODEL.md` Job 6-8.

**Alasan**: kualitas app anak sangat bergantung ilustrasi/audio/video yang menarik, bukan skill yang otomatis dimiliki developer. Memaksa 7 orang semua coding 1 modul penuh tidak efisien kalau kekuatan tim sebagian besar di konten, bukan kode. Asset creator kerja lintas-modul (bukan per modul) karena jumlahnya lebih sedikit dari jumlah modul, dan bisa mulai dari style guide + `feature_angka` (pilot) duluan.

## 2026-11-19 — Tambah CLAUDE.md & docs/TASK_BOARD.md: entry point wajib untuk sesi AI baru

**Keputusan**: `CLAUDE.md` di root repo (otomatis dibaca Claude Code tiap sesi baru) jadi entry point wajib, mengarahkan ke urutan dokumen yang harus dibaca + cara klaim task di `docs/TASK_BOARD.md` sebelum mulai kerja (tulis status `Claimed` + commit kecil, supaya 2 orang/2 sesi AI tidak kerja task yang sama tanpa sadar).

**Alasan**: sebelumnya tidak ada mekanisme ini — kalau 7 orang (atau sesi AI berbeda) jalan paralel tanpa papan task bersama, risiko kerja dobel atau task ke-skip semakin tinggi seiring tim membesar.

## 2026-11-19 — Nama Dev 1 diisi: Bramantyo (tanpa title "Lead")

**Keputusan**: Dev 1 (pegang `core`+`app`) namanya **Bramantyo**. Atas permintaan eksplisit, title "Lead/Architect" dihapus dari semua dokumen — dia tetap pegang `core`+`app` secara teknis (titik integrasi semua modul), tapi tanpa label jabatan "Lead". Referensi "Dev 1 (Lead)" di `docs/TEAM.md`, `docs/JOBS_BASE_MODEL.md`, `docs/GIT_WORKFLOW.md`, `docs/PLAN_BASE_MODEL.md`, `.github/CODEOWNERS`, `docs/TASK_BOARD.md` diganti jadi "Bramantyo".

## 2026-11-19 — Klaim task jadi LANGKAH 0 wajib di setiap sesi/conversation baru

**Keputusan**: `CLAUDE.md` diperketat — klaim task di `docs/TASK_BOARD.md` sekarang jadi **langkah pertama mutlak** tiap kali sesi AI/conversation baru dibuka di repo ini, sebelum baca dokumen lain atau mulai kerja. Kalau task belum jelas dari instruksi user, sesi AI **wajib tanya dulu**, tidak boleh menebak. Commit klaim pakai format baku `claim: <nama task> — <nama orang>`, commit selesai `done: <nama task> — <nama orang>`, dan **push duluan** sebelum mulai kerja task-nya.

**Alasan**: sebelumnya "klaim task" cuma salah satu langkah di tengah daftar baca — user minta ini jadi gerbang wajib paling awal, supaya tidak mungkin ada sesi/orang yang mulai kerja tanpa tercatat di board, dan nama di PIC langsung pakai nama asli begitu diketahui (bukan "Dev 1"/"Asset 2" generik terus-terusan).

## 2026-11-19 — docs/ROLES.md + CI scope-check: tabrakan dicegah 3 lapis, bukan cuma aturan tertulis

**Keputusan**: tambah `docs/ROLES.md` yang mendefinisikan **folder/file persis** yang boleh/tidak boleh disentuh tiap peran (bukan cuma "modul mana" seperti di TEAM.md). Tambah `scripts/check_pr_scope.sh` + job `scope-check` di CI yang **otomatis gagal** kalau 1 PR menyentuh lebih dari 1 folder `packages/<modul>`. Juga didokumentasikan: admin repo perlu aktifkan GitHub branch protection "Require review from Code Owners" di Settings → Branches, supaya PR yang menyentuh folder orang lain **tidak bisa merge** tanpa approval pemilik folder itu.

**Pengecualian baru**: commit yang HANYA mengubah baris status di `docs/TASK_BOARD.md` (klaim/done) boleh push langsung ke `main`, supaya klaim task cepat terlihat orang lain — tidak perlu nunggu PR untuk sekadar update status.

**Alasan**: user minta jaminan konkret "tidak tabrakan", bukan cuma janji di dokumen. Jawabannya 3 lapis: (1) struktural — folder per peran nyaris tidak overlap, (2) koordinasi — klaim di TASK_BOARD sebelum kerja, (3) teknis — CODEOWNERS + branch protection + CI scope-check yang benar-benar **menolak** perubahan di luar scope, bukan cuma mengandalkan orang ingat aturan.

## 2026-11-19 — Lapis 3 (CI scope-check + branch protection) DIBATALKAN, balik ke 2 lapis

**Keputusan**: `scripts/check_pr_scope.sh` dan job `scope-check` di CI **dihapus**. Rekomendasi branch protection "Require review from Code Owners" juga dibatalkan. Tinggal 2 lapis: (1) struktural (folder per peran nyaris tidak overlap) + (2) koordinasi (klaim di TASK_BOARD sebelum kerja). `.github/CODEOWNERS` tetap ada tapi cuma untuk auto-assign reviewer, bukan gate yang blok merge. Aturan "jangan edit folder orang lain" dilonggarkan untuk **bug fix kecil yang urgent** — boleh langsung, asal PR terpisah + tag pemilik modulnya, tidak wajib tunggu approval.

**Alasan**: user khawatir gate otomatis (CI yang menolak PR lintas-modul, atau approval wajib dari code owner) bikin bug fix mendadak jadi lambat/susah ditangani. Kecepatan menangani bug dinilai lebih penting daripada penegakan teknis yang kaku — cukup andalkan struktur folder + disiplin klaim task, sama seperti sebelum `docs/ROLES.md` ditambah lapis 3.

## 2026-11-19 — `ProgressRepository` selesai (Job 1, Bramantyo)

**Keputusan/implementasi**: `packages/core/lib/src/services/progress_repository.dart` — `ChangeNotifier` + `shared_preferences`, simpan `GameResult` (list, di-serialize JSON per entry) dan flag `soundEnabled`. API: `init()` (wajib dipanggil sekali di `main()` sebelum `runApp`), `recordResult()`, `latestResultFor(gameId)`, `setSoundEnabled()`. `GameResult` ditambah `toJson`/`fromJson`. Ada unit test (`packages/core/test/progress_repository_test.dart`) yang verifikasi data survive "re-init" (simulasi app ditutup-buka).

**Belum**: `ParentalGateDialog`, wiring navigasi Home↔Settings, `SettingsScreen` — sisa checklist Job 1 di `docs/JOBS_BASE_MODEL.md`.

## 2026-11-19 — Tim ditambah 8 orang jadi 15 (5 dev + 3 asset/design), BUKAN role QA/UI-UX/DevOps/Compliance terpisah

**Konteks**: user minta tambah 8 orang. Draf pertama dari sesi AI memecahnya jadi role spesialis (QA Tester, UI/UX Designer, DevOps/Release Engineer, Privacy & Compliance Officer, Ilustrator B, Composer) — user **membatalkan** draf itu dan minta yang lebih sederhana: **5 orang coding fitur + 3 orang design (assets gambar/video/sound, fleksibel)**.

**Keputusan final**: 15 orang = 9 developer (Bramantyo `core`, Dev App baru `app`, 6 developer @ 1 modul `feature_*` masing-masing — Dev 2/3/4 lama + Dev Warna/Musik/Puzzle baru, dan 1 Dev Testing baru lintas-modul untuk test+bugfix) + 6 asset/design creator (Asset 1-3 lama tetap lead per jenis media, Asset 4-6 baru generalist fleksibel lintas gambar/video/sound, bukan dipaku 1 jenis media). Detail di `docs/TEAM.md`, `docs/ROLES.md`, `docs/JOBS_BASE_MODEL.md` (semua ditulis ulang).

**Alasan**: user menilai role non-coding terpisah (QA/UI-UX/DevOps/Compliance) menambah kompleksitas tanpa perlu — lebih suka tim lean yang isinya murni coding + konten, dengan kebutuhan testing/QA dilebur ke 1 dev khusus (Dev Testing, tetap nulis kode: test + fix bug langsung) daripada jadi jabatan pelapor-saja yang tidak coding.

**Konsekuensi yang dicatat, belum diselesaikan**: Privacy Policy & Google Play Families Policy (wajib sebelum submit ke Play Store untuk app anak) **belum ada pemegang jelas** karena role Compliance Officer dihapus dari struktur — dicatat di `docs/TEAM.md` & `docs/JOBS_BASE_MODEL.md` sebagai keputusan tertunda yang wajib diputuskan sebelum Fase 2 selesai.

## 2026-11-19 — Base model (Job 1, 2, 3) selesai ditulis: `ParentalGateDialog`, `SettingsScreen`+navigasi, `feature_angka` penuh

**Implementasi**:
- `ParentalGateDialog` (`packages/core/lib/src/widgets/parental_gate_dialog.dart`) — tahan tombol 3 detik (`GestureDetector` onTapDown/onTapUp + `AnimationController`), dipanggil lewat `ParentalGateDialog.show(context)`.
- `SettingsScreen` (`packages/app/lib/src/settings_screen.dart`) — toggle suara, sinkron ke `ProgressRepository.soundEnabled` + `SfxService.muted` + `AudioService.muted` (keduanya ditambah properti `muted`).
- `HomeMenu` (`packages/app/lib/main.dart`) — tombol Settings di AppBar, wajib lewat `ParentalGateDialog` dulu; mute state di-restore dari `ProgressRepository` saat `main()` start.
- `feature_angka` (`packages/feature_angka/lib/src/angka_screen.dart`) — implementasi penuh: 4 soal/sesi, pilihan 3 angka (1 benar + 2 pengecoh), feedback via `SfxService`, reward `StarRewardOverlay`, simpan `GameResult` via `ProgressRepository`. Pakai ikon placeholder (`Icons.favorite`) karena ilustrasi final (Asset 1, Job 10) belum ada.
- **Bug fix sekaligus**: `StarRewardOverlay` sebelumnya backdrop-nya (`Container` tanpa `Positioned.fill`/`SizedBox.expand`) tidak akan memenuhi layar kalau diletakkan di dalam `Stack` lain — ditemukan & diperbaiki saat implementasi `feature_angka`.
- **Robustness**: `SfxService.preload` dan `AudioService.playAsset` sekarang di-`try/catch` — kalau file asset belum ada (Asset creator belum upload), tidak crash, cuma no-op. Ini penting karena base model ditulis duluan sebelum asset final siap.

**Belum diverifikasi jalan saat ditulis**: sesi AI ini tidak punya Flutter SDK, jadi semua di atas **belum pernah di-`flutter run`** sungguhan. Siapa pun dengan Flutter SDK terpasang perlu jadi orang pertama yang `flutter pub get` + `flutter run` dan cek Definition of Done di `docs/PLAN_BASE_MODEL.md`.

## 2026-11-19 — Base model DIVERIFIKASI jalan: Flutter SDK diinstall & dipakai di sesi ini

**Yang dilakukan**: install Flutter SDK (clone `stable` branch, hasilnya Flutter 3.50.0 / Dart 3.14.0 — ini versi stable sungguhan di tanggal environment ini, bukan pre-release), lalu jalankan `flutter pub get`, `flutter analyze`, `flutter test`, dan `flutter build web` untuk `packages/app`. **Semua lolos.** Tidak bisa jalankan `flutter run` ke emulator Android (sandbox ini tidak punya Android SDK/emulator/GPU) — itu satu-satunya bagian Definition of Done yang masih perlu device/emulator asli.

**Bug nyata yang ketemu & diperbaiki saat verifikasi**:
1. `StarRewardOverlay` di `star_reward_overlay.dart` memakai `AppColors.sky` yang **tidak ada** (nama konstanta sebenarnya `accentAngka`) — `flutter analyze` langsung menangkap ini sebagai `undefined_getter`. Diperbaiki.
2. `const` list literal di confetti colors sempat invalid karena item di atas bukan constant — ikut terselesaikan begitu nama konstanta diperbaiki.

**Masalah infrastruktur (bukan bug kode, tapi konfigurasi project) yang ketemu & diperbaiki**:
1. **Melos 7+ pindah cara konfigurasi total**: `melos.yaml` terpisah **sudah tidak dibaca lagi** sejak Melos v7 — konfigurasi (termasuk daftar package & scripts) wajib ada di **root `pubspec.yaml`**, dengan Melos didaftarkan sebagai `dev_dependency` di sana (bukan `dart pub global activate melos` seperti yang kita tulis sebelumnya — itu cara lama/v6 ke bawah). Perbaikan: hapus `melos.yaml`, tambah `packages/pubspec.yaml` di root dengan field native Dart `workspace:` (daftar 8 package member) + key `melos:` (isi `scripts:` analyze/test/format) + `dev_dependencies: melos: ^8.10.1`.
2. **Field `workspace:` butuh Dart >=3.6** (native pub workspaces) — tiap pubspec.yaml member wajib tambah `resolution: workspace` sebagai **key top-level** (bukan di dalam blok `environment:` — ini sempat salah taruh dan bikin error membingungkan "does not have resolution: workspace" padahal sudah ada, karena salah lokasi). Semua 8 `pubspec.yaml` member sudah diperbaiki.
3. **Dockerfile & CI sebelumnya pin `ghcr.io/cirruslabs/flutter:3.24.3`** — versi ini TERLALU LAMA, Dart yang dibundel di bawah 3.6 sehingga **tidak mendukung pub workspaces** yang baru kita setup. Diganti ke `3.50.0` (versi yang benar-benar dipakai & terverifikasi di sesi ini). `.github/workflows/ci.yml` dan `Dockerfile` sudah diupdate, juga drop langkah `dart pub global activate melos` (tidak perlu lagi, Melos ke-fetch otomatis lewat `flutter pub get` sebagai dev_dependency lokal).
4. **Script Melos custom harus pakai `dart run melos exec`**, bukan `melos exec` langsung — karena Melos di sini local dev_dependency (tidak di-global-activate), binary `melos` belum tentu ada di PATH. Semua referensi command di `README.md`, `CONTRIBUTING.md`, `docs/DOCKER.md`, `docs/GIT_WORKFLOW.md`, `.github/PULL_REQUEST_TEMPLATE.md` diupdate ke `dart run melos run <nama>`.
5. **Folder `test/` kosong di 5 modul `feature_*` yang belum ada implementasinya** bikin `melos exec --dir-exists=test -- flutter test` gagal (folder ada tapi tanpa file test, Flutter menganggap ini error, bukan "skip"). Folder-folder itu tidak pernah ter-commit (empty dir, git tidak track), jadi ini cuma masalah di working copy sesi ini — dihapus. Ditambah 1 widget test baru untuk `feature_angka` (`angka_screen_test.dart`) sebagai bukti pola pilot benar-benar teruji.
6. **`flutter/material.dart` ditandai `deprecated_member_use` oleh Flutter 3.50 stable** (demi `package:material_ui` yang baru) — ini **nyata**, bukan artefak pre-release, tapi migrasi ke `material_ui` di luar scope base model. Ditambahkan `analyzer.errors.deprecated_member_use: ignore` di `analysis_options.yaml` tiap package (baru dibuat untuk `core` + 6 `feature_*`, yang `app` sudah ada dari `flutter create` ditambah override yang sama). **Catatan untuk Fase 2+**: migrasi ke `material_ui` perlu direncanakan, jangan dibiarkan selamanya cuma di-ignore.

**Juga dilakukan**: `flutter create . --platforms=web` untuk `packages/app` (platform `android`/`ios` belum, butuh Android SDK/Xcode yang tidak ada di sandbox ini) — menghasilkan `web/`, `test/widget_test.dart` (diganti dengan smoke test asli untuk `HomeMenu`, bukan template counter default).

**Kesimpulan**: base model sekarang bukan cuma "kode sudah ditulis", tapi **terverifikasi benar-benar bisa di-build & lolos semua automated check**. Satu-satunya yang masih perlu manusia dengan device/emulator Android asli: interaksi sentuhan sungguhan (`ParentalGateDialog` tahan 3 detik, tap target di `feature_angka`, dengar SFX setelah Asset 2 upload file asli).

## 2026-11-19 — RESET: semua kode Flutter/Dart dihapus, mau revisi bahasa pemrograman

**Keputusan**: user minta hentikan build APK yang sedang jalan, lalu **hapus semua file kecuali `.md`** dari repo — artinya seluruh `packages/` (core + 6 `feature_*` + app), `pubspec.yaml` root, `Dockerfile`, `docker-compose.yml`, `.github/workflows/ci.yml`, `.github/CODEOWNERS`, `.gitignore`, `.dockerignore`, folder asset `marketing/` (kecuali `marketing/README.md`) — **dihapus dari git**. Yang tetap ada: semua dokumen `docs/`, `obsidian-vault/`, `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`, template GitHub (`.md`).

**Alasan**: user mau ganti bahasa pemrograman (belum diputuskan penggantinya saat entri ini ditulis) — base model Flutter/Dart yang baru diverifikasi jalan (lihat entri di atas) sengaja dibuang semua, bukan disimpan sebagai referensi, supaya repo bersih untuk mulai dari nol dengan stack baru.

**Yang TIDAK ikut terhapus (di luar repo ini, di komputer sesi AI)**: instalasi Flutter SDK (`C:\Users\User\flutter`) dan Android SDK (`C:\Users\User\android-sdk`) yang sempat di-install untuk verifikasi — dibiarkan, tidak relevan lagi kalau bahasa pemrograman ganti, tapi tidak mengganggu karena di luar folder repo.

**Belum diputuskan**: bahasa/stack pengganti. Begitu dipilih, `docs/ARCHITECTURE.md`, `docs/LIBRARIES.md`, `docs/DOCKER.md`, `docs/UI_UX_DESIGN.md` (bagian implementasi), dan `docs/JOBS_BASE_MODEL.md` perlu direvisi menyesuaikan — isinya saat ini masih bicara konsep Flutter/Dart (package, pubspec, widget) yang sudah tidak relevan untuk kode, meski prinsip pembagian modul/tim kemungkinan masih bisa dipakai ulang.

## 2026-11-19 — Stack baru ditentukan: GODOT 4 (GDScript)

**Keputusan**: user memilih **Godot** sebagai pengganti Flutter. Ini juga membalik keputusan 2026-11-19 sebelumnya ("Godot dipertimbangkan, tetap pakai Flutter") — alasan "scaffold Flutter sudah jalan" di keputusan itu sudah tidak relevan karena Flutter sudah dihapus total duluan.

**Implementasi (base model ditulis ulang dari nol)**:
- `project.godot` — config utama, `[autoload]` untuk `ProgressRepository`/`SfxService`/`AudioService`.
- `core/scripts/`: `app_colors.gd` (palet, konstanta `UPPER_CASE` gaya GDScript), `progress_repository.gd` (autoload, pakai `ConfigFile` bawaan — setara `shared_preferences` tapi tanpa plugin), `sfx_service.gd` + `audio_service.gd` (2 `AudioStreamPlayer` terpisah, SFX vs musik/VO), `parental_gate_dialog.gd` (tahan tombol 3 detik, dibangun programatik lewat kode bukan node tree manual di `.tscn`), `big_round_button.gd`.
- `core/scenes/`: `BigRoundButton.tscn`, `StarRewardOverlay.tscn` (confetti via `CPUParticles2D`, bukan particle custom), `ParentalGateDialog.tscn` — semua scene minimal (root node + script), UI sesungguhnya dibangun di `_ready()` lewat kode, bukan di-drag manual di editor (lebih aman untuk ditulis sesi AI tanpa editor, risiko kesalahan `.tscn` tangan jadi minimal).
- `scenes/home.gd` + `Home.tscn`, `scenes/settings.gd` + `Settings.tscn` — menu utama + pengaturan, pola sama dengan `HomeMenu`/`SettingsScreen` versi Flutter tapi pakai `change_scene_to_file` bukan `Navigator.push`.
- `features/feature_angka/angka.gd` + `Angka.tscn` — pilot, logic sama (4 soal, 3 pilihan, reward, simpan progres) ditulis ulang di GDScript. Pakai ikon teks "♥" sebagai placeholder visual (bukan `Icons.favorite` Flutter lagi).
- 5 modul lain (`feature_warna/hewan/musik/mewarnai/puzzle`) — placeholder scene (label + tombol kembali), sama seperti versi Flutter.
- `docs/ARCHITECTURE.md`, `docs/LIBRARIES.md`, `docs/DOCKER.md`, `docs/UI_UX_DESIGN.md`, `docs/TEAM.md`, `docs/ROLES.md`, `docs/JOBS_BASE_MODEL.md`, `docs/PLAN_BASE_MODEL.md`, `docs/TASK_BOARD.md`, `docs/AI_WORKFLOW.md`, `docs/GIT_WORKFLOW.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `README.md`, `.github/CODEOWNERS`, `.github/workflows/ci.yml`, PR/issue template — semua diupdate dari path/istilah Flutter (`packages/`, `pubspec.yaml`, widget) ke Godot (`core/`, `scenes/`, `features/`, scene/script, autoload).

**Belum tercover, perlu library/fitur Godot yang setara dicari ulang nanti**:
- `docs/LIBRARIES.md` versi Flutter sempat merencanakan `soundpool`, `confetti`, `flutter_animate`, `google_fonts`, `flutter_svg`, `mocktail` — ditulis ulang: hampir semua kebutuhan itu **sudah built-in Godot** (lihat `docs/LIBRARIES.md` baru), jadi tidak perlu addon pengganti satu-satu.
- Testing: `mocktail`/`flutter_test` tidak ada penggantinya langsung — kalau Dev Testing (Job 9) perlu automated test, addon [GUT](https://github.com/bitwes/Gut) jadi pilihan pertama, belum dipasang.
- CI/Docker: `.github/workflows/ci.yml` ditulis pakai image `barichello/godot-ci` dan command `godot4 --headless --quit-after 10`, **tapi belum pernah dijalankan/diverifikasi** — beda dari versi Flutter yang sempat benar-benar dicoba jalan (lihat entri "Flutter SDK diinstall & dipakai di sesi ini"). Perlu dicek ulang begitu Godot terpasang.

**Belum diverifikasi sama sekali**: tidak ada instalasi Godot di sesi ini (beda dari Flutter yang sempat diinstall penuh + Android SDK). Semua kode di atas **belum pernah dibuka di Godot Editor**, jadi mungkin ada typo/error GDScript atau `.tscn` yang salah format yang belum ketahuan. Siapa pun yang install Godot 4 duluan: tolong buka project dan laporkan error pertama yang ketemu.

## 2026-11-19 — Godot DIVERIFIKASI jalan: install Godot 4.7.2, semua scene lolos headless

**Yang dilakukan**: download & extract Godot 4.7.2 stable (standard, non-Mono, Windows) dari rilis resmi GitHub `godotengine/godot`. Jalankan `--headless --path . --import` (import project, cek semua `class_name` ter-register tanpa error) lalu jalankan tiap scene satu-satu headless (`--headless --path . <scene> --quit-after 1`): `scenes/Home.tscn`, `scenes/Settings.tscn`, `features/feature_angka/Angka.tscn`, dan 5 scene placeholder (`Warna`, `Hewan`, `Musik`, `Mewarnai`, `Puzzle`). **Semua exit code 0, tanpa error GDScript/parse.**

**Bug nyata yang ketemu & diperbaiki**: 5 `.tscn` placeholder (`feature_warna/hewan/musik/mewarnai/puzzle`) salah path `ext_resource` ke script-nya — tertulis `res://feature_xxx/nama.gd`, seharusnya `res://features/feature_xxx/nama.gd` (kurang folder `features/`). Ini bug dari generate-script bash (heredoc loop) yang dipakai sesi sebelumnya, ketangkap langsung begitu scene dijalankan (`ERROR: Attempt to open script ... File not found`). `feature_angka/Angka.tscn` dan `scenes/Home.tscn`/`Settings.tscn` tidak kena bug ini karena ditulis manual satu-satu, bukan lewat loop.

**CI diperbaiki juga**: `.github/workflows/ci.yml` sebelumnya pakai binary `godot4` yang salah — dicek ke [contoh resmi repo godot-ci](https://github.com/abarichello/godot-ci/blob/master/.github/workflows/godot-ci.yml), binary yang benar di image `barichello/godot-ci` adalah `godot` (tanpa angka). Step CI diupdate jadi loop buka semua 8 scene headless (bukan cuma main scene), supaya kalau ada modul lain yang kena bug serupa (path salah), CI langsung gagal — tidak nunggu ketahuan manual seperti kasus di atas.

**Belum diverifikasi**: export APK/executable sungguhan (butuh `export_presets.cfg` yang belum disiapkan, dan Android export template kalau target Android — lihat Job 1 di `docs/JOBS_BASE_MODEL.md`). Interaksi sentuhan nyata (parental gate tahan 3 detik, tap target) juga belum dicoba — headless run cuma membuktikan tidak ada error saat load/`_ready()`, bukan membuktikan gameplay-nya terasa benar.

## 2026-11-19 — Tim di-ramping dari 15 orang (9 dev + 6 asset) jadi 8 orang (5 dev + 3 asset)

**Keputusan**: user minta ulang struktur tim jadi lebih kecil — awalnya diminta "4 dev + 4 asset", lalu diklarifikasi jadi **5 developer + 3 asset/design creator = 8 orang total**, menggantikan struktur 15 orang sebelumnya.

**Struktur baru**:
- **Bramantyo** — `core/` + `scenes/` digabung jadi 1 orang (role "Dev App" terpisah dihapus).
- **Dev 2** — `feature_angka` (pilot) + `feature_warna` (2 modul, bukan 1).
- **Dev 3** — `feature_hewan` + `feature_musik` (2 modul).
- **Dev 4** — `feature_mewarnai` + `feature_puzzle` (2 modul).
- **Dev Testing** — tetap dipertahankan sebagai role coding terpisah lintas-modul (satu-satunya tambahan dari struktur 7-orang paling awal sebelum ekspansi ke 15).
- **Asset 1-3** — ilustrasi/audio/video, generalist Asset 4-6 (dari ekspansi 15 orang) **dihapus**.

**Alasan**: struktur 15 orang (QA Tester/UI-UX Designer/DevOps/Compliance Officer terpisah, Asset 4-6 generalist, Dev App terpisah dari Bramantyo) dirasa menambah koordinasi tanpa menambah kecepatan sebanding untuk fase base model — balik ke ukuran yang lebih ramping, cukup jauh, mendekati struktur 7-orang paling awal (Dev 2-4 masing-masing 2 modul, Asset 1-3 generalist per jenis media), ditambah 1 pelajaran yang tetap dipertahankan dari eksperimen 15-orang: **Dev Testing sebagai role coding terpisah**.

**Yang diupdate**: `docs/TEAM.md`, `docs/ROLES.md`, `.github/CODEOWNERS`, `docs/JOBS_BASE_MODEL.md` (job direnumbering 1-8, bukan 1-15 lagi), `docs/TASK_BOARD.md`, `docs/PLAN_BASE_MODEL.md` ("Urutan kerja"), serta semua mention "15 orang" di `README.md`, `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/AI_WORKFLOW.md`, `docs/GIT_WORKFLOW.md`, `docs/DOCKER.md`, `CONTRIBUTING.md`, `obsidian-vault/Project Overview.md`. Kode (`core/`, `scenes/`, `features/*`) **tidak berubah** — restructure ini murni dokumen pembagian tim, bukan kode.

## 2026-11-19 — `feature_angka` DIMAINKAN SUNGGUHAN (bukan cuma headless) — semua lolos

**Yang dilakukan**: atas permintaan user, buka Godot Editor via terminal (`Godot_v4.7.2-stable_win64.exe --path . -e`, GUI, bukan `--headless`) dan jalankan scene `features/feature_angka/Angka.tscn` berdiri sendiri (`--path . features/feature_angka/Angka.tscn`, tanpa `--headless`) sebagai window game terpisah di desktop Windows. User lalu **benar-benar klik tombol** menjawab 4 soal, semua benar.

**Hasil**: reward bintang + confetti (`StarRewardOverlay`) muncul seperti dirancang. Dicek file save `C:\Users\User\AppData\Roaming\Godot\app_userdata\Bayi GuguGaga\progress.cfg` — **terisi 4 entri `GameResult` nyata** dengan timestamp asli (bukan simulasi/dugaan): `game_id: "feature_angka"`, `stars_earned: 3` tiap entri.

**Ini verifikasi paling kuat sejauh ini** — sebelumnya cuma headless (`exit 0`, tidak crash saat load) yang membuktikan tidak ada error GDScript, tapi tidak membuktikan gameplay-nya BENAR. Sekarang: logic soal, deteksi jawaban benar, `SfxService.play(null)` placeholder tidak crash, `StarRewardOverlay` dengan `CPUParticles2D` render dengan benar, dan `ProgressRepository.record_result()` + `ConfigFile.save()` benar-benar menulis ke disk — semua terbukti jalan.

**Side-effect**: Godot Editor otomatis menulis ulang `project.godot` saat pertama dibuka (tambah section `[animation]`, ubah `config/features` dari `"4.3"` ke `"4.7"` menyesuaikan versi editor 4.7.2) — ini perilaku normal Godot, bukan perubahan manual, dibiarkan apa adanya.

**Masih belum dicoba**: navigasi lewat `Home.tscn` (sesi ini langsung buka scene `Angka.tscn` berdiri sendiri, bukan lewat tombol di Home), `ParentalGateDialog`/Settings secara sentuhan asli, toggle suara (belum ada SFX asli untuk didengar), export APK, dan testing di device Android asli (baru di desktop Windows).

## 2026-11-20 — Generate image AI GAGAL (butuh plan berbayar), diganti ikon vector lewat kode

**Yang dicoba**: user minta dibuatkan assets (app icon + ikon 6 tile Home). Sesi AI ini punya akses tool generate image (`generate_image_batch`, model `gpt_image_2_6`), sudah dicek estimasi biaya (0.25 kredit/gambar) — tapi **submit gagal semua**: `"Requires basic plan or higher"`. Dicoba juga `use_free_gens: true`, ditolak juga (`"free generations can be spent from the ChatGPT (OpenAI) Higgsfield connector only"`). Jadi generate image AI **tidak tersedia** di akun/plan ini sekarang.

**Keputusan user**: daripada tunggu upgrade plan atau Asset 1 (illustrator asli), bikin placeholder yang lebih baik dari teks polos — **digambar langsung lewat kode Godot** (`draw_circle`/`draw_rect`), gratis & langsung jadi.

**Implementasi**: `core/scripts/module_icon.gd` — `class_name ModuleIcon`, `Control` dengan `_draw()` custom per `kind` (angka/warna/hewan/musik/mewarnai/puzzle), semua bentuk dasar (titik, bulatan warna, muka sederhana, not musik, krayon, grid puzzle) — bukan ilustrasi asli, murni placeholder vektor abstrak. `scenes/home.gd` diupdate: tiap tile sekarang punya warna latar sesuai aksen modul (`docs/UI_UX_DESIGN.md`) + `ModuleIcon` di tengah + label nama di bawah (sebelumnya cuma tombol teks polos).

**Diverifikasi**: setelah re-import (`--headless --import`, perlu supaya `class_name ModuleIcon` ter-register), `scenes/Home.tscn` lolos headless (`exit 0`) dan dicoba dibuka visual (non-headless) via terminal — user konfirmasi tile-nya muncul dengan warna & ikon yang benar.

**Catatan untuk tim**: ini TETAP placeholder, bukan pengganti Job 6 (Asset 1 — ilustrasi asli). `obsidian-vault/Specs/style-guide-ilustrasi.md` dan ilustrasi final tetap perlu dibuat manusia (atau AI image gen begitu plan-nya di-upgrade) — `ModuleIcon` cuma supaya Home tidak kosong/polos sampai itu selesai.

## 2026-11-20 — Tambah docs/WORK_BREAKDOWN.md: tiap job dipecah jadi bagian detail

**Keputusan**: user minta job di `docs/JOBS_BASE_MODEL.md` dipecah lebih rinci jadi bagian-bagian kecil dengan langkah konkret (bukan cuma checklist bullet umum). Dibuat dokumen baru `docs/WORK_BREAKDOWN.md` (pelengkap, bukan pengganti `JOBS_BASE_MODEL.md`) — tiap Job 1-8 dipecah jadi "Part X.Y" dengan tujuan, langkah, input/output, dan kriteria selesai eksplisit.

**Isi utama**: Part 1.1-1.6 (Bramantyo — setup Android export template, `export_presets.cfg`, CI export job, verifikasi navigasi Home, verifikasi ParentalGateDialog/Settings sentuhan asli, keputusan Privacy Policy), Part 2.x-4.x (spek 5 modul lain), Part 5.x (Dev Testing — QA checklist, evaluasi GUT, test device asli), Part 6.x-7.x (Asset 1/2 — style guide, ilustrasi, SFX/VO, integrasi ke kode), Part 8.x (Asset 3 — riset, storyboard, listing, rekam demo).

**Alasan**: sebagian besar Job 1-2 sudah selesai & terverifikasi (lihat entri sebelumnya), tapi sisa kerjaannya (export APK, verifikasi interaktif Home/Settings, keputusan Privacy Policy) belum punya langkah konkret di mana pun — `WORK_BREAKDOWN.md` mengisi itu supaya siapa pun (manusia atau sesi AI baru) bisa langsung eksekusi tanpa perlu tanya "caranya gimana".

## 2026-11-20 — Part 1.1-1.3 SELESAI: APK Android debug berhasil di-export sungguhan

**Yang dilakukan** (pakai `docs/PROMPT_BRAMANTYO.md`, eksekusi lewat terminal, tanpa klik GUI sama sekali):

1. **Part 1.1 — Export template**: download `Godot_v4.7.2-stable_export_templates.tpz` (1.28GB) dari rilis resmi `godotengine/godot`. Download pertama (timeout 180s) **terpotong jadi 644MB** — gagal, bukan corrupt file acak, sekadar belum lengkap. Download ulang dengan timeout 540s, curl exit 0, ukuran pas 1.28GB. Extract & pindahkan ke `%APPDATA%\Godot\export_templates\4.7.2.stable\`.

2. **Part 1.2 — `export_presets.cfg`**: ditulis manual, formatnya diambil dari contoh resmi `abarichello/godot-ci/test-project/export_presets.cfg` (bagian preset Android) supaya tidak menebak-nebak field yang Godot 4 harapkan. `package/unique_name="com.gugugaga.bayigugugaga"`.
   - **Percobaan export pertama GAGAL**: `"ETC2/ASTC texture compression is required for Android export"`. Fix: tambah `textures/vram_compression/import_etc2_astc=true` di `[rendering]` `project.godot`.
   - **Percobaan kedua BERHASIL**: `godot --headless --export-debug "Android" build/android/app-debug.apk` — APK ter-sign pakai debug keystore (Godot otomatis temukan Android SDK di `%LOCALAPPDATA%\Android\Sdk`, bukan yang di-install manual sebelumnya di `C:\Users\User\android-sdk` — ada 2 instalasi SDK di komputer ini, Godot pakai yang terdaftar di Editor Settings). File `app-debug.apk` ~27MB.
   - `export_presets.cfg` **sengaja dikeluarkan dari `.gitignore`** (sebelumnya di-ignore dari setup awal) — aman di-commit karena cuma pakai debug keystore, tidak ada secret. `build/` (folder output APK) ditambahkan ke `.gitignore` sebagai gantinya.

3. **Part 1.3 — Job export di CI**: `.github/workflows/ci.yml` ditambah job `export-debug-apk`, image di-pin `barichello/godot-ci:4.7.2` (dicek tag-nya ada via Docker Hub API, sama dengan versi lokal). **Belum diverifikasi jalan sungguhan di GitHub Actions** — baru ditulis ikut pola resmi + terverifikasi lokal di Windows, CI jalan di Linux container, beda environment.

**Kesimpulan**: base model sekarang **punya file APK Android asli**, bukan cuma kode yang lolos headless. Ini maju signifikan dari status sebelumnya. **Belum**: install APK ke device/emulator Android asli dan coba jalan (baru sampai tahap file APK terbentuk & ter-sign), dan verifikasi CI export job di GitHub Actions sungguhan.

## 2026-11-20 — `ParentalGateDialog` diganti total: dari "tahan tombol 3 detik" jadi soal tambah + keypad angka

**Konteks**: user mencoba Part 1.4-1.5 secara interaktif (navigasi Home + gate) — navigasi Home↔game↔Home **berhasil benar**. Untuk parental gate, user minta mekanismenya diganti jadi "seperti pertanyaan" (soal angka, input jawaban) — ditanya detailnya, user pilih: **soal tambah sederhana** ("4 + 5 = ?") dengan **keypad angka di layar** untuk input jawaban, **mengganti sepenuhnya** mekanisme tahan-tombol 3 detik (bukan tambahan).

**Implementasi**: `core/scripts/parental_gate_dialog.gd` ditulis ulang total — hapus `ProgressBar`/hold-timer, ganti jadi: 2 angka acak (2-9) ditampilkan sebagai soal, keypad 0-9 + tombol ⌫ (hapus) + ✓ (konfirmasi) dibangun lewat `GridContainer`, label jawaban yang terupdate tiap digit ditekan. Jawaban salah → **soal baru digenerate** (bukan cuma "coba lagi" soal yang sama) supaya tidak bisa ditembus tebak-tebakan brute force oleh anak. `signal passed`/`cancelled` tetap sama, jadi `scenes/home.gd` tidak perlu diubah sama sekali — bukti manfaat desain signal-based yang sudah dipakai dari awal.

**Diverifikasi**: headless re-import + run `Home.tscn` lolos (`exit 0`), dan dibuka visual via terminal untuk user coba sentuhan asli — **menunggu konfirmasi hasil tesnya** (akan dicatat di entri berikutnya kalau ada temuan).

**Yang diupdate**: `docs/JOBS_BASE_MODEL.md`, `docs/PLAN_BASE_MODEL.md`, `docs/WORK_BREAKDOWN.md` — semua mention "tahan tombol 3 detik" diganti jadi "soal tambah + keypad angka".

## 2026-11-20 — Home di-redesign total: tombol "▶ Play" tengah + mode acak infinite + `GameFlow`

**Konteks**: user konfirmasi "sudah bagus" untuk perubahan `ParentalGateDialog` (entri sebelumnya), lalu minta Home diganti: dari grid 6 tile langsung tampil, jadi 1 tombol "▶ Play" besar di tengah. Ditanya detail perilaku Play lewat AskUserQuestion, user pilih **"Minigame acak infinite"** — selesai 1 sesi, lanjut otomatis ke mini-game acak lain (bukan balik ke Home). User lalu minta seluruh plan terkait (termasuk polish lain) dikerjakan sekaligus: **"kerjakan 1 persatu, secara detail dan menyeluruh"**.

**Implementasi** (detail lengkap di `docs/WORK_BREAKDOWN.md` Part 1.7):
- Autoload baru `GameFlow` (`core/scripts/game_flow.gd`) — satu sumber kebenaran katalog game (field `implemented` per modul, cuma `feature_angka` yang `true`), navigasi (`goto_scene` dengan fade hitam 0.15s in/out + debounce 600ms anti-klik-ganda), dan mode infinite (`start_random_game`/`start_specific_game`/`finish_game_session`/`go_home`).
- `scenes/home.gd` ditulis ulang: "▶ Play" tengah (masuk mode acak infinite), "Pilih Game" sekunder (grid manual, tersembunyi default, 1 sesi lalu balik Home), dekorasi background sederhana (lingkaran transparan kode, bukan ilustrasi asli).
- `scenes/splash.gd` + `Splash.tscn` baru — jadi `run/main_scene`, splash ~1.2s sebelum Home.
- Tombol darurat 🏠 (selalu terlihat) ditambah di `feature_angka` — **wajib ditiru** di 5 modul lain begitu dikerjakan, karena mode infinite tidak otomatis balik Home.
- Semua `get_tree().change_scene_to_file(...)` manual (6 `feature_*.gd` + `settings.gd` + reward callback) diganti lewat `GameFlow`.

**Bug ditemukan & diperbaiki**: `GameFlow._ready()` awalnya add_child synchronous ke `get_tree().root` untuk fade layer → error "Parent node is busy setting up children" di SEMUA scene saat headless-verify (tree root masih sibuk instansiasi main scene bersamaan waktu autoload `_ready()` jalan). Fix: pakai `add_child.call_deferred(...)`. Pola ini dicatat sebagai komentar di kode itu sendiri supaya tidak terulang kalau ada autoload lain yang perlu nambah node ke root.

**Diverifikasi**: re-import (`godot --headless --import`) supaya autoload baru terdaftar, lalu semua scene di-run headless (`--quit-after 1`) satu-satu — semua lolos `exit 0` setelah fix bug di atas. App juga dijalankan non-headless (window sungguhan) untuk user coba interaktif, dengan checklist 4 poin (Play → feature_angka, tombol 🏠 darurat, lanjut otomatis setelah reward karena infinite, toggle "Pilih Game"). **Hasil test interaktif ini belum dikonfirmasi user saat entri ini ditulis** — commit/push tetap dilakukan sekarang karena seluruh perubahan sudah headless-verified dan merupakan unit kerja yang lengkap; kalau user melaporkan bug dari test, akan jadi entri/perbaikan baru.

**Diupdate juga**: `docs/ARCHITECTURE.md` (GameFlow ditambah ke daftar autoload), `docs/UI_UX_DESIGN.md` (diagram information architecture ditulis ulang, bullet transisi scene ditambah), `docs/PLAN_BASE_MODEL.md` (scope App shell diupdate), `docs/WORK_BREAKDOWN.md` (Part 1.7 baru, Part 1.4 ditandai superseded), `docs/TASK_BOARD.md` (baris baru, status Done).

## 2026-11-20 — Privacy Policy & Play Families Policy: Bramantyo pegang

**Keputusan**: `docs/TEAM.md` baris "belum ada pemegang jelas" diisi — **Bramantyo** pegang Privacy Policy & Google Play Families Policy, rangkap dengan infra/release manager yang sudah dia pegang (export APK, CI, koordinasi listing dengan Asset 3). Ditanya ke user lewat AskUserQuestion (opsi: Bramantyo / Asset 3 / orang baru), user pilih Bramantyo.

**Catatan**: ini baru keputusan **siapa pegang**, bukan dokumen Privacy Policy/Play Families Policy itu sendiri — draftnya masih task terpisah (`docs/WORK_BREAKDOWN.md` Part 1.6), wajib ada sebelum submit Play Store.

## 2026-11-20 — Framing akhir sesi: "keberhasilan + pindah game", bukan "menang/kalah"

**Keputusan**: user tegaskan 1 aturan tambahan untuk prinsip #4 (`docs/UI_UX_DESIGN.md`, "tidak ada game over yang menghukum") — akhir 1 sesi mini-game **tidak boleh** dibahasakan sebagai menang/kalah di mana pun (teks UI, komentar kode, nanti SFX/VO). Yang benar: tampilkan **keberhasilan** (bintang + confetti di `StarRewardOverlay`) lalu **perpindahan ke permainan lain** (tombol "Lanjut" → `GameFlow.finish_game_session()`), konsisten dengan mode "Play acak infinite" yang sudah ada (lihat entri 2026-11-20 sebelumnya tentang redesign Home).

**Implementasi**: komentar di `core/scripts/star_reward_overlay.gd` yang sebelumnya bilang `"rasa menang"` diganti jadi "rasa keberhasilan" + catatan eksplisit bukan framing menang/kalah. Tidak ada teks UI yang perlu diubah (overlay sudah netral: bintang + tombol "Lanjut", tidak ada kata "menang"/"kalah" di mana pun sebelumnya) — jadi ini lebih ke **menegaskan aturan untuk modul-modul lain** yang belum dikerjakan (Warna/Hewan/Musik/Mewarnai/Puzzle), supaya developernya nanti tidak menulis "Kamu Menang!"/"Kamu Kalah" waktu bikin reward/fail state sendiri.

## 2026-11-20 — Sistem responsive canvas/UI: `[display]` stretch belum pernah dikonfigurasi

**Konteks**: user coba main prototype di device nyata, lapor "UI kececeran" (layout berantakan) + "banyak tombol tidak bisa diklik" antara HP dan tablet. Dicek `project.godot` — ternyata **tidak ada section `[display]` sama sekali** sejak awal base model, jadi Godot pakai default: `window/stretch/mode="disabled"` (viewport mentah 1:1 ke resolusi device, tidak ada scaling konsisten) dan orientasi tidak dikunci (`sensor`, bisa rotasi ke landscape) — padahal semua scene di app ini didesain vertikal (`VBoxContainer` full-anchor). Kombinasi "tidak ada base resolusi" + "orientasi bisa landscape" itulah sumber UI berantakan & tombol yang posisinya tidak konsisten antar device (bukan bug per-scene, tapi hilang 1 config project-level yang sejak awal belum pernah disentuh).

**Keputusan/fix**: tambah `[display]` di `project.godot`:
- `window/size/viewport_width=720`, `window/size/viewport_height=1280` — resolusi desain acuan (portrait HP umum). Semua angka piksel di kode (`custom_minimum_size`, dll) dihitung relatif ke ini.
- `window/stretch/mode="canvas_items"` + `window/stretch/aspect="expand"` — scale seluruh UI 2D secara uniform ke resolusi device asli (HP kecil maupun tablet besar), termasuk pemetaan koordinat sentuh/klik ikut ter-scale otomatis (ini kemungkinan jadi akar "tombol tidak bisa diklik": tanpa stretch mode, Godot tidak menjamin pemetaan 1:1 yang konsisten kalau device aspect ratio beda jauh dari asumsi default 1152x648).
- `window/handheld/orientation="portrait"` — kunci portrait, konsisten dengan prinsip #8 `docs/UI_UX_DESIGN.md` yang dari awal sudah mensyaratkan ini tapi belum pernah diimplementasikan.

**Diverifikasi**: `godot --headless --path . --import` lalu semua 9 scene (`Splash`, `Home`, `Settings`, 6 `feature_*`) di-run headless `--quit-after 1` — semua lolos `exit 0`, tidak ada error baru.

**Belum**: belum dites sentuhan asli di device/emulator Android sungguhan (baru headless) — perlu re-export APK (`docs/WORK_BREAKDOWN.md` Part 1.1-1.3) dan install ulang untuk konfirmasi fix ini benar-benar menyelesaikan laporan user. `ParentalGateDialog` (card ter-center, tumbuh sesuai konten) belum dikasih `ScrollContainer` fallback untuk device super pendek — kalau masih ada laporan keypad kepotong setelah fix ini, itu langkah berikutnya.

## 2026-11-20 — Bug ditemukan & diperbaiki: UI `ParentalGateDialog` ("Mode Orang Tua") kolaps

**Laporan user**: "mode orang tua uinya ancur" — soal tambah + keypad numpuk/berantakan saat dibuka.

**Akar masalah**: `core/scripts/parental_gate_dialog.gd` nge-center kartu (`PanelContainer`) pakai anchor 1 titik (`anchor_left=anchor_top=anchor_right=anchor_bottom=0.5`) tanpa `offset` apa pun. Di Godot, Control baru defaultnya offset `(0,0,0,0)` — jadi rect-nya benar-benar kolaps ke size `(0,0)` di titik tengah, bukan auto-membesar sesuai isi. Semua anak (judul, soal, keypad 3x4, tombol Batal) numpuk di satu titik ber-size nol → tampil "ancur". Ini **pre-existing** dari waktu `ParentalGateDialog` ditulis ulang (ganti dari tahan-tombol ke soal tambah), baru ketahuan sekarang karena test interaktif sebelumnya cuma cover Play/Home/infinite mode, bukan buka Settings.

**Fix**: ganti jadi `CenterContainer` full-rect (`anchor_right/bottom=1.0`) membungkus `PanelContainer` — `CenterContainer` otomatis center-kan child sesuai `minimum_size` aslinya, tanpa perlu hitung offset manual. Pola ini (anchor-titik tanpa offset untuk "center" sebuah Container) dicatat sebagai jebakan umum Godot — kalau nanti ada dialog serupa di modul lain, pakai `CenterContainer`, jangan tiru pola lama.

**Diverifikasi**: headless re-run `scenes/Settings.tscn` & `scenes/Home.tscn` — tidak ada error baru. Belum dites visual sentuhan asli — perlu konfirmasi user begitu dicoba lagi.

## 2026-11-20 — Job 7 (Audio/VO): nama asli "Farel" diketahui, sinkron ke semua dokumen

**Konteks**: Farel (anggota tim, commit langsung `f58adf1`) update `docs/JOBS_BASE_MODEL.md` ganti label "Job 7 (Asset 2)" jadi "Job 7 (Farel)" — sesuai aturan `CLAUDE.md` LANGKAH 0 kalau nama asli sudah diketahui, pakai nama asli bukan placeholder generik "Asset 2" terus-terusan.

**Yang disinkronkan** (sesi ini, melanjutkan 1 baris yang Farel ubah): `docs/TEAM.md` (baris #7), `docs/TASK_BOARD.md` (PIC "SFX dasar" + "VO angka 1-5"), `docs/WORK_BREAKDOWN.md` (heading Job 7 + Part 7.3), `docs/PLAN_BASE_MODEL.md` (2 mention). `docs/MASTER_PROMPT.md` **sengaja tidak diubah** — itu template role untuk orang baru pilih saat mulai sesi ("Asset 2 - Audio/VO" di sana adalah nama ROLE, bukan nama orang). Entri Decisions Log lama yang sudah menyebut "Asset 2" **tidak diedit** (append-only, sesuai aturan `CLAUDE.md`).

## 2026-11-20 — Draft Privacy Policy & Play Families Policy ditulis

**Keputusan user**: lanjutkan kerja Bramantyo (Part 1.6) ke langkah berikutnya — tulis draft dokumennya, bukan cuma keputusan siapa yang pegang.

**Isi draft** (`docs/PRIVACY_POLICY.md`): rangkuman jujur apa adanya sesuai kode yang sudah ada — app 100% offline, tidak ada SDK iklan/analytics/login pihak ketiga (dicek silang ke `docs/LIBRARIES.md`, tidak ada yang mengirim data keluar device), tidak ada permission Android khusus (`export_presets.cfg` `permissions/custom_permissions` kosong), progres cuma lokal lewat `ProgressRepository`/`ConfigFile`. Bagian kepatuhan Google Play Families Policy menautkan ke mekanisme yang sudah ada di kode: `ParentalGateDialog` (gate sebelum ke Settings) dan prinsip-prinsip `docs/UI_UX_DESIGN.md` (tidak ada iklan/IAP, tidak ada game-over menghukum, tidak ada media sosial/chat).

**Belum**: dokumen ini **belum dipublikasikan ke URL publik** (field `[ISI: ...]` kontak juga belum diisi) — Google Play Console mensyaratkan link publik yang bisa diakses browser, bukan file di repo GitHub privat. Ditambahkan baris baru di `docs/TASK_BOARD.md` untuk langkah publish ini, PIC tetap Bramantyo.

## 2026-11-20 — `StarRewardOverlay`: hapus jumlah bintang + tombol "Lanjut", auto-transisi

**Laporan user**: "jangan berikan lanjut dan dapet bintang berapa, jangan diberikan, tidak ada sistem kalah atau menang" — menegaskan ulang aturan "tidak ada menang/kalah" (entri sebelumnya) ternyata belum tuntas diterapkan: `StarRewardOverlay` masih menampilkan `★★☆` (jumlah bintang) dan tombol teks "Lanjut" yang harus ditekan manual. Walau tidak literal menulis kata "menang"/"kalah", **menampilkan skor/jumlah tetap terasa seperti grading** ke anak — bentuk halus dari sistem menang-kalah yang sudah dilarang.

**Fix**: `core/scripts/star_reward_overlay.gd` ditulis ulang — hapus baris bintang dan tombol "Lanjut" sepenuhnya. Sekarang cuma: confetti + 1 ikon ✓ (animasi scale-in), lalu **otomatis** emit signal `continued` setelah ~1.8 detik tanpa interaksi apa pun dari anak. Parameter `stars_earned` tetap ada di kode (dipakai `ProgressRepository.record_result(...)` buat data internal, calon dashboard progres orang tua nanti) tapi **tidak pernah ditampilkan ke anak**.

**Bug lain ketemu sambil di sini**: `PanelContainer` di overlay lama pakai pola anchor 1-titik tanpa offset (sama seperti bug `ParentalGateDialog` sebelumnya) — sudah tidak relevan karena card-nya dihapus total, tapi kalau butuh container center lagi nanti, pakai `CenterContainer` seperti yang sekarang dipakai buat ikon ✓.

**Diverifikasi**: headless re-import + run `features/feature_angka/Angka.tscn` — lolos tanpa error. Belum dites sentuhan asli (auto-timer 1.8s belum dicoba rasanya kecepatan/kelambatannya di device nyata — bisa disesuaikan kalau user merasa kurang pas).

**Diupdate juga**: `docs/UI_UX_DESIGN.md` prinsip #4, `docs/PLAN_BASE_MODEL.md`, `docs/WORK_BREAKDOWN.md` (QA checklist), `obsidian-vault/Specs/feature_angka.md` — semua mention "bintang"/"tombol Lanjut" di spek disesuaikan.

## 2026-11-20 — Bug ditemukan & diperbaiki: window Windows "selalu landscape/miring" saat dev-test

**Laporan user**: window app saat dites di Windows selalu landscape/miring, bukan portrait, meski `window/handheld/orientation="portrait"` sudah diset.

**Akar masalah**: `window/handheld/orientation` **cuma berlaku untuk Android/handheld**, tidak ngaruh ke bentuk jendela desktop. Bentuk jendela desktop ikut `window/size/viewport_width`/`viewport_height` (720x1280, portrait) **kalau cukup muat** — tapi dicek pakai Win32 `GetWindowRect` API lewat PowerShell, layar laptop testing ini cuma **1366x768** (working area ~728px tinggi). Windows otomatis klem window 1280px tinggi supaya muat ke layar, tapi klem itu **tidak proporsional** (lebar & tinggi diklem independen) → window jadi ~736x788 (nyaris persegi), bukan portrait lagi — makanya terasa "miring"/landscape dibanding bentuk HP yang diharapkan.

**Fix**: tambah `window/size/window_width_override=405` + `window/size/window_height_override=720` di `[display]` `project.godot` — field ini **cuma ngaruh ke ukuran jendela desktop** (dev-test di Windows/Mac/Linux), **tidak ngaruh ke export Android** (device asli selalu pakai resolusi device sendiri lewat `window/stretch/mode="canvas_items"` yang sudah ada). 405x720 tetap rasio 9:16 (sama proporsi dengan base desain 720x1280), kecil cukup buat muat di layar manapun tanpa diklem Windows.

**Diverifikasi**: cek ulang `GetWindowRect` setelah fix — window sekarang ~421x759 (portrait proporsional, bukan dipaksa persegi). Headless re-import + re-run `Splash`/`Home`/`Settings`/`Angka` — semua lolos tanpa error.

## 2026-11-20 — Orientasi direvisi: LANDSCAPE, bukan portrait

**Klarifikasi user**: setelah bug window "selalu landscape/miring" di entri sebelumnya (yang ternyata cuma salah ukuran jendela desktop, bukan beneran landscape), user tegaskan maksudnya justru **mau landscape**, bukan portrait — supaya layar lebih lebar dan lebih pas menyesuaikan HP (rotasi) maupun tablet.

**Fix**: `project.godot` `[display]` dibalik — base resolusi desain jadi `1280x720` (16:9 landscape, sebelumnya `720x1280` portrait), `window/handheld/orientation="landscape"` (sebelumnya `"portrait"`), `window_width/height_override` jadi `960x540` (sebelumnya `405x720`) — tetap rasio 16:9, muat nyaman di layar testing 1366x768. `window/stretch/mode="canvas_items"` + `aspect="expand"` tidak berubah (itu yang bikin scaling lintas device tetap konsisten, lihat entri sebelumnya).

**Diverifikasi**: cek ulang `GetWindowRect` — window sekarang ~976x579 (landscape proporsional, tidak diklem Windows). Headless re-import + re-run semua 9 scene (`Splash`, `Home`, `Settings`, 6 `feature_*`) — lolos tanpa error.

**Belum**: belum dites sentuhan asli di device/emulator Android — perlu re-export APK untuk konfirmasi orientasi landscape benar-benar terkunci di device nyata (bukan cuma window desktop). Layout yang ada (semua `VBoxContainer` center full-anchor) belum ditinjau ulang khusus buat proporsi landscape yang lebih lebar & lebih pendek — kalau ada elemen yang terasa terlalu "melar" horizontal atau sempit vertikal pas dites, itu perlu penyesuaian per-scene berikutnya.

## 2026-11-21 — Plan baru: fitur tumbuh-kembang, "Bareng Orang Tua" vs "Belajar Mandiri"

**Permintaan user**: pelajari teori tumbuh-kembang anak, lalu buat fitur di mana orang tua bisa mengajari atau anak bisa belajar sendiri — plan mendalam, bukan langsung eksekusi.

**Dikerjakan**: riset singkat (WebSearch) 4 teori utama — milestone CDC per usia, Piaget (tahap praoperasional), Erikson (otonomi/inisiatif), Vygotsky (ZPD/scaffolding), Montessori (sensitive periods + auto-edukasi) — lalu ditulis jadi `docs/PLAN_TUMBUH_KEMBANG.md`. Temuan penting: keputusan "tidak ada menang/kalah" & "hapus bintang/skor" yang sudah diambil sebelumnya (entri 2026-11-20) **ternyata selaras dengan teori** (Erikson: usia 1-5 masih bangun rasa percaya diri/otonomi, belum siap konsep menang-kalah yang baru matang kognitifnya ~5 tahun per CDC) — bukan cuma preferensi gaya, ada dasarnya.

**Isi plan**: 2 mode dalam 1 app (bukan 2 app terpisah) — "Bareng Orang Tua" (kartu panduan singkat per modul di Settings, isi scaffolding ala Vygotsky: kalimat contoh buat diucapkan orang tua) dan "Belajar Mandiri" (audit bahwa gameplay yang sudah ada bisa dimainkan tanpa baca teks, ala prinsip self-correcting Montessori). Fasing: A (tulis konten dulu, non-coder-editable) → B (1 scene baru `ParentGuide.tscn`, taruh di belakang Settings/`ParentalGateDialog` yang sudah ada, **tidak sentuh `GameFlow`/gameplay sama sekali**) → C (audit mandiri per modul) → D (review konten oleh manusia yang paham anak usia dini, bukan dianggap final dari 1 sesi riset AI).

**Caveat penting dicatat di dokumen**: ini bukan nasihat medis/klinis, sumber riset level "tips umum" (SimplyPsychology/NAEYC/Montessori Academy/CDC) bukan jurnal akademik, dan dilarang di-overclaim di marketing ("berbasis riset" oke, "disetujui ahli" tidak — kecuali memang direview manusia kompeten).

**Status**: DRAFT, belum ada baris baru di `docs/TASK_BOARD.md` (sengaja menunggu konfirmasi user dulu sebelum jadi task nyata buat tim) — berbeda dari pola dokumen plan sebelumnya yang langsung dieksekusi.

## 2026-11-21 — Plan tumbuh-kembang disetujui, masuk Task Board

**Keputusan user**: lanjutkan `docs/PLAN_TUMBUH_KEMBANG.md` jadi task nyata. Ditambahkan 5 baris baru di `docs/TASK_BOARD.md` — Fase A (konten kartu, Bramantyo), Fase B (scene `ParentGuide`, Bramantyo), Fase C (audit mandiri per modul, Dev 2-4 + Dev Testing), Fase D (review konten oleh manusia yang paham anak usia dini — PIC belum ditentukan, **wajib** sebelum publish karena bukan nasihat medis), + ilustrasi kartu (opsional, Asset 1). Status di `PLAN_TUMBUH_KEMBANG.md` diubah dari DRAFT jadi DISETUJUI.

## 2026-11-21 — Spek `feature_hewan`: 2 mekanik (Mandiri + Bareng Orang Tua), 1 titik masuk yang menentukan

**Konteks**: user usul ide "tebak hewan dari suara, orang tua bisa buka jawaban dengan klik" (mencontoh pola flashcard umum). Dikoreksi dulu sebelum ditulis spek (lihat diskusi di chat): (1) ini bukan modul ke-11, tapi isi `feature_hewan` yang memang sudah ada slotnya tapi belum pernah ditulis logic-nya; (2) awalnya diusulkan 1 mekanik saja (self-correcting) demi hemat scope, tapi user minta tetap 2 mekanik.

**Keputusan arsitektur buat jalankan 2 mekanik tanpa nambah layar baru ke anak**: fork ditentukan dari **jalur masuk**, bukan dari pertanyaan baru di Home — Home → Play/Pilih Game tetap mekanik Mandiri (self-correcting, pola sama `feature_angka`) seperti modul lain; Settings → "Panduan Orang Tua" → tombol "Mulai main bareng" (baru, bagian dari Fase B `docs/PLAN_TUMBUH_KEMBANG.md`) masuk ke mekanik Bareng Orang Tua (reveal manual, tanpa ✓/✗, orang tua pegang pace). Prinsip #3 UI_UX_DESIGN.md ("satu aksi utama per layar") tetap utuh — anak tidak pernah lihat pilihan mode.

**Konsekuensi teknis**: butuh 1 state baru di `GameFlow` (`guided_mode`, pola sama `infinite_mode`) dan fungsi baru `start_guided_game(...)` — perubahan `core/` pertama yang didorong kebutuhan 1 modul `feature_*` spesifik, bukan dari Bramantyo sendiri. `features/feature_hewan/hewan.gd` baca flag itu, 1 script 2 cabang render, data hewan (6 ekor awal: kucing/anjing/sapi/ayam/kambing/bebek) di 1 file data supaya mudah ditambah tanpa ubah logic.

**Spek lengkap**: `obsidian-vault/Specs/feature_hewan.md`. **Sengaja tidak dijadikan pola default** untuk 5 modul lain — ini keputusan khusus `feature_hewan`, bukan standar baru untuk semua modul.

## 2026-11-21 — `feature_hewan` diimplementasikan: 2 mekanik jalan, placeholder aset

**Dikerjakan**: `features/feature_hewan/hewan.gd` ditulis penuh sesuai `obsidian-vault/Specs/feature_hewan.md` — data 6 hewan di `features/feature_hewan/data/hewan_data.json` (bukan hardcode array di `.gd`, supaya Asset/non-coder bisa edit nanti), mekanik Mandiri (dengar suara → pilih 1 dari 3, pola sama `feature_angka`, reuse `StarRewardOverlay`+`ProgressRepository`+`GameFlow.finish_game_session()`), dan mekanik Bareng Orang Tua (gambar disamarkan "？" → tombol "🔊 Dengar Suaranya" + "🔍 Lihat Jawaban" [tanpa tanda benar/salah] + "Hewan Lain →", hint kalimat scaffolding cuma muncul di hewan pertama). Fork 2 mekanik dibaca dari `GameFlow.guided_mode` (state baru, pola sama `infinite_mode`) + `start_guided_game(...)` (belum ada pemanggilnya sampai `ParentGuide.tscn` dibangun di Fase B). `GameFlow.GAMES` baris Hewan diubah `implemented: false → true`, jadi sekarang ikut masuk pool "Play acak".

**Placeholder yang masih perlu diganti** (bukan bug, sengaja — base model harus bisa ditest tanpa aset final): `placeholder_emoji` (🐱🐶🐮🐔🐐🦆) di `hewan_data.json` ganti ilustrasi asli dari Asset 1; `sfx` kosong + semua `SfxService.play(null)` ganti suara asli dari Farel.

**Diverifikasi**: headless re-import + run `Hewan.tscn` 2 kali — sekali dengan `GameFlow.guided_mode` default (`false`, mekanik Mandiri), sekali dipaksa `true` sementara (lalu dikembalikan ke `false`) buat mastiin cabang Bareng Orang Tua juga bebas error. Re-run semua 9 scene lain — semua lolos tanpa error baru. App juga dijalankan non-headless buat preview visual user.

**Belum**: tombol "Mulai main bareng" di `ParentGuide` (scene-nya belum ada, Fase B) — jadi mekanik Bareng Orang Tua untuk sekarang **tidak bisa diakses dari UI manapun**, cuma lewat flag manual kayak di atas. Tidak masalah untuk base model (gameplay-nya sudah siap, tinggal nunggu pintu masuknya), tapi perlu dicatat supaya tidak dikira "sudah selesai sepenuhnya".

## 2026-11-21 — `ParentGuide.tscn` dibangun: Fase A+B fitur tumbuh-kembang selesai

**Dikerjakan**: `core/data/parent_guide.json` (Fase A — isi 6 kartu panduan orang tua, satu per modul, format sesuai `docs/PLAN_TUMBUH_KEMBANG.md` bagian 2.1: "lagi belajar apa", kalimat scaffolding, ide lanjutan di luar app) + `scenes/ParentGuide.tscn`/`parent_guide.gd` (Fase B — daftar kartu, tap buka detail, tombol "Mulai main bareng" cuma muncul kalau kartu punya `guided_scene` terisi — sekarang cuma `feature_hewan`). Akses: Settings → "Panduan Orang Tua" (lewat `GameFlow.goto_scene`, sudah di belakang `ParentalGateDialog`).

**Konten**: 1 kalimat generik di atas daftar soal "kenapa tidak ada nilai/menang-kalah" (muncul sekali, bukan diulang per kartu, sesuai desain di plan). Disclaimer "bukan nasihat medis" ditaruh di bawah daftar, bukan diam-diam dihilangkan.

**Layout**: `CenterContainer` + `ScrollContainer` (ukuran minimum 560x520) + `PanelContainer` — pola yang sama dipakai buat hindari bug kolaps `ParentalGateDialog` (anchor titik tanpa offset) sekaligus kasih fallback scroll kalau konten (6 tombol + teks) lebih tinggi dari layar. Konten dirender ulang (`_render_list()`/`_render_detail()`) tiap ganti tampilan, pola sama `angka.gd`.

**Diverifikasi**: headless re-import + run `ParentGuide.tscn` + 9 scene lain — semua lolos tanpa error. App dijalankan non-headless buat preview user.

**Belum**: Fase C (audit mandiri per modul) & Fase D (review konten oleh manusia yang paham anak usia dini) masih Open di `docs/TASK_BOARD.md` — konten 6 kartu ini draft pertama, bukan final.

## 2026-11-21 — Spek 4 modul tersisa ditulis: `feature_warna`, `feature_musik`, `feature_mewarnai`, `feature_puzzle`

**Dikerjakan**: lengkapi `obsidian-vault/Specs/` buat 4 modul yang masih kosong, dasarnya dari `docs/UI_UX_DESIGN.md` tabel "Pola interaksi per tipe mini-game" + prinsip yang sudah berlaku. Keputusan penting per modul:

- **`feature_warna`**: 1 mekanik (tap, cocokkan warna acuan ke benda — pola sama `feature_angka`), reuse `AppColors` yang sudah ada, 6 warna+benda placeholder (emoji). Dicatat eksplisit: larangan "merah murni" di `docs/UI_UX_DESIGN.md` itu soal warna feedback-salah, **bukan** larangan mengajarkan konsep warna merah itu sendiri.
- **`feature_musik`**: **sengaja tanpa struktur soal benar/salah** — tap bebas 4-6 tombol nada, selesai setelah 8 ketukan (bukan kuis). Alasan: "tidak perlu presisi musikal" di UI_UX_DESIGN.md secara alami berarti tidak ada target benar/salah untuk musik usia 1-5 tahun.
- **`feature_mewarnai`**: juga tanpa benar/salah — isi 2-4 area besar dengan warna pilihan sendiri (bukan freehand drawing piksel, itu di luar scope base model, dicatat jelas sebagai batasan prototipe bukan bug). Reuse palet warna dari `feature_warna`.
- **`feature_puzzle`**: drag 3-4 keping (bukan langsung 6) ke outline, snap longgar, diam (tanpa suara negatif) kalau belum pas. Dicatat sebagai modul paling pas buat scaffolding orang tua (`core/data/parent_guide.json` sudah ada kartunya), tapi **tetap 1 mekanik gameplay** — tidak ikut pola 2-mode `feature_hewan`.

**Status**: 4 spek ini DITULIS, **implementasi kode belum dikerjakan** — ditambahkan sebagai baris Open terpisah per modul di `docs/TASK_BOARD.md` (PIC sesuai `docs/TEAM.md`: Dev 2 untuk warna, Dev 3 untuk musik, Dev 4 untuk mewarnai+puzzle).

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

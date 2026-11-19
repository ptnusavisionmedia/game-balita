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

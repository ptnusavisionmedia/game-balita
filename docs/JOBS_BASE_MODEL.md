# Jobs: Base Model (Fase 1)

Lihat alasan & scope lengkap di [docs/PLAN_BASE_MODEL.md](PLAN_BASE_MODEL.md). Pemetaan orang mengikuti [docs/TEAM.md](TEAM.md) — nama masih placeholder, ganti saat sudah fix.

> **Catatan stack**: base model sempat ditulis di Flutter/Dart, lalu diganti ke **Godot/GDScript** (lihat `obsidian-vault/Decisions Log.md`). Checklist di bawah sudah diupdate untuk Godot — kode-nya sudah ditulis ulang, tapi **belum pernah dibuka/dicoba di Godot Editor sungguhan**.

## Job 1 — Bramantyo — `core/`

Jalur kritis base model. Sebagian sudah di-scaffold sesi ini supaya Job 1 tidak mulai dari nol — cek dulu sebelum nulis ulang:

- [x] `AppColors` (palet, lihat `docs/UI_UX_DESIGN.md`) — `core/scripts/app_colors.gd`.
- [x] `StarRewardOverlay` pakai `CPUParticles2D` bawaan Godot — `core/scenes/StarRewardOverlay.tscn` + `core/scripts/star_reward_overlay.gd`.
- [x] `SfxService` (SFX) + `AudioService` (musik/VO) — autoload singleton, `core/scripts/sfx_service.gd` + `audio_service.gd`, lihat `docs/LIBRARIES.md`.
- [x] `ProgressRepository` (autoload singleton, pakai `ConfigFile` bawaan Godot) — `core/scripts/progress_repository.gd`, sudah terdaftar di `[autoload]` `project.godot`.
- [x] `ParentalGateDialog` (tahan tombol 3 detik) — `core/scenes/ParentalGateDialog.tscn` + `core/scripts/parental_gate_dialog.gd`.
- [ ] CI/Docker untuk Godot (`.github/workflows/ci.yml`, `Dockerfile`) — **belum dibuat ulang** setelah reset dari Flutter, lihat `docs/DOCKER.md` untuk rencana pakai image `barichello/godot-ci`.
- [ ] Review PR dari Job 3 begitu wiring ke `core/` siap.

**Definition of done Job 1**: semua checklist tercentang + bisa dipakai modul lain tanpa perlu baca isi `core/scripts/`. **Status: kode selesai, CI/Docker belum, belum diverifikasi jalan di Godot Editor.**

## Job 2 — Dev App (baru) — `scenes/`

Dipisah dari Bramantyo supaya `core/` + `scenes/` tidak numpuk 1 orang.

- [x] Wiring navigasi Home ↔ Settings ↔ mini-game, pasang `ParentalGateDialog` sebelum masuk Settings — `scenes/home.gd`.
- [x] `Settings.tscn` (toggle suara, baca/tulis lewat `ProgressRepository`, sinkron ke `SfxService`/`AudioService`) — `scenes/settings.gd`.
- [ ] Update `Home` supaya menampilkan status progres singkat per mini-game (opsional, ditunda — base model sudah cukup tanpa ini).

**Definition of done Job 2**: dari Home bisa masuk Settings (lewat parental gate) dan balik, toggle suara nyata mempengaruhi `SfxService`/`AudioService`. **Status: kode selesai, belum diverifikasi jalan.**

## Job 3 — Dev 2 — `features/feature_angka/` (PILOT)

Modul ini jadi **contoh pola** untuk 5 modul lain di Fase 2, jadi dikerjakan paling teliti.

- [x] UI: tampilkan kumpulan objek (1-5 ikon hati, placeholder — belum ilustrasi final dari Asset 1), pilihan angka untuk di-tap (`BigRoundButton`).
- [x] Logic: deteksi tap benar/salah, random urutan soal (4 soal per sesi).
- [x] Feedback: panggil `SfxService.play(...)` — asset audio belum ada (Job 11 belum selesai), untuk sekarang dipanggil dengan `null` (sudah di-guard, tidak crash); tinggal isi `AudioStream` begitu Asset 2 upload file (ada komentar `# TODO Asset 2` di kode).
- [x] Selesai sesi → `StarRewardOverlay` → simpan hasil via `ProgressRepository.record_result(...)`.
- [x] Tombol kembali ke Home (`get_tree().change_scene_to_file(...)` setelah simpan hasil).

**Definition of done Job 3**: 1 level bisa dimainkan dari Home sampai balik ke Home, hasilnya kebaca lagi kalau app ditutup-buka. **Status: kode selesai, lihat `features/feature_angka/angka.gd` — belum pernah dibuka di Godot Editor sungguhan.**

## Job 4 — Dev Warna (baru) — spek `feature_warna`

**Belum coding dulu** — base model (`feature_angka`) harus lolos demo dulu (lihat `docs/PLAN_BASE_MODEL.md`). Selama Fase 1:

- [ ] Tulis spek 1 halaman di `obsidian-vault/Specs/feature_warna.md` (format ikuti `feature_angka.md`).
- [ ] Daftar asset yang dibutuhkan.
- [ ] Baca `features/feature_angka/angka.gd` begitu base model lolos demo — ini pola yang dipakai di Fase 2.

## Job 5 — Dev 3 — spek `feature_hewan`

Sama seperti Job 4, untuk `feature_hewan`.

## Job 6 — Dev Musik (baru) — spek `feature_musik`

Sama seperti Job 4, untuk `feature_musik`.

## Job 7 — Dev 4 — spek `feature_mewarnai`

Sama seperti Job 4, untuk `feature_mewarnai`.

## Job 8 — Dev Puzzle (baru) — spek `feature_puzzle`

Sama seperti Job 4, untuk `feature_puzzle`.

**Definition of done Job 4-8**: spek + daftar asset tiap modul sudah ada di vault, siap langsung coding begitu base model demo lolos. Placeholder scene (`Warna.tscn`, `Hewan.tscn`, dst — tombol "Kembali" saja) sudah ada, tinggal diisi logic masing-masing.

## Job 9 — Dev Testing (baru)

Peran lintas-modul, kerja tidak nunggu modul tertentu selesai:

- [ ] Susun `docs/QA_CHECKLIST.md`: hit-area ≥64dp, suara kebaca, reward muncul, progres tersimpan setelah app ditutup-buka, device low-end tidak lag.
- [ ] Pertimbangkan addon [GUT](https://github.com/bitwes/Gut) untuk automated test GDScript (lihat `docs/LIBRARIES.md`) — belum dipasang di base model.
- [ ] Begitu Job 3 (`feature_angka`) demo-able: test penuh pakai checklist, kalau nemu bug **perbaiki langsung** (bukan cuma laporkan — ini bedanya dari role QA biasa, lihat `docs/ROLES.md`), PR terpisah + tag Dev 2.
- [ ] Siapkan minimal 1 device Android low-end asli untuk testing (bukan cuma emulator).

## Job 10 — Asset 1 (Ilustrator, lead)

- [ ] **Style guide ilustrasi** dulu (1x, acuan semua modul + acuan Asset 4): gaya gambar, palet warna karakter, ukuran minimum elemen yang bisa di-tap. Taruh di `obsidian-vault/Specs/style-guide-ilustrasi.md`.
- [ ] Ilustrasi `feature_angka` (buah/objek 1-5, pengganti ikon hati placeholder) sesuai spek pilot — prioritas.
- [ ] App icon & splash screen draft.
- [ ] Taruh file di `features/feature_angka/assets/images/` — format `.png`/`.svg` (Godot import otomatis rasterize SVG saat di-drag ke editor).

## Job 11 — Asset 2 (Audio/VO, lead)

- [ ] SFX dasar: tap, benar, coba-lagi (lewat `SfxService`, format `.wav`/`.ogg` pendek & ringan — lihat `docs/LIBRARIES.md`).
- [ ] VO angka 1-5 (bahasa Indonesia, nada ramah anak).
- [ ] Taruh file di `features/feature_angka/assets/audio/`, lalu update `features/feature_angka/angka.gd` (ganti `SfxService.play(null)` jadi `SfxService.play(preload("res://features/feature_angka/assets/audio/<nama_file>"))`).

## Job 12 — Asset 3 (Video/Marketing, lead)

Tidak bergantung ke base model, bisa jalan dari sekarang:

- [ ] Riset referensi video promo app sejenis, kumpulkan di `marketing/references/`.
- [ ] Draft konsep video promo/trailer (storyboard kasar).
- [ ] Draft listing Play Store Console (judul, deskripsi, kategori) — **belum publish**, tunggu APK export dari Bramantyo + Dev App.
- [ ] Begitu `feature_angka` demo-able, rekam video demo pertama.

## Job 13 — Asset 4 (baru, fleksibel)

- [ ] Tunggu style guide dari Job 10 selesai, baru mulai.
- [ ] Assist Asset 1: produksi ilustrasi `feature_warna` (begitu spek Job 4 siap) secara paralel, supaya produksi aset tidak bottleneck di 1 orang pas Fase 2 mulai.
- [ ] Fleksibel pindah bantu video/audio kalau Asset 1 belum butuh bantuan tapi Asset 2/3 lagi kebanjiran kerjaan.

## Job 14 — Asset 5 (baru, fleksibel)

- [ ] Assist Asset 2: SFX/VO untuk `feature_musik` (begitu spek Job 6 siap).
- [ ] Fleksibel pindah ke gambar/video sesuai kebutuhan.

## Job 15 — Asset 6 (baru, fleksibel)

- [ ] Assist Asset 3: bantu riset referensi + dokumentasi asset pipeline (`marketing/references/`, `marketing/play-store/`).
- [ ] Fleksibel pindah ke gambar/audio sesuai kebutuhan.

## Belum ada pemegang jelas (lihat docs/TEAM.md "role lintas-modul")

**Privacy Policy & Google Play Families Policy** — wajib ada sebelum submit ke Play Store (app anak-anak punya aturan ekstra soal ads & data collection). Tim ini sengaja lean (tidak ada headcount "Compliance Officer" terpisah), jadi **harus diputuskan siapa yang pegang** sebelum Fase 2 selesai — bisa dirangkap Bramantyo/Asset 3, atau ditambah orang baru kalau dirasa perlu nanti.

## Setelah base model demo lolos (Fase 2, belum mulai)

Dev Warna/Musik/Puzzle + Dev 3/4 mulai coding modul masing-masing dengan pola yang sama seperti `feature_angka`. Asset 1-6 lanjut produksi penuh. Dev Testing mulai test rutin tiap modul baru selesai. Tidak dibahas detail di sini — akan ada `docs/JOBS_FASE2.md` terpisah setelah base model selesai.

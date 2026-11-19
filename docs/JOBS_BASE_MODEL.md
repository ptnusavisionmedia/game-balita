# Jobs: Base Model (Fase 1)

Lihat alasan & scope lengkap di [docs/PLAN_BASE_MODEL.md](PLAN_BASE_MODEL.md). Pemetaan orang mengikuti [docs/TEAM.md](TEAM.md) — nama masih placeholder, ganti saat sudah fix.

## Job 1 — Dev 1 (Lead/Architect) — `core` + `app`

Jalur kritis base model. Sebagian sudah di-scaffold sesi ini supaya Job 1 tidak mulai dari nol — cek dulu sebelum nulis ulang:

- [x] `packages/core`: `AppTheme` + `AppColors` (palet & font Baloo 2, lihat `docs/UI_UX_DESIGN.md`) — **sudah ada**, isi `packages/core/lib/src/theme/`.
- [x] `packages/core`: `StarRewardOverlay` pakai package `confetti` — **sudah ada**, `packages/core/lib/src/widgets/star_reward_overlay.dart`.
- [x] `packages/core`: `SfxService` (SFX latensi rendah, `soundpool`) + `AudioService` (musik/VO, `audioplayers`) — **sudah ada**, lihat `docs/LIBRARIES.md` untuk pembagian tugasnya.
- [ ] `packages/core`: `ProgressRepository` — `ChangeNotifier` + `shared_preferences`, simpan/baca `GameResult` dan setting suara. **Belum dibuat, mulai dari sini.**
- [ ] `packages/core`: `ParentalGateDialog` (gate sederhana, misal tahan tombol 3 detik).
- [ ] `packages/app`: wiring navigasi Home ↔ Settings ↔ mini-game, pasang `ParentalGateDialog` di depan Settings.
- [ ] `packages/app`: `SettingsScreen` (toggle suara, baca/tulis lewat `ProgressRepository`).
- [x] `.github/workflows/ci.yml` + `Dockerfile`/`docker-compose.yml` — **sudah ada**, jalankan `melos run analyze` + `melos run test` di tiap push/PR lewat image Docker yang sama dengan lokal (lihat `docs/DOCKER.md`).
- [ ] Review PR dari Job 2 begitu wiring ke `core` siap.

**Definition of done Job 1**: semua checklist di atas tercentang + bisa dipakai Job 2 tanpa Job 2 perlu baca isi `core/src/`.

## Job 2 — Dev 2 — `feature_angka` (PILOT)

Modul ini jadi **contoh pola** untuk 5 modul lain di Fase 2, jadi dikerjakan paling teliti.

- [ ] UI: tampilkan kumpulan objek (1-5 buah), pilihan angka untuk di-tap.
- [ ] Logic: deteksi tap benar/salah, random urutan soal sederhana (3-5 soal per sesi).
- [ ] Feedback: suara + animasi benar/salah lewat `core.AudioService` (sudah ada) — tunggu Job 1 untuk `StarRewardOverlay`.
- [ ] Selesai sesi → tampilkan `StarRewardOverlay` → simpan `GameResult` via `ProgressRepository`.
- [ ] Tombol kembali ke Home.
- [ ] Sebelum Job 1 selesai: bisa mulai dari UI/logic dulu dengan data dummy (jangan nunggu nganggur).

**Definition of done Job 2**: 1 level bisa dimainkan dari Home sampai balik ke Home, hasilnya kebaca lagi kalau app ditutup-buka.

## Job 3-7 — Dev 3..7 — `feature_warna`, `feature_hewan`, `feature_musik`, `feature_mewarnai`, `feature_puzzle`

**Belum coding fitur dulu** — base model harus stabil dulu lewat Job 1+2 sebelum 5 modul ini dibuka paralel (lihat alasan di PLAN_BASE_MODEL.md). Supaya tidak nganggur, tugas tiap orang selama Fase 1:

- [ ] Tulis spek 1 halaman untuk modulnya sendiri: aturan main level 1 (seperti contoh `feature_angka`), berapa soal per sesi, apa kondisi menang.
- [ ] Daftar asset yang dibutuhkan: nama file ilustrasi & audio (tidak perlu bikin asset final, cukup list + placeholder kasar — boleh pakai AI image/audio gen).
- [ ] Baca PR Job 2 (`feature_angka`) begitu merge — ini pola yang akan dipakai untuk modul masing-masing di Fase 2.
- [ ] Taruh spek masing-masing di `obsidian-vault/Specs/<nama-modul>.md` (lihat struktur vault).

**Definition of done Job 3-7**: spek + daftar asset modul masing-masing sudah ada di vault, siap langsung coding begitu base model demo lolos.

## Setelah base model demo lolos (Fase 2, belum mulai)

Job 3-7 mulai coding modul masing-masing dengan pola yang sama seperti `feature_angka`. Tidak dibahas detail di sini — akan ada `docs/JOBS_FASE2.md` terpisah setelah base model selesai.

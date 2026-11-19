# Jobs: Base Model (Fase 1)

Lihat alasan & scope lengkap di [docs/PLAN_BASE_MODEL.md](PLAN_BASE_MODEL.md). Pemetaan orang mengikuti [docs/TEAM.md](TEAM.md) — nama masih placeholder, ganti saat sudah fix.

## Job 1 — Bramantyo — `core` + `app`

Jalur kritis base model. Sebagian sudah di-scaffold sesi ini supaya Job 1 tidak mulai dari nol — cek dulu sebelum nulis ulang:

- [x] `packages/core`: `AppTheme` + `AppColors` (palet & font Baloo 2, lihat `docs/UI_UX_DESIGN.md`) — **sudah ada**, isi `packages/core/lib/src/theme/`.
- [x] `packages/core`: `StarRewardOverlay` pakai package `confetti` — **sudah ada**, `packages/core/lib/src/widgets/star_reward_overlay.dart`.
- [x] `packages/core`: `SfxService` (SFX latensi rendah, `soundpool`) + `AudioService` (musik/VO, `audioplayers`) — **sudah ada**, lihat `docs/LIBRARIES.md` untuk pembagian tugasnya.
- [x] `packages/core`: `ProgressRepository` — `ChangeNotifier` + `shared_preferences`, simpan/baca `GameResult` dan setting suara. **Sudah ada**, `packages/core/lib/src/services/progress_repository.dart` (+ unit test). Wajib panggil `ProgressRepository.instance.init()` di `main()` sebelum `runApp` — sudah diwiring di `packages/app/lib/main.dart`.
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

## Job 3 — Dev 2 (lanjutan) — spek `feature_warna`

Dev 2 pegang `feature_angka` (Job 2) **dan** `feature_warna`. Selama Job 2 jalan, sisihkan waktu untuk:

- [ ] Tulis spek 1 halaman `feature_warna` di `obsidian-vault/Specs/feature_warna.md` (aturan main, jumlah soal, kondisi menang — ikuti format `feature_angka.md`).
- [ ] Daftar asset yang dibutuhkan (nama file ilustrasi & audio).

**Belum coding `feature_warna` dulu** — tunggu base model (`feature_angka`) lolos demo.

## Job 4 — Dev 3 — spek `feature_hewan` + `feature_musik`

**Belum coding fitur** — base model harus stabil dulu lewat Job 1+2 (lihat alasan di PLAN_BASE_MODEL.md). Selama Fase 1:

- [ ] Tulis spek 1 halaman untuk **kedua** modul di `obsidian-vault/Specs/feature_hewan.md` dan `feature_musik.md`.
- [ ] Daftar asset yang dibutuhkan tiap modul.
- [ ] Baca PR Job 2 (`feature_angka`) begitu merge — ini pola yang akan dipakai di Fase 2.

## Job 5 — Dev 4 — spek `feature_mewarnai` + `feature_puzzle`

Sama seperti Job 4, untuk `feature_mewarnai` dan `feature_puzzle`.

**Definition of done Job 3-5**: spek + daftar asset tiap modul sudah ada di vault, siap langsung coding begitu base model demo lolos.

## Job 6 — Asset 1 (Ilustrator)

- [ ] **Style guide ilustrasi** dulu (1x, acuan semua modul): gaya gambar (flat vector/semi-3D), palet warna karakter, ukuran minimum elemen yang bisa di-tap. Taruh di `obsidian-vault/Specs/style-guide-ilustrasi.md`.
- [ ] Ilustrasi untuk `feature_angka` (buah 1-5) sesuai spek pilot — prioritas, karena base model butuh ini untuk demo yang terasa "jadi", bukan kotak abu-abu.
- [ ] App icon & splash screen draft.
- [ ] Taruh file final di `packages/feature_angka/assets/images/` (ikuti nama file yang sudah disebut di `obsidian-vault/Specs/feature_angka.md`).
- [ ] Setelah modul lain ada spek-nya (Job 3-5 selesai), lanjut produksi ilustrasi modul berikutnya — tidak perlu nunggu dev mulai coding modul itu.

## Job 7 — Asset 2 (Audio/VO)

- [ ] SFX dasar: tap, benar, coba-lagi (lihat `docs/LIBRARIES.md` — ini dipakai lewat `SfxService`, format pendek & ringan).
- [ ] VO angka 1-5 (bahasa Indonesia, nada ramah anak) untuk `feature_angka`.
- [ ] Taruh file di `packages/feature_angka/assets/audio/`.
- [ ] Setelah Job 3-5 selesai, lanjut rekam/cari SFX+VO modul lain sesuai spek masing-masing.

## Job 8 — Asset 3 (Video/Marketing)

Tidak bergantung ke base model, bisa jalan dari sekarang:

- [ ] Riset referensi video promo app sejenis (kompetitor), kumpulkan sebagai referensi di `marketing/references/`.
- [ ] Draft konsep video promo/trailer (storyboard kasar, belum perlu render final — base model belum punya cukup konten untuk direkam).
- [ ] Draft listing Play Store Console (judul, deskripsi, kategori) — **belum publish**, tunggu APK dari Bramantyo.
- [ ] Begitu `feature_angka` demo-able (base model lolos), rekam video demo pertama dari situ.

## Setelah base model demo lolos (Fase 2, belum mulai)

Dev 2-4 mulai coding modul kedua masing-masing dengan pola yang sama seperti `feature_angka`. Asset creator lanjut produksi penuh untuk modul-modul itu. Tidak dibahas detail di sini — akan ada `docs/JOBS_FASE2.md` terpisah setelah base model selesai.

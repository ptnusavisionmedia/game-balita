# Jobs: Base Model (Fase 1)

Lihat alasan & scope lengkap di [docs/PLAN_BASE_MODEL.md](PLAN_BASE_MODEL.md). Pemetaan orang mengikuti [docs/TEAM.md](TEAM.md) — nama masih placeholder, ganti saat sudah fix. Tim di-ramping jadi **8 orang (5 dev + 3 asset)** — lihat alasan di `docs/TEAM.md` dan histori perubahan di `obsidian-vault/Decisions Log.md`.

> **Status stack**: Godot 4.7.2 sudah diinstall & semua 8 scene lolos headless tanpa error (2026-11-19). Yang belum dicoba: interaksi sentuhan asli & export APK — lihat Definition of Done di `docs/PLAN_BASE_MODEL.md`.

## Job 1 — Bramantyo — `core/` + `scenes/`

Jalur kritis base model. Sudah ditulis & lolos headless — cek dulu sebelum nulis ulang:

- [x] `AppColors` (palet) — `core/scripts/app_colors.gd`.
- [x] `StarRewardOverlay` pakai `CPUParticles2D` bawaan Godot — `core/scenes/StarRewardOverlay.tscn` + script.
- [x] `SfxService` + `AudioService` — autoload singleton, lihat `docs/LIBRARIES.md`.
- [x] `ProgressRepository` (autoload singleton, `ConfigFile` bawaan Godot) — terdaftar di `[autoload]` `project.godot`.
- [x] `ParentalGateDialog` (tahan tombol 3 detik) — `core/scenes/ParentalGateDialog.tscn` + script.
- [x] Wiring navigasi Home ↔ Settings ↔ mini-game — `scenes/home.gd`.
- [x] `Settings.tscn` (toggle suara, sinkron `SfxService`/`AudioService`) — `scenes/settings.gd`.
- [x] CI headless validate (`.github/workflows/ci.yml`) — binary `godot` + `--quit-after` terverifikasi.
- [ ] CI export job (APK debug) — butuh `export_presets.cfg` + keystore dulu.
- [ ] Review PR dari Dev 2-4 begitu wiring ke `core/` siap.

**Definition of done Job 1**: semua checklist tercentang + bisa dipakai modul lain tanpa perlu baca isi `core/scripts/`. **Status: kode selesai & lolos headless. Sisa: CI export job, verifikasi interaktif di device/emulator asli.**

## Job 2 — Dev 2 — `features/feature_angka/` (PILOT) + `features/feature_warna/`

Modul `feature_angka` jadi **contoh pola** untuk 5 modul lain di Fase 2, jadi dikerjakan paling teliti duluan.

- [x] UI: tampilkan kumpulan objek (1-5 ikon hati, placeholder), pilihan angka untuk di-tap (`BigRoundButton`).
- [x] Logic: deteksi tap benar/salah, random urutan soal (4 soal per sesi).
- [x] Feedback: panggil `SfxService.play(...)` — placeholder `null` sampai Asset 2 upload file (`# TODO Asset 2` di kode).
- [x] Selesai sesi → `StarRewardOverlay` → simpan hasil via `ProgressRepository.record_result(...)`.
- [x] Tombol kembali ke Home.

**Definition of done `feature_angka`**: 1 level bisa dimainkan dari Home sampai balik ke Home, hasilnya kebaca lagi kalau app ditutup-buka. **Status: kode selesai & lolos headless — belum dicoba main sungguhan.**

`feature_warna` (modul kedua Dev 2): **belum coding** — tunggu base model (`feature_angka`) lolos demo. Selama itu:
- [ ] Tulis spek 1 halaman di `obsidian-vault/Specs/feature_warna.md` (format ikuti `feature_angka.md`).
- [ ] Daftar asset yang dibutuhkan.

## Job 3 — Dev 3 — spek `features/feature_hewan/` + `features/feature_musik/`

**Belum coding** — base model harus lolos demo dulu. Selama Fase 1:
- [ ] Tulis spek 1 halaman untuk **kedua** modul di `obsidian-vault/Specs/feature_hewan.md` dan `feature_musik.md`.
- [ ] Daftar asset yang dibutuhkan tiap modul.
- [ ] Baca `features/feature_angka/angka.gd` begitu base model lolos demo — ini pola yang dipakai di Fase 2.

Placeholder scene (`Hewan.tscn`, `Musik.tscn` — tombol "Kembali" saja) sudah ada, tinggal diisi logic.

## Job 4 — Dev 4 — spek `features/feature_mewarnai/` + `features/feature_puzzle/`

Sama seperti Job 3, untuk `feature_mewarnai` dan `feature_puzzle`.

**Definition of done Job 2 (bagian warna)-4**: spek + daftar asset tiap modul sudah ada di vault, siap langsung coding begitu base model demo lolos.

## Job 5 — Dev Testing

Peran lintas-modul, kerja tidak nunggu modul tertentu selesai:

- [ ] Susun `docs/QA_CHECKLIST.md`: hit-area ≥64dp, suara kebaca, reward muncul, progres tersimpan setelah app ditutup-buka, device low-end tidak lag.
- [ ] Pertimbangkan addon [GUT](https://github.com/bitwes/Gut) untuk automated test GDScript (lihat `docs/LIBRARIES.md`) — belum dipasang di base model.
- [ ] Test interaktif `feature_angka` di device/emulator asli (headless cuma membuktikan tidak crash saat load, bukan gameplay-nya benar) — kalau nemu bug **perbaiki langsung** (bukan cuma laporkan), PR terpisah + tag Dev 2.
- [ ] Siapkan minimal 1 device Android low-end asli untuk testing.

## Job 6 — Asset 1 (Ilustrasi)

- [ ] **Style guide ilustrasi** dulu (1x, acuan semua modul): gaya gambar, palet warna karakter, ukuran minimum elemen yang bisa di-tap. Taruh di `obsidian-vault/Specs/style-guide-ilustrasi.md`.
- [ ] Ilustrasi `feature_angka` (buah/objek 1-5, pengganti ikon hati placeholder) sesuai spek pilot — prioritas.
- [ ] App icon & splash screen draft.
- [ ] Taruh file di `features/feature_angka/assets/images/` — format `.png`/`.svg`.

## Job 7 — Asset 2 (Audio/VO)

- [ ] SFX dasar: tap, benar, coba-lagi (lewat `SfxService`, format `.wav`/`.ogg` pendek & ringan — lihat `docs/LIBRARIES.md`).
- [ ] VO angka 1-5 (bahasa Indonesia, nada ramah anak).
- [ ] Taruh file di `features/feature_angka/assets/audio/`, lalu update `features/feature_angka/angka.gd` (ganti `SfxService.play(null)` jadi `SfxService.play(preload("res://features/feature_angka/assets/audio/<nama_file>"))`).

## Job 8 — Asset 3 (Video/Marketing)

Tidak bergantung ke base model, bisa jalan dari sekarang:

- [ ] Riset referensi video promo app sejenis, kumpulkan di `marketing/references/`.
- [ ] Draft konsep video promo/trailer (storyboard kasar).
- [ ] Draft listing Play Store Console (judul, deskripsi, kategori) — **belum publish**, tunggu APK export dari Bramantyo.
- [ ] Begitu `feature_angka` demo-able, rekam video demo pertama.

## Belum ada pemegang jelas (lihat docs/TEAM.md "role lintas-modul")

**Privacy Policy & Google Play Families Policy** — wajib ada sebelum submit ke Play Store (app anak-anak punya aturan ekstra soal ads & data collection). Tim ini sengaja lean (tidak ada headcount "Compliance Officer" terpisah), jadi **harus diputuskan siapa yang pegang** sebelum Fase 2 selesai — bisa dirangkap Bramantyo/Asset 3, atau ditambah orang baru kalau dirasa perlu nanti.

## Setelah base model demo lolos (Fase 2, belum mulai)

Dev 2-4 mulai coding modul kedua masing-masing (`feature_warna`, `feature_musik`, `feature_puzzle`) dengan pola yang sama seperti `feature_angka`. Asset 1-3 lanjut produksi penuh. Dev Testing mulai test rutin tiap modul baru selesai. Tidak dibahas detail di sini — akan ada `docs/JOBS_FASE2.md` terpisah setelah base model selesai.

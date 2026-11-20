# Plan: Base Model (Fase 1)

Status: **aktif** · Dibuat: 2026-11-19 · Stack: **Godot 4 / GDScript** (sempat Flutter/Dart, diganti — lihat `obsidian-vault/Decisions Log.md`)

## Kenapa base model dulu, bukan langsung 6 mini-game?

Kalau 6 orang langsung coding 6 mini-game paralel sebelum ada base model yang stabil, setiap orang akan menebak sendiri cara pakai `core/` (cara simpan progres, cara panggil audio, cara kasih reward) — hasilnya 6 pola berbeda yang harus dirapikan ulang nanti. Base model = **1 vertical slice yang benar-benar jalan** (bukan placeholder) untuk membuktikan pola sebelum di-copy ke 5 modul lain.

Base model **selesai** kalau 1 mini-game (pilot) bisa dimainkan end-to-end di device/emulator: buka app → pilih game → main → dapat feedback benar/salah → dapat reward → progres tersimpan → balik ke menu.

## Scope base model (apa yang DIKERJAKAN sekarang)

1. **State & persistence minimal di `core/`**
   - `ProgressRepository` — autoload singleton pakai `ConfigFile` bawaan Godot, simpan hasil per modul, baca kembali saat app dibuka.
   - Tidak pakai framework state management eksternal — pola node tree + autoload singleton + signal Godot sudah cukup untuk base model.

2. **Scene reusable tambahan di `core/scenes/`**
   - `StarRewardOverlay` — confetti (`CPUParticles2D`) + bintang saat menang (dipakai semua mini-game nanti).
   - `ParentalGateDialog` — gate sebelum masuk Settings: soal tambah sederhana + keypad angka (diganti dari "tahan tombol 3 detik" 2026-11-20, lihat Decisions Log).
   - `AppColors` — token warna satu tempat (supaya 6 mini-game terasa 1 produk).

3. **App shell (`scenes/`)** — **update 2026-11-20**, lihat `docs/WORK_BREAKDOWN.md` Part 1.7 & `obsidian-vault/Decisions Log.md`
   - `Splash.tscn` (logo ~1.2s) → `Home.tscn` (1 tombol "▶ Play" besar di tengah + tombol sekunder "Pilih Game" + ⚙ Settings).
   - Navigasi dipusatkan lewat autoload `GameFlow` (`core/scripts/game_flow.gd`) — semua pindah scene WAJIB lewat `GameFlow.goto_scene(...)` (fade + debounce), bukan `get_tree().change_scene_to_file(...)` langsung.
   - "▶ Play" → `GameFlow.start_random_game()` → mode **acak infinite**: main 1 mini-game acak dari yang `implemented`, selesai → lanjut mini-game acak lain (bukan balik Home). "Pilih Game" → grid manual, 1 sesi lalu balik Home.
   - Tombol darurat 🏠 WAJIB ada di tiap mini-game (selalu terlihat) — jalan keluar kapan saja, penting khusus mode infinite.
   - `Settings.tscn` sederhana: toggle suara on/off, tersimpan lewat `ProgressRepository`.
   - `ParentalGateDialog` terpasang di tombol Settings (soal tambah sederhana + keypad angka, bukan tahan-tombol — lihat Decisions Log 2026-11-20).

4. **1 mini-game pilot, fungsional penuh: `feature_angka`**
   - 1 level: tampilkan kumpulan objek (1-5), anak tap angka yang benar.
   - Feedback benar/salah = suara (`SfxService`, placeholder `null` sampai Farel upload file).
   - Selesai 1 level → `StarRewardOverlay` → simpan hasil via `ProgressRepository` → balik ke Home.
   - Ini jadi **pola rujukan** buat 5 modul lain di Fase 2.

5. **CI dasar**
   - Validate step (`barichello/godot-ci`, buka semua scene headless) sudah ditulis & terverifikasi lokal. Export job (APK) belum — butuh `export_presets.cfg` + keystore dulu.

6. **Dokumentasi & context**
   - Semua keputusan dicatat di Obsidian vault (`obsidian-vault/Decisions Log.md`) supaya tidak hilang antar sesi/antar anggota tim.

## Yang SENGAJA belum dikerjakan di fase ini

- 5 mini-game lain (`warna`, `hewan`, `musik`, `mewarnai`, `puzzle`) — tetap placeholder, jangan disentuh dulu.
- Asset final (ilustrasi/VO profesional) — pakai placeholder/asset sementara dulu.
- Analytics, parental dashboard, multi-child profile, IAP/ads — di luar scope base model.
- Testing framework (GUT) — ditunda sampai Dev Testing (Job 5) menilai perlu.
- CI export job (APK) — belum dibuat, lihat Job 1 di `docs/JOBS_BASE_MODEL.md`.

## Definition of Done (base model dianggap selesai kalau semua ini benar)

Godot sudah diinstall & dicoba **secara interaktif sungguhan** di sesi ini (bukan cuma headless) — user main `feature_angka` langsung (jawab semua soal benar), reward bintang + confetti muncul, dan `user://progress.cfg` terbukti terisi (4 sesi tercatat, bukan cuma dugaan). Lihat Decisions Log 2026-11-19.

- [x] Project ini bisa dibuka Godot 4.x tanpa error (`--headless --import` lolos, semua `class_name` ter-register).
- [x] Tiap scene (`Home`, `Settings`, `feature_angka`, 5 placeholder) lolos dijalankan headless tanpa error GDScript/parse.
- [x] `feature_angka`: 1 sesi (4 soal) dimainkan **sungguhan** (klik asli), semua jawaban benar → reward bintang + confetti muncul.
- [x] Progres tersimpan — `user://progress.cfg` terisi 4 entri `GameResult` nyata dengan timestamp, bukan simulasi.
- [ ] Dari **Home** (bukan langsung scene `feature_angka`), navigasi penuh Home → game → balik ke Home — belum dicoba (sesi ini langsung run `Angka.tscn` berdiri sendiri untuk tes cepat).
- [ ] Toggle suara di Settings beneran mematikan/menyalakan audio (begitu ada SFX asli dari Job 7/Farel), dan tersimpan setelah app ditutup-buka lagi.
- [ ] Masuk Settings harus lewat `ParentalGateDialog` dulu (soal tambah + keypad angka, diganti dari tahan-tombol) — kode sudah lolos headless, **menunggu konfirmasi user** hasil tes sentuhan asli.
- [x] Export debug APK berhasil (`godot --export-debug "Android" build/android/app-debug.apk`) — APK ter-sign, ~27MB. **Belum dicoba install & jalan di device/emulator Android asli** (baru sampai tahap file APK terbentuk).
- [x] `docs/` dan `obsidian-vault/` ter-update dan ter-push ke `main`.

## Urutan kerja (supaya tidak saling blok)

```
Hari 1-2   Job 1 (Bramantyo): AppColors + ProgressRepository + ParentalGateDialog + Settings +
           navigasi (SEMUA SUDAH DITULIS & lolos headless)
Hari 1-2   Job 2 (Dev 2): feature_angka — skeleton UI → wiring ke core (SUDAH DITULIS & lolos headless)
Hari 1-5   Job 2 (bagian warna) + Job 3-4 (Dev 3-4): TIDAK coding fitur dulu — siapkan spek 1 halaman
           + asset list modul masing-masing (lihat docs/JOBS_BASE_MODEL.md)
Hari 1-5   Job 5 (Dev Testing): checklist QA, test interaktif feature_angka begitu ada device/emulator
Hari 1-5   Job 6-8 (Asset 1-3): style guide → produksi ilustrasi/audio/video feature_angka duluan
Hari 5     Demo base model ke seluruh tim (coba main sungguhan, bukan cuma headless) → kalau Definition
           of Done lolos, lanjut Fase 2 (modul kedua tiap dev coding paralel)
```

Detail tugas per orang: [docs/JOBS_BASE_MODEL.md](JOBS_BASE_MODEL.md)

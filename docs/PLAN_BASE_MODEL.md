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
   - `ParentalGateDialog` — gate sederhana sebelum masuk Settings (tahan tombol 3 detik).
   - `AppColors` — token warna satu tempat (supaya 6 mini-game terasa 1 produk).

3. **App shell (`scenes/`)**
   - Navigasi: Home → Settings, Home → mini-game → balik ke Home (`get_tree().change_scene_to_file(...)`).
   - `Settings.tscn` sederhana: toggle suara on/off, tersimpan lewat `ProgressRepository`.
   - `ParentalGateDialog` terpasang di tombol Settings.

4. **1 mini-game pilot, fungsional penuh: `feature_angka`**
   - 1 level: tampilkan kumpulan objek (1-5), anak tap angka yang benar.
   - Feedback benar/salah = suara (`SfxService`, placeholder `null` sampai Asset 2 upload file).
   - Selesai 1 level → `StarRewardOverlay` → simpan hasil via `ProgressRepository` → balik ke Home.
   - Ini jadi **pola rujukan** buat 5 modul lain di Fase 2.

5. **CI dasar**
   - **Belum dibuat ulang** setelah reset dari Flutter — rencana pakai image `barichello/godot-ci` untuk export/validasi headless (lihat `docs/DOCKER.md`), belum diimplementasi.

6. **Dokumentasi & context**
   - Semua keputusan dicatat di Obsidian vault (`obsidian-vault/Decisions Log.md`) supaya tidak hilang antar sesi/antar anggota tim.

## Yang SENGAJA belum dikerjakan di fase ini

- 5 mini-game lain (`warna`, `hewan`, `musik`, `mewarnai`, `puzzle`) — tetap placeholder, jangan disentuh dulu.
- Asset final (ilustrasi/VO profesional) — pakai placeholder/asset sementara dulu.
- Analytics, parental dashboard, multi-child profile, IAP/ads — di luar scope base model.
- Testing framework (GUT) — ditunda sampai Dev Testing (Job 9) menilai perlu.
- CI/Docker untuk Godot — belum dibuat ulang, lihat Job 1 di `docs/JOBS_BASE_MODEL.md`.

## Definition of Done (base model dianggap selesai kalau semua ini benar)

Godot sudah diinstall & dicoba di sesi ini (lihat Decisions Log 2026-11-19 "Godot DIVERIFIKASI jalan") — semua 8 scene lolos headless tanpa error, 1 bug nyata (path script salah di 5 placeholder) ketemu & diperbaiki. Yang **belum** dicoba adalah interaksi sentuhan asli (hanya device fisik/emulator yang bisa) dan export APK sungguhan.

- [x] Project ini bisa dibuka Godot 4.x tanpa error (`--headless --import` lolos, semua `class_name` ter-register).
- [x] Tiap scene (`Home`, `Settings`, `feature_angka`, 5 placeholder) lolos dijalankan headless tanpa error GDScript/parse.
- [ ] Dari Home, buka `feature_angka`, selesaikan 1 level, lihat reward bintang, balik ke Home — **secara interaktif** (sentuhan/klik asli, headless run cuma membuktikan tidak crash saat load).
- [ ] Tutup app, buka lagi → hasil game sebelumnya masih tersimpan (progres tidak hilang) — cek file `user://progress.cfg` setelah main sungguhan.
- [ ] Toggle suara di Settings beneran mematikan/menyalakan audio (begitu ada SFX asli dari Job 11), dan tersimpan setelah app ditutup-buka lagi.
- [ ] Masuk Settings harus lewat `ParentalGateDialog` dulu (tahan tombol 3 detik, cek secara sentuhan asli).
- [ ] Export debug APK (`Project > Export`) berhasil, atau minimal export desktop (Windows/Linux) kalau Android export template belum disetup — butuh `export_presets.cfg` yang belum dibuat.
- [ ] `docs/` dan `obsidian-vault/` ter-update dan ter-push ke `main`.

## Urutan kerja (supaya tidak saling blok)

```
Hari 1-2   Job 1 (Bramantyo): AppColors + ProgressRepository + ParentalGateDialog (sudah ditulis) ─┐
                                                                                                      ├─> Job 3 butuh ini
Hari 1-2   Job 3 (Dev 2): skeleton UI feature_angka (belum wire ke core) ──────────────────────────┘
Hari 3-4   Job 1 + Job 3 wiring bareng: feature_angka pakai ProgressRepository,
           SfxService, StarRewardOverlay yang sudah jadi (sudah ditulis, belum dicoba di editor)
Hari 3-5   Job 2 (Dev App): Settings + navigasi + ParentalGateDialog wiring (sudah ditulis)
Hari 1-5   Job 4-8 (5 dev modul lain): TIDAK coding fitur — siapkan spek 1 halaman
           + asset list modul masing-masing (lihat docs/JOBS_BASE_MODEL.md)
Hari 1-5   Job 9 (Dev Testing): checklist QA, standby test begitu Job 3 demo-able
Hari 1-5   Job 10-15 (Asset 1-6): style guide → produksi ilustrasi/audio/video feature_angka duluan
Hari 5     Demo base model ke seluruh tim (buka di Godot Editor sungguhan) → kalau Definition
           of Done lolos, lanjut Fase 2 (5 modul coding paralel)
```

Detail tugas per orang: [docs/JOBS_BASE_MODEL.md](JOBS_BASE_MODEL.md)

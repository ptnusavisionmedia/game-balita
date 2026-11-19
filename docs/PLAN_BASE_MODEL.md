# Plan: Base Model (Fase 1)

Status: **aktif** · Dibuat: 2026-11-19

## Kenapa base model dulu, bukan langsung 7 mini-game?

Kalau 7 orang langsung coding 7 mini-game paralel sebelum ada base model yang stabil, setiap orang akan menebak sendiri cara pakai `core` (state management, cara simpan progres, cara panggil audio, cara kasih reward) — hasilnya 7 pola berbeda yang harus dirapikan ulang nanti. Base model = **1 vertical slice yang benar-benar jalan** (bukan placeholder) untuk membuktikan pola sebelum di-copy ke 6 modul lain.

Base model **selesai** kalau 1 mini-game (pilot) bisa dimainkan end-to-end di device/emulator: buka app → pilih game → main → dapat feedback benar/salah → dapat reward → progres tersimpan → balik ke menu.

## Scope base model (apa yang DIKERJAKAN sekarang)

1. **State & persistence minimal di `core`**
   - `ProgressRepository` (`ChangeNotifier` + `shared_preferences`) — simpan `GameResult` per modul, baca kembali saat app dibuka.
   - Tidak pakai Riverpod/Bloc/Provider dulu — cukup `ChangeNotifier` bawaan Flutter + `AnimatedBuilder`/`ListenableBuilder`. Alasan: barrier masuk rendah untuk 7 dev dengan level berbeda-beda; upgrade ke state management lebih besar bisa belakangan kalau memang kerasa perlu.

2. **Shared widgets tambahan di `core`**
   - `StarRewardOverlay` — animasi bintang saat menang (dipakai semua mini-game nanti).
   - `ParentalGateDialog` — gate sederhana sebelum masuk Settings atau keluar app (misal: "tahan tombol 3 detik" — cukup untuk anak kecil, tidak perlu rumit).
   - `AppTheme` — token warna/font satu tempat (supaya 7 mini-game terasa 1 produk).

3. **App shell (`app`)**
   - Navigasi: Home → Settings, Home → mini-game → balik ke Home.
   - `SettingsScreen` sederhana: toggle suara on/off, tersimpan lewat `ProgressRepository`/`shared_preferences`.
   - `ParentalGateDialog` terpasang di tombol Settings.

4. **1 mini-game pilot, fungsional penuh: `feature_angka`**
   - 1 level: tampilkan kumpulan buah (1-5), anak tap angka yang benar.
   - Feedback benar/salah = suara (`AudioService`) + animasi.
   - Selesai 1 level → `StarRewardOverlay` → simpan `GameResult` via `ProgressRepository` → balik ke Home.
   - Ini jadi **pola rujukan** buat 6 modul lain di Fase 2.

5. **CI dasar**
   - GitHub Actions: `melos run analyze` + `melos run test` jalan otomatis tiap push/PR ke `main`.

6. **Dokumentasi & context**
   - Semua keputusan dicatat di Obsidian vault (`obsidian-vault/Decisions Log.md`) supaya tidak hilang antar sesi/antar anggota tim.

## Yang SENGAJA belum dikerjakan di fase ini

- 5 mini-game lain (`warna`, `hewan`, `musik`, `mewarnai`, `puzzle`) — tetap placeholder, jangan disentuh dulu.
- Asset final (ilustrasi/VO profesional) — pakai placeholder/asset sementara dulu.
- Analytics, parental dashboard, multi-child profile, IAP/ads — di luar scope base model.
- Pemilihan state management yang lebih besar (Riverpod dll) — ditunda sampai ada sinyal nyata `ChangeNotifier` tidak cukup.

## Definition of Done (base model dianggap selesai kalau semua ini benar)

Semua kode untuk poin-poin ini **sudah ditulis dan di-push** (lihat `docs/JOBS_BASE_MODEL.md` Job 1-3) — tapi **belum ada yang menjalankan `flutter run` sungguhan** di device/emulator, karena environment sesi AI ini tidak punya Flutter SDK terpasang. Siapa pun yang punya Flutter SDK: tolong jalankan `melos bootstrap` lalu `flutter run` di `packages/app` dan centang manual poin di bawah begitu terverifikasi.

- [ ] `melos bootstrap` + `flutter run` di `packages/app` jalan tanpa error di emulator Android.
- [ ] Dari Home, buka `feature_angka`, selesaikan 1 level, lihat reward bintang, balik ke Home.
- [ ] Tutup app, buka lagi → hasil game sebelumnya masih tersimpan (progres tidak hilang).
- [ ] Toggle suara di Settings beneran mematikan/menyalakan audio, dan tersimpan setelah app ditutup-buka lagi.
- [ ] Masuk Settings harus lewat `ParentalGateDialog` dulu.
- [ ] CI hijau di GitHub (analyze + test).
- [x] `docs/` dan `obsidian-vault/` ter-update dan ter-push ke `main`.

## Urutan kerja (supaya tidak saling blok)

```
Hari 1-2   Job 1 (Bramantyo): AppTheme + ProgressRepository (sudah selesai) + ParentalGateDialog ─┐
                                                                                                    ├─> Job 3 butuh ini
Hari 1-2   Job 3 (Dev 2): skeleton UI feature_angka (belum wire ke core) ────────────────────────┘
Hari 3-4   Job 1 + Job 3 wiring bareng: feature_angka pakai ProgressRepository,
           SfxService, StarRewardOverlay yang sudah jadi
Hari 3-5   Job 2 (Dev App): SettingsScreen + navigasi + ParentalGateDialog wiring
Hari 1-5   Job 4-8 (5 dev modul lain): TIDAK coding fitur — siapkan spek 1 halaman
           + asset list modul masing-masing (lihat docs/JOBS_BASE_MODEL.md)
Hari 1-5   Job 9 (Dev Testing): checklist QA + unit test core, standby test begitu Job 3 demo-able
Hari 1-5   Job 10-15 (Asset 1-6): style guide → produksi ilustrasi/audio/video feature_angka duluan
Hari 5     Demo base model ke seluruh tim → kalau Definition of Done lolos,
           lanjut Fase 2 (6 modul coding paralel)
```

Detail tugas per orang: [docs/JOBS_BASE_MODEL.md](JOBS_BASE_MODEL.md)

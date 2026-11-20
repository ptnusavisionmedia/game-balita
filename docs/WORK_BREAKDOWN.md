# Work Breakdown — Detail Per Bagian

Pelengkap [docs/JOBS_BASE_MODEL.md](JOBS_BASE_MODEL.md). Dokumen itu bilang **apa** yang jadi tanggung jawab tiap job — dokumen ini memecahnya jadi **bagian-bagian kecil** dengan langkah konkret, input, output, dan kriteria selesai, supaya siapa pun (termasuk sesi AI baru) bisa langsung eksekusi tanpa menebak-nebak caranya.

Klaim per **bagian** (bukan per job utuh) di `docs/TASK_BOARD.md` kalau mau kerja sebagian saja — format `claim: <nomor bagian> <nama> — <nama orang>`.

---

## Job 1 — Bramantyo (`core/` + `scenes/`)

### Part 1.1 — Setup Android export template di Godot Editor ✅ SELESAI (2026-11-20)
- Dikerjakan via terminal (bukan klik GUI): download `Godot_v4.7.2-stable_export_templates.tpz` dari rilis resmi GitHub, extract, pindahkan ke `%APPDATA%\Godot\export_templates\4.7.2.stable\`.
- **Terverifikasi**: `--export-debug` jalan tanpa warning template missing.

### Part 1.2 — Buat `export_presets.cfg` (Android debug) ✅ SELESAI (2026-11-20)
- Ditulis manual (format cocok dengan contoh resmi `abarichello/godot-ci`), `package/unique_name="com.gugugaga.bayigugugaga"`, pakai debug keystore default Godot.
- **Isu yang ketemu & diperbaiki**: export gagal duluan dengan error "ETC2/ASTC texture compression is required for Android export" — ditambahkan `textures/vram_compression/import_etc2_astc=true` di `[rendering]` `project.godot`.
- **Terverifikasi SUNGGUHAN**: `godot --headless --export-debug "Android" build/android/app-debug.apk` berhasil, APK ter-sign (~27MB), bukan cuma config ditulis tanpa dicoba.
- **Catatan keamanan**: debug keystore aman di-commit (bukan untuk rilis Play Store); kalau nanti butuh release keystore asli, **jangan** commit file keystore-nya — simpan di luar repo atau GitHub Secrets (lihat `docs/DOCKER.md`).

### Part 1.3 — Tambah job export APK di CI ✅ DITULIS (2026-11-20), belum diverifikasi jalan di GitHub Actions
- `.github/workflows/ci.yml` ditambah job `export-debug-apk` mengikuti pola resmi `abarichello/godot-ci`, image di-pin ke `barichello/godot-ci:4.7.2` (sama dengan versi lokal yang sudah terverifikasi).
- **Belum diverifikasi**: belum pernah push & cek apakah job ini sungguhan sukses di GitHub Actions (sesi ini cuma verifikasi export lokal, bukan di CI container Linux) — perlu dicek begitu PR/push berikutnya jalan.

### Part 1.4 — Verifikasi navigasi penuh lewat Home (bukan buka scene langsung)
- **Tujuan**: pastikan wiring `scenes/home.gd` benar-benar jalan dari pintu masuk sungguhan, bukan cuma `Angka.tscn` berdiri sendiri (yang sudah dites 2026-11-19).
- **Langkah**: jalankan `godot --path . scenes/Home.tscn` (bukan headless) → klik tile "Angka" → mainkan sampai selesai → pastikan otomatis balik ke Home → klik tile lain, pastikan bisa dibuka juga (meski isinya placeholder).
- **Selesai kalau**: siklus Home → game → Home berjalan tanpa error, bisa diulang ke modul lain.

### Part 1.5 — Verifikasi `ParentalGateDialog` + `Settings` secara sentuhan asli
- **Tujuan**: `ParentalGateDialog` (tahan 3 detik) belum pernah dites klik asli — cuma lolos headless (tidak crash saat load), belum tahu apakah logic tahan-tombolnya kerasa benar.
- **Langkah**: dari Home klik "⚙ Pengaturan" → tombol "Tahan Di Sini" ditahan (klik-tahan mouse) → progress bar harus naik dalam 3 detik → otomatis masuk `Settings` → toggle "Suara" → klik "Kembali" → pastikan balik ke Home. Ulangi tapi klik "Batal" di gate, pastikan tidak masuk Settings.
- **Selesai kalau**: semua interaksi di atas berjalan sesuai rancangan, termasuk kasus batal.

### Part 1.6 — Keputusan: siapa pegang Privacy Policy & Play Families Policy
- **Tujuan**: ini bukan kerjaan teknis, tapi keputusan yang masih menggantung (lihat `docs/TEAM.md`).
- **Langkah**: diskusi singkat di tim — Bramantyo rangkap, atau didelegasikan ke Asset 3, atau tambah orang baru.
- **Output**: nama pemegang tercatat di `docs/TEAM.md` (ganti baris "belum ada pemegang jelas").

---

## Job 2 — Dev 2 (`feature_angka` selesai; `feature_warna` menyusul)

### Part 2.1 — Tulis spek `feature_warna`
- **Langkah**: isi `obsidian-vault/Specs/feature_warna.md` (sudah ada template kosong) — ikuti format `feature_angka.md`: aturan main, jumlah soal, kondisi menang, daftar asset.
- **Selesai kalau**: file terisi lengkap, Asset 1/4 (ilustrator) bisa mulai produksi dari spek ini tanpa tanya balik.

### Part 2.2 — (Setelah base model demo lolos) Scaffold `feature_warna` dari pola `feature_angka`
- **Langkah**: copy struktur `features/feature_angka/angka.gd` sebagai referensi pola (session/reward/progress), tulis ulang logic sesuai spek warna (bukan copy-paste literal).
- **Blocking**: **tunggu** `feature_angka` lolos demo interaktif dulu (lihat `docs/PLAN_BASE_MODEL.md`) — jangan mulai sebelum itu.

---

## Job 3 — Dev 3 (spek `feature_hewan` + `feature_musik`)

### Part 3.1 — Spek `feature_hewan`
Isi `obsidian-vault/Specs/feature_hewan.md`: aturan main (dengar suara hewan → tap gambar yang benar), jumlah soal, daftar asset (gambar hewan + file audio suara hewan).

### Part 3.2 — Spek `feature_musik`
Isi `obsidian-vault/Specs/feature_musik.md`: aturan main (tap nada, bukan drag presisi), jumlah tombol nada, daftar asset audio nada.

---

## Job 4 — Dev 4 (spek `feature_mewarnai` + `feature_puzzle`)

### Part 4.1 — Spek `feature_mewarnai`
Isi `obsidian-vault/Specs/feature_mewarnai.md`: area target warna (toleransi snap longgar), daftar asset pola gambar + warna.

### Part 4.2 — Spek `feature_puzzle`
Isi `obsidian-vault/Specs/feature_puzzle.md`: jumlah keping (≤6 untuk level awal), daftar asset gambar yang dipecah jadi puzzle.

---

## Job 5 — Dev Testing

### Part 5.1 — Susun `docs/QA_CHECKLIST.md`
- **Isi minimal**: hit-area ≥64dp tiap tombol, suara kebaca jelas, reward (bintang+confetti) muncul, progres tersimpan setelah app ditutup-buka, device low-end tidak lag/nge-freeze.

### Part 5.2 — Evaluasi addon GUT (Godot Unit Test)
- **Langkah**: baca [github.com/bitwes/Gut](https://github.com/bitwes/Gut), putuskan perlu dipasang sekarang atau ditunda. Kalau perlu: install via AssetLib di Godot Editor, tulis 1 test contoh untuk `ProgressRepository`.
- **Output**: keputusan tercatat di `obsidian-vault/Decisions Log.md`.

### Part 5.3 — Test interaktif `feature_angka` di device Android asli
- **Prasyarat**: Part 1.2-1.3 selesai (ada APK untuk di-install).
- **Langkah**: install APK ke 1 device Android low-end asli, mainkan penuh pakai checklist Part 5.1, catat bug yang ketemu.
- **Kalau nemu bug**: perbaiki langsung (bukan cuma laporkan, lihat `docs/ROLES.md`), PR terpisah + tag Dev 2.

### Part 5.4 — Siapkan device low-end
Tentukan 1 device Android fisik (bukan cuma emulator) yang jadi acuan "low-end" untuk testing seterusnya.

---

## Job 6 — Asset 1 (Ilustrasi)

### Part 6.1 — Style guide ilustrasi
Isi `obsidian-vault/Specs/style-guide-ilustrasi.md`: gaya gambar (flat vector/semi-3D/hand-drawn), palet warna karakter, ukuran minimum elemen interaktif. Jadi acuan Part 6.2 dan modul-modul lain nanti.

### Part 6.2 — Ilustrasi `feature_angka` (ganti ikon hati placeholder)
Buah/objek 1-5 sesuai spek pilot (`obsidian-vault/Specs/feature_angka.md`). Taruh file `.png`/`.svg` di `features/feature_angka/assets/images/`.

### Part 6.3 — App icon & splash screen
Draft icon aplikasi (gantikan `icon.svg` default Godot) + splash screen sesuai style guide Part 6.1.

---

## Job 7 — Asset 2 (Audio/VO)

### Part 7.1 — SFX dasar
Rekam/cari: suara tap, suara benar, suara coba-lagi (ramah anak, bukan nada negatif). Format `.wav`/`.ogg` pendek. Taruh di `features/feature_angka/assets/audio/`.

### Part 7.2 — VO angka 1-5
Rekam voice-over "satu", "dua", ..., "lima" bahasa Indonesia, nada ceria.

### Part 7.3 — Integrasi ke kode (koordinasi dengan Dev 2)
Setelah Part 7.1-7.2 selesai, update `features/feature_angka/angka.gd`: ganti `SfxService.play(null)` jadi `SfxService.play(preload("res://features/feature_angka/assets/audio/<nama_file>"))` — ini **boleh dikerjakan Asset 2 sendiri** (scope `assets/audio/` miliknya) atau koordinasi PR bareng Dev 2 kalau butuh ubah logic pemanggilan.

---

## Job 8 — Asset 3 (Video/Marketing)

### Part 8.1 — Riset referensi
Kumpulkan referensi video promo app sejenis di `marketing/references/` (link atau screenshot, bukan video orang lain full).

### Part 8.2 — Storyboard video promo
Draft storyboard kasar (belum render) — bisa mulai sebelum base model demo-able.

### Part 8.3 — Draft listing Play Store Console
Judul, deskripsi, kategori — **jangan publish**, tunggu APK dari Part 1.2-1.3 dan keputusan Privacy Policy dari Part 1.6 (Play Store wajib privacy policy sebelum submit app anak-anak).

### Part 8.4 — Rekam video demo pertama
Setelah Part 1.4 (navigasi Home) & Part 6.2 (ilustrasi) selesai, rekam demo `feature_angka` dari Home sampai reward untuk video promo.

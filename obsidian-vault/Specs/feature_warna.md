# Spec: feature_warna

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 2 (`docs/TEAM.md`), modul kedua Dev 2 setelah `feature_angka`. Ikuti pola struktur `feature_angka` (1 mekanik, bukan 2 seperti `feature_hewan` — lihat catatan di spek itu, 2 mekanik bukan standar baru).

Interaksi utama: **Tap** (lihat `docs/UI_UX_DESIGN.md` tabel "Pola interaksi per tipe mini-game").

## Aturan main level 1

- Tampilkan 1 **lingkaran warna acuan** besar + nama warnanya (misal lingkaran merah + teks "Merah") — kenapa pakai nama warna juga (beda dari `feature_angka` yang hindari simbol abstrak): warna adalah kategori yang memang butuh nama/label buat dipelajari (beda dari angka yang dipelajari lewat benda konkret dulu), nama warna sendiri bagian dari kategorisasi awal (Piaget) & kosakata.
- Di bawahnya tampil 3 pilihan **benda sehari-hari** (emoji placeholder sampai ilustrasi asli ada — pola sama `feature_hewan`), 1 benda warnanya cocok sama lingkaran acuan, 2 pengecoh warna lain. Contoh: acuan "Merah" → pilihan 🍎 (merah, benar), 🍋 (kuning), 🍃 (hijau).
- Anak tap benda yang warnanya sama dengan lingkaran acuan.

## Pool warna awal (6, reuse `AppColors` yang sudah ada biar konsisten 1 produk)

| Warna | Token `AppColors` | Contoh benda (placeholder emoji) |
|---|---|---|
| Kuning | `SUNSHINE` | 🍋 Lemon |
| Hijau | `LEAF` | 🍃 Daun |
| Oranye | `CORAL`/`ACCENT_WARNA` | 🍊 Jeruk |
| Ungu | `ACCENT_MUSIK` | 🍇 Anggur |
| Biru | *(baru, Dev 2 pilih hex yang senada palet — bukan biru neon)* | 🫐 Blueberry |
| Merah | *(baru, pakai merah hangat bukan merah murni `#FF0000`, konsisten prinsip warna di `docs/UI_UX_DESIGN.md`)* | 🍎 Apel |

**Catatan**: "hindari merah murni" di `docs/UI_UX_DESIGN.md` itu konteksnya **warna feedback salah**, bukan larangan mengajarkan warna merah sebagai konsep — anak tetap perlu belajar nama warna "merah" sebagai kategori. Yang dihindari cuma memakai merah terang/menyala sebagai elemen UI yang terasa menghukum.

## Jumlah soal per sesi

- 3-5 soal per sesi, warna acuan diacak tanpa pengulangan berurutan (pola sama `feature_angka`).

## Kondisi selesai

- Selesai sesi → `StarRewardOverlay` (confetti + ikon ✓, **tanpa** jumlah bintang — `docs/UI_UX_DESIGN.md` prinsip #4) → `ProgressRepository.record_result("feature_warna", ...)` → auto-lanjut lewat `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 wajib ada (pola dari `feature_angka`).

## Feedback

- Jawaban benar: suara "benar" + animasi ringan (benda terpilih bergoyang/berkedip, pola sama modul lain).
- Jawaban salah: suara "coba lagi", tidak ada penalti, boleh coba lagi di soal yang sama.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| Ilustrasi 6 benda (apel, lemon, daun, jeruk, anggur, blueberry — atau ganti sesuai selera Asset 1) | gambar | Ganti placeholder emoji, konsisten style guide |
| `sfx_correct.mp3`, `sfx_try_again.mp3` | audio | Reuse file dari `feature_angka` kalau sudah ada, jangan duplikat |
| Data warna+benda (nama warna, hex, path gambar) | data | 1 file `.json` di `features/feature_warna/data/`, pola sama `feature_hewan` — supaya nambah warna/benda baru tidak perlu sentuh `.gd` |

## Catatan lain

- **1 mekanik saja** (self-correcting, lewat Home seperti biasa) — modul ini TIDAK perlu mekanik "Bareng Orang Tua" terpisah seperti `feature_hewan`, kecuali ada permintaan baru. Kartu panduan orang tua untuk modul ini sudah ada di `core/data/parent_guide.json` (statis, bukan gameplay beda).
- Placeholder emoji & `SfxService.play(null)` dulu sampai aset asli ada — pola sama `feature_hewan`, lihat catatan placeholder di sana.

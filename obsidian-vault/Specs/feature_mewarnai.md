# Spec: feature_mewarnai

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 4 (`docs/TEAM.md`), modul pertama Dev 4.

Interaksi utama: **Tap** warna dari palet, lalu **tap** ke area pola (bukan drag-paint pixel bebas — lihat batasan prototipe di bawah). Area target harus besar & bertoleransi (lihat `docs/UI_UX_DESIGN.md` tabel interaksi).

## Beda struktur — **sengaja tidak ada jawaban benar/salah** (sama seperti `feature_musik`)

Mewarnai itu ekspresi, bukan kuis — tidak ada "warna yang benar" buat tiap area. Anak bebas pilih warna apa pun untuk area mana pun.

## Aturan main level 1

- Tampilkan 1 gambar sederhana dipecah jadi **2-4 area besar** (contoh: gambar kelinci sederhana → badan, kepala, 2 telinga). Area awalnya abu-abu/outline polos.
- Di bawah, palet 4-6 warna (`AppColors.ACCENT_MEWARNAI` + beberapa warna lain, reuse pool warna dari `feature_warna` kalau cocok — jangan buat set warna baru lagi tanpa alasan, lihat `docs/LIBRARIES.md` prinsip jangan duplikat).
- Anak tap 1 warna di palet (jadi "warna aktif", ditandai border/highlight), lalu tap area pola → area itu terisi warna aktif.
- Anak bisa ganti-ganti warna & area sebebasnya, termasuk mewarnai ulang area yang sama dengan warna lain.

**Batasan prototipe (disclosure, bukan bug)**: ini **bukan** canvas gambar bebas piksel-per-piksel (true freehand drawing) — itu butuh sistem drawing custom yang jauh lebih kompleks buat base model. Versi ini "isi area yang sudah ditentukan", cukup buat memenuhi tujuan motorik halus & ekspresi warna di usia 1-5 tahun tanpa kompleksitas teknis freehand. Kalau nanti tim mau upgrade ke freehand drawing sungguhan, itu keputusan Fase 2+ terpisah, bukan base model.

## Jumlah "soal" per sesi → diganti jadi jumlah area

- Sesi selesai setelah **semua area (2-4) sudah diwarnai minimal 1 kali** — tidak masalah kalau diulang-ulang/ganti warna sebelum itu, yang dihitung cuma "pernah diisi sekali".

## Kondisi selesai

- Semua area terisi → `StarRewardOverlay` (confetti + ikon ✓, tanpa jumlah bintang) → `ProgressRepository.record_result("feature_mewarnai", ...)` (field `stars_earned` diisi jumlah area, sama pola `feature_musik`) → auto-lanjut `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 wajib ada.

## Feedback

- Tap warna di palet: highlight ringan (bukan suara "benar/salah" — cuma konfirmasi pilihan).
- Tap area: langsung terisi warna aktif + suara "tap" netral (reuse SFX tap dasar).
- **Tidak ada** suara "salah"/"coba lagi" sama sekali di modul ini.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| 1-2 gambar sederhana (outline, dipecah 2-4 area per gambar, format yang gampang diubah jadi beberapa `Polygon2D`/`ColorRect` area) | gambar/data | Mulai 1 gambar (misal kelinci) cukup buat level 1, tambah belakangan |
| `sfx_tap.mp3` | audio | Reuse dari modul lain kalau sudah ada, jangan duplikat |
| Data area (nama area, bentuk/posisi) | data | 1 file per gambar di `features/feature_mewarnai/data/` |

## Catatan lain

- Palet warna **reuse** dari `feature_warna` (jangan definisikan ulang warna dari nol) — konsisten 1 produk, dan 2 modul ini sekarang "berbagi konsep warna" walau gameplay beda total.
- Placeholder: area pola boleh pakai bentuk vektor sederhana (`Polygon2D`/`ColorRect`, pola sama `ModuleIcon`) dulu sampai ilustrasi asli ada.

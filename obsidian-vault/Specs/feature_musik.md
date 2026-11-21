# Spec: feature_musik

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 3 (`docs/TEAM.md`), modul kedua Dev 3 setelah `feature_hewan`.

Interaksi utama: **Tap (bukan drag)**, tombol nada besar, **tidak perlu presisi musikal** (lihat `docs/UI_UX_DESIGN.md` tabel interaksi).

## Beda struktur dari `feature_angka`/`feature_warna`/`feature_hewan` — **sengaja tidak ada "soal"**

Modul ini **murni eksplorasi bebas** (mirip ide "Jelajah Suara" dari brainstorm permainan tumbuh-kembang, `docs/PLAN_TUMBUH_KEMBANG.md`), bukan kuis tebak-jawab:

- Alasan: "tidak perlu presisi musikal" artinya memang tidak ada target benar/salah untuk dicapai — musik buat usia 1-5 tahun paling pas dipakai buat eksplorasi bebas & regulasi emosi, bukan dinilai tepat/tidak tepatnya.
- Konsekuensi desain: **tidak ada mekanik jawaban benar/salah sama sekali** di modul ini (beda dari 3 modul sebelumnya) — ini otomatis 100% selaras prinsip #4 `docs/UI_UX_DESIGN.md` tanpa perlu usaha ekstra.

## Aturan main level 1

- Tampilkan 4-6 tombol nada besar (`BigRoundButton`, warna beda-beda pakai `AppColors.ACCENT_MUSIK` sebagai aksen dasar + variasi kecerahan).
- Tap tombol mana pun → keluar 1 nada pendek + animasi ringan (tombol membesar sebentar/berkedip) — **tidak ada urutan yang harus diikuti, tidak ada "pola untuk ditiru dengan benar"**.
- Anak boleh tap sebanyak & seacak apa pun, sesi tidak "gagal" dalam bentuk apa pun.

## Jumlah "soal" per sesi → diganti jadi jumlah ketukan

- Tidak ada soal — sesi dianggap selesai setelah anak tap tombol nada **total 8 kali** (bisa tombol yang sama berkali-kali, tidak harus coba semua). Angka 8 cuma perkiraan awal, boleh disesuaikan Dev 3 pas dicoba (lihat `obsidian-vault/Specs/feature_hewan.md` pola yang sama soal angka awal).

## Kondisi selesai

- Setelah 8 ketukan → `StarRewardOverlay` (confetti + ikon ✓, **tanpa** jumlah bintang) → `ProgressRepository.record_result("feature_musik", ...)` (di sini `stars_earned` tidak punya arti "benar/salah", cukup isi jumlah ketukan sebagai data eksplorasi, sama seperti field `stars_earned` dipakai ulang di mode Bareng Orang Tua `feature_hewan`) → auto-lanjut lewat `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 wajib ada.

## Feedback

- Tiap tap: suara nada (beda per tombol) + animasi. **Tidak ada** suara "salah"/"coba lagi" — karena memang tidak ada jawaban salah di modul ini.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| `nada_1.mp3` ... `nada_6.mp3` | audio | 4-6 nada pendek berbeda, ramah anak (bukan nada musik rumit) |
| Ilustrasi/ikon tombol nada (opsional, warna polos dulu cukup) | gambar | Boleh ditunda — tombol warna solid (`BigRoundButton`) sudah cukup jelas tanpa ilustrasi |
| Data nada (path audio per tombol) | data | 1 file `.json` di `features/feature_musik/data/`, pola sama modul lain |

## Catatan lain

- Modul ini **bukan pola rujukan** buat modul lain (beda dari `feature_angka`) — struktur "tanpa soal" ini khusus musik karena memang cocoknya begitu, bukan standar baru.
- Placeholder: `SfxService.play(null)` dulu sampai 4-6 file nada asli ada dari Farel.

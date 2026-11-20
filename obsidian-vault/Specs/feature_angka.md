# Spec: feature_angka (PILOT — base model)

Status: jadi contoh pola untuk `feature_warna`, `feature_hewan`, `feature_musik`, `feature_mewarnai`, `feature_puzzle`.

## Aturan main level 1

- Tampilkan sekumpulan 1-5 ikon buah/objek yang sama.
- Di bawahnya tampil 3 pilihan angka (1 benar, 2 pengecoh berdekatan, misal objeknya 3 → pilihan [2, 3, 4]).
- Anak tap salah satu angka.

## Jumlah soal per sesi

- 3-5 soal per sesi, angka & jumlah objek diacak tanpa pengulangan berurutan.

## Kondisi menang / selesai

- Selesai 1 sesi (3-5 soal) → tampilkan `StarRewardOverlay` (confetti + ikon ✓, **tidak** menampilkan jumlah bintang/skor ke anak — lihat `docs/UI_UX_DESIGN.md` prinsip #4) → simpan `GameResult` lewat `core.ProgressRepository` (data internal, bukan ditampilkan) → auto-lanjut lewat `GameFlow.finish_game_session()` (bukan "tombol balik ke Home" manual, lihat `docs/ARCHITECTURE.md`).

## Feedback

- Jawaban benar: suara "benar" + animasi ringan (misal objek bergoyang/berkedip).
- Jawaban salah: suara "coba lagi" (bukan suara negatif/menakutkan), tidak ada penalti, boleh coba lagi di soal yang sama.

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| `fruit_apple.png` ... dst | gambar | ikon buah/objek, 1-5 jenis cukup untuk mulai |
| `sfx_correct.mp3` | audio | efek suara jawaban benar |
| `sfx_try_again.mp3` | audio | efek suara jawaban salah (ramah anak) |

## Catatan lain

- Modul lain tidak perlu niru soal "angka"-nya, tapi niru **strukturnya**: layar soal → feedback → reward → simpan hasil → balik Home. Itu pola yang mau dibuktikan di base model.

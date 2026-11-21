# Spec: feature_hewan

Status: **spek ditulis 2026-11-21**, belum dikerjakan — PIC implementasi Dev 3 (`docs/TEAM.md`). Modul kedua setelah `feature_angka` yang dapat spek lengkap, sekaligus modul pertama yang pakai 2 mekanik (Mandiri + Bareng Orang Tua) hasil dari `docs/PLAN_TUMBUH_KEMBANG.md`.

**Keputusan desain penting** (lihat `obsidian-vault/Decisions Log.md` 2026-11-21): 2 mekanik beda, tapi **cuma 1 titik masuk yang menentukan** — anak tidak pernah ditanya "mau main sama siapa?" di Home. Fork-nya ditentukan dari jalur masuknya:
- Home → "▶ Play" / "Pilih Game" (jalur normal, anak sendiri) → **Mekanik Mandiri**.
- Settings → "Panduan Orang Tua" → kartu `feature_hewan` → tombol "Mulai main bareng" (sudah di belakang `ParentalGateDialog`) → **Mekanik Bareng Orang Tua**.

---

## Konten: daftar hewan (pool awal, 6 ekor)

Pilih hewan yang familiar buat anak Indonesia usia 1-5 & suaranya mudah dikenali:

| Hewan | Nama tampil | Suara (deskripsi buat Asset 2/Farel rekam) |
|---|---|---|
| Kucing | "Kucing" | "Meong" |
| Anjing | "Anjing" | "Guk guk" |
| Sapi | "Sapi" | "Moo" |
| Ayam | "Ayam" | "Kukuruyuk"/petok |
| Kambing | "Kambing" | "Mbeek" |
| Bebek | "Bebek" | "Kwek kwek" |

Mulai 6 cukup untuk base model modul ini (sama seperti `feature_angka` yang mulai dari pool kecil) — bisa ditambah belakangan tanpa ubah logic (data-driven, lihat bagian Asset).

## Mekanik 1 — Mandiri (default, lewat Home)

Pola **identik** `feature_angka` (sudah terbukti jalan) — cuma ganti domain dari angka ke hewan:

- 1 soal = dengar suara 1 hewan (`AudioStreamPlayer`) → tampil 3 pilihan gambar hewan (1 benar, 2 pengecoh acak dari pool) → anak tap gambar yang menurutnya sesuai suaranya.
- **Tidak ada tanda benar/salah** ditampilkan ke anak — jawaban benar: suara "benar" ramah + animasi ringan (gambar hewan terpilih bergoyang/berkedip). Jawaban salah: suara "coba lagi", boleh coba lagi, soal tidak berganti.
- 3-5 soal per sesi, hewan diacak tanpa pengulangan berurutan (pola sama `feature_angka`).
- Selesai sesi → `StarRewardOverlay` (confetti + ikon ✓, **tanpa** jumlah bintang — lihat `docs/UI_UX_DESIGN.md` prinsip #4) → `ProgressRepository.record_result("feature_hewan", ...)` → auto-lanjut lewat `GameFlow.finish_game_session()`.
- Tombol darurat 🏠 tetap ada (pola wajib dari `feature_angka`).

## Mekanik 2 — Bareng Orang Tua (lewat "Panduan Orang Tua" → "Mulai main bareng")

**Bukan kuis dengan jawaban benar/salah** — murni eksplorasi berpasangan dengan orang tua, supaya orang tua yang pegang pace (scaffolding ala Vygotsky, lihat `docs/PLAN_TUMBUH_KEMBANG.md` bagian 1.4):

- Tampil 1 hewan per giliran (acak dari pool, urutan beda dari sesi Mandiri supaya tidak kelihatan "sama aja").
- Tombol "🔊 Dengar suaranya" — putar suara hewan tersebut, bisa ditekan berkali-kali.
- Gambar hewan **disamarkan** (silhouette/blur ringan) selagi anak & orang tua menebak dari suaranya saja.
- Tombol "🔍 Lihat Jawaban" — buka gambar asli + nama hewan ditampilkan jelas + suara diputar ulang sekali. **Tidak ada ✓/✗ atau pesan "benar/salah" di sini** — cuma menampilkan, bukan menilai tebakan.
- Tombol "Hewan lain →" lanjut ke hewan berikutnya (acak, tidak berulang sampai pool habis lalu di-shuffle ulang).
- Setelah 4 hewan (jumlah tetap, supaya sesinya terasa "selesai", bukan cuma berhenti sembarang) → `StarRewardOverlay` yang sama seperti mekanik Mandiri → `ProgressRepository.record_result("feature_hewan", ...)` → `GameFlow.finish_game_session()` (karena masuk bukan lewat `start_random_game()`, `infinite_mode` tetap `false`, jadi otomatis balik ke Home, bukan lempar ke game acak lain — lihat catatan arsitektur di bawah).
- Tombol darurat 🏠 tetap ada.
- **Teks bantu buat orang tua** (subtitle kecil di bawah tombol "🔊", sekali muncul di hewan pertama saja biar tidak berulang-ulang mengganggu): kalimat scaffolding dari `docs/PLAN_TUMBUH_KEMBANG.md` bagian 3, contoh *"Coba tanya: 'ini suaranya siapa?' sebelum buka jawabannya."*

## Catatan arsitektur (koordinasi dengan Bramantyo, scope `core/`)

- Butuh 1 state baru di `GameFlow` — misal `guided_mode: bool` (pola sama seperti `infinite_mode` yang sudah ada), diset `true` oleh fungsi baru (misal `GameFlow.start_guided_game(scene_path)`) yang dipanggil tombol "Mulai main bareng" di `ParentGuide.tscn` (Fase B `docs/PLAN_TUMBUH_KEMBANG.md`). `go_home()` reset `guided_mode` ke `false` lagi (sama seperti `infinite_mode` sekarang), supaya main lewat Home berikutnya balik ke mekanik Mandiri default.
- `features/feature_hewan/hewan.gd` baca `GameFlow.guided_mode` di `_ready()` buat pilih render mana (Mandiri vs Bareng Orang Tua) — **1 script, 2 cabang**, bukan 2 scene terpisah, supaya data hewan (bagian Konten di atas) tidak dobel ditulis.
- Ini perubahan `core/` pertama yang didorong oleh kebutuhan 1 modul `feature_*` — ikuti aturan `docs/ARCHITECTURE.md` (perubahan `core/` lewat PR yang direview Bramantyo).

## Asset yang dibutuhkan

| File | Jenis | Keterangan |
|---|---|---|
| `kucing.png`, `anjing.png`, `sapi.png`, `ayam.png`, `kambing.png`, `bebek.png` | gambar | Ilustrasi 6 hewan, gaya konsisten dengan style guide (`docs/TASK_BOARD.md` — Asset 1) |
| `sfx_kucing.mp3` ... dst (6 file) | audio | Suara masing-masing hewan, pendek (~1-2 detik), lihat tabel Konten | 
| `sfx_correct.mp3`, `sfx_try_again.mp3` | audio | Reuse file yang sama dari `feature_angka` kalau sudah ada (jangan duplikat kalau cocok) |
| Data hewan (nama, path gambar, path suara) | data | Taruh di 1 file (`.json`/`.tres`) di `features/feature_hewan/`, bukan hardcode array panjang di `.gd` — supaya nambah hewan ke-7 dst nanti tinggal edit data, tidak sentuh logic |

## Catatan lain

- **Jangan** tiru pola ini ke `feature_warna`/`feature_musik`/`feature_mewarnai`/`feature_puzzle` secara otomatis — mekanik ganda (Mandiri + Bareng Orang Tua) ini keputusan khusus `feature_hewan` karena idenya memang datang dari sini. Modul lain tetap ikut pola `feature_angka` (1 mekanik) kecuali ada permintaan serupa.
- Jumlah hewan (6) & jumlah giliran mode Bareng Orang Tua (4) itu angka awal, boleh disesuaikan Dev 3 kalau kepanjangan/kependekan pas dicoba sungguhan — bukan angka yang harus pas sama persis.

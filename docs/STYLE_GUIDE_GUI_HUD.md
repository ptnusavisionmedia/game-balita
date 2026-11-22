# Style Guide — GUI/HUD (tombol, ikon, panel, animasi)

Pelengkap `docs/STYLE_GUIDE_ILUSTRASI.md` (yang itu untuk ilustrasi dunia
game: hewan/buah/mewarnai/dsb). Dokumen ini khusus **chrome UI** — tombol,
ikon, panel/dialog, dan cara menganimasikannya — supaya konsisten 1 sistem,
bukan tiap layar beda gaya.

Ditulis 2026-11-22 setelah user minta saran desain HUD/GUI profesional +
daftar prompt buat digenerate lewat ChatGPT.

## 1. Temuan audit (kondisi sekarang)

Dari kode + screenshot yang dikirim user:

1. **Sudah konsisten & bagus**: `BigRoundButton` (bulat, 120×120, warna solid
   aksen per modul) dipakai semua pilihan jawaban di 4 modul kuis. Tombol
   pil "Play"/"Pilih Game" di Home (gambar asli, rasio 3:1). Hit-area besar
   di semua tempat (prinsip anak 1-5 tahun — bukan trend visual, ini
   kebutuhan motorik).
2. **Baru ditemukan & sudah diperbaiki** (lihat Decisions Log 2026-11-22):
   panel `ParentalGateDialog` TIDAK punya background solid (pakai
   `PanelContainer` tanpa stylebox eksplisit) — teks/tombol Home di
   belakangnya bocor tembus, dialog jadi susah dibaca. Sekarang dikasih
   `StyleBoxFlat` solid (krem + border) — **ini contoh kenapa Dev harus
   selalu kasih stylebox eksplisit ke `PanelContainer`, jangan andalkan
   tema default Godot.**
3. **Belum konsisten**: di luar `BigRoundButton` dan 2 tombol pil Home,
   SEMUA tombol lain (keypad angka di gate dialog, "Dengar Suaranya",
   "Lihat Jawaban", "Kembali", daftar Panduan Orang Tua, toggle suara)
   masih pakai tombol default Godot (abu-abu polos, tanpa identitas
   visual). Ini yang bikin app "kurang menarik" dirasakan tidak cuma dari
   ilustrasi dunia game, tapi juga dari chrome UI yang terasa generik.
4. **Belum ada bahasa animasi** selain: scale-in ikon di `StarRewardOverlay`
   + fade hitam pindah scene (`GameFlow.goto_scene`). Tombol tidak ada
   feedback tekan (press bounce), dialog muncul langsung tanpa transisi.

## 2. Sistem ukuran & rasio (token) — PAKAI INI, jangan bikin ukuran baru sembarangan

| Token | Ukuran dasar (px, base 1280×720) | Rasio | Dipakai untuk |
|---|---|---|---|
| `icon.xs` | 56×56 | 1:1 | Ikon nav kecil (home darurat 🏠, gear settings) — **pertimbangkan naik ke 64×64**, lihat catatan #1 di bawah |
| `icon.s` | 88×88 | 1:1 | Tombol ikon sekunder (toggle suara, reveal, keypad digit) |
| `icon.m` | 120×120 | 1:1 | `BigRoundButton` (sudah ada, jangan diubah) — juga cocok buat tombol ikon besar baru |
| `icon.l` | 160–220 | 1:1 | Maskot/reward display (bukan tombol — tidak diklik) |
| `pill.primary` | 480×160 | 3:1 | 1 CTA utama per layar (sekarang cuma "▶ Play") |
| `pill.secondary` | 342×114 | 3:1 | CTA kedua (sekarang cuma "Pilih Game") |
| `pill.action` (BARU, diusulkan) | 280×93 | 3:1 | Tombol aksi text+icon generik (Kembali, Dengar Suaranya, Lihat Jawaban) — biar seragam sama 2 pill Home, bukan tombol default Godot lagi |
| `card.panel` | fleksibel | — | **TETAP code-drawn `StyleBoxFlat`** (lihat prinsip #3), JANGAN generate gambar panel kotak solid |

**Catatan #1 (saran profesional)**: 56px untuk `icon.xs` ada di batas bawah
yang direkomendasikan riset untuk jari ANAK (umumnya 88-120px direkomendasikan
Montessori/UX anak). Tapi tombol 🏠/⚙ ini ditujukan untuk **orang tua**
(keluar darurat, buka settings), bukan aksi utama anak — jadi 56px masih
masuk akal selama tidak jadi satu-satunya jalan keluar anak dari sesi
bermain. Kalau mau lebih aman, naikkan ke `icon.s` (88px).

## 3. Prinsip — JANGAN generate aset yang tidak perlu

Supaya tidak buang-buang generate (dan supaya hasilnya tidak kebentur
kelemahan image generator), 3 aturan:

1. **Panel/dialog background SELALU code-drawn** (`StyleBoxFlat`), bukan
   gambar. Alasan: `StyleBoxFlat` scale sempurna di ukuran berapa pun
   (rounded corner tetap tajam), nol risiko blur/pecah, nol risiko bug
   9-slice (lihat histori bug tombol Home 2026-11-22). Simpan cuma WARNA +
   border di `AppColors`, bukan file gambar.
2. **Jangan minta maskot "Wawa" multi-frame (spritesheet jalan/bicara
   lipsync)** ke ChatGPT — generator gambar-tunggal SULIT menjaga
   konsistensi karakter antar-frame (muka/proporsi gampang berubah tipis
   tiap generate ulang), hasilnya malah terlihat "goyang" kalau
   di-flipbook. Yang sudah dikerjakan (4 pose statis: netral/melambai/
   merayakan/berbicara) itu pendekatan yang BENAR — gerakannya nanti
   dibikin di Godot (`Tween`/`AnimationPlayer`: scale bounce, posisi
   geser, rotasi kecil), bukan lewat frame gambar baru.
3. **Jangan minta "versi tablet" terpisah.** `project.godot` sudah pakai
   `window/stretch/mode="canvas_items"` + `aspect="expand"` — 1 set aset
   otomatis scale proporsional di HP maupun tablet (sudah dibuktikan
   bekerja sejak `GameBackground`). Yang justru perlu diperhatikan:
   **generate semua PNG tombol/ikon di resolusi SUMBER besar** (lihat
   tabel §2 "Ukuran dasar" dikali minimal 2×, misal `icon.m` digenerate di
   kanvas ~256×256 bukan 120×120) supaya tetap tajam waktu di-scale UP ke
   tablet besar — Godot bisa scale DOWN gambar besar dengan mulus, tapi
   scale UP gambar kecil selalu pecah/blur.

## 4. Animasi — mana yang butuh aset, mana yang cukup kode

| Animasi | Butuh aset gambar baru? | Cara kerjanya |
|---|---|---|
| Tombol "tertekan" (scale kecil + balik, bounce) | ❌ Tidak | `Tween` di `button_down`/`button_up` — scale 0.92 lalu balik ke 1.0 pakai `TRANS_BACK`. Bisa jadi 1 helper dipakai semua tombol (lihat §6 saran implementasi) |
| Dialog/overlay muncul (pop-in, bukan langsung nongol) | ❌ Tidak | `Tween` scale dari 0.8→1.0 + fade alpha 0→1, ~0.2 detik. Sudah ada contohnya di `StarRewardOverlay` icon, tinggal dipindah ke level Control dialog-nya juga |
| Maskot "bernapas"/idle kecil di Splash | ❌ Tidak | `Tween` loop kecil: posisi Y naik-turun 6px, 1.5 detik, `TRANS_SINE` |
| Confetti reward | ❌ Tidak | Sudah pakai `CPUParticles2D` bawaan Godot, tidak perlu gambar/spritesheet |
| Transisi antar scene (fade) | ❌ Tidak | Sudah ada di `GameFlow.goto_scene` |
| Ekspresi maskot ganti pose (netral→merayakan) | ⚠️ Sebagian | Gambar 4 pose SUDAH ADA — tinggal `TextureRect.texture = load(...)` ganti pas momen yang tepat (reward = sudah, splash = sudah). Tidak perlu generate pose baru dulu |
| Efek "pecah/confetti" khusus bentuk puzzle/shape saat cocok | ❌ Tidak | `CPUParticles2D` kecil di titik slot, warna ambil dari `color_hex` piece — reuse pola `StarRewardOverlay` |

**Kesimpulan**: hampir semua animasi yang bikin app "terasa hidup" BISA
dikerjakan tanpa generate aset baru sama sekali — ini kerjaan Dev (Tween),
bukan Asset creator. Yang digenerate cukup gambar STATIS (§5), gerakannya
dari kode.

## 5. Daftar aset + prompt siap pakai (generate lewat ChatGPT)

Gaya & negative prompt dasar **SAMA PERSIS** seperti
`docs/STYLE_GUIDE_ILUSTRASI.md` §1-4 (kartun ramah, flat-ish dengan sedikit
shading lembut, TIDAK realistis, warna hangat jenuh untuk elemen interaktif,
tanpa teks ter-bake di gambar, latar transparan PNG kecuali disebut lain).
Setiap prompt di bawah TAMBAHKAN baris ini di akhir:

> "Flat cartoon style for toddler educational app, thick clean outlines,
> warm saturated colors, soft rounded shapes, no realistic textures, no
> text baked into image, transparent background, high resolution
> (at least 512×512 even for small icons, per asset sizing guide)."

### 5.1 — Tombol aksi generik `pill.action` (BARU — isi kekosongan §1.3)

Dipakai ganti tombol default Godot di: "Kembali", "Dengar Suaranya",
"Lihat Jawaban", toggle suara, tombol di daftar Panduan Orang Tua.

> "A rounded pill-shaped button background, cream white fill with a thin
> warm brown outline border, flat color (no gradient along the length),
> completely empty/blank inside (no text, no icon baked in), capsule
> shape with semi-circular rounded ends, consistent cross-section so the
> middle can be stretched horizontally without distorting the rounded
> ends. Canvas 1024×342px (ratio 3:1)."

**2 varian warna**: 1) krem (`pill.action` default, sesuai di atas), 2)
versi aksen kuning/oranye (`AppColors.SUNSHINE`) untuk tombol yang perlu
sedikit lebih menonjol (misal "Lihat Jawaban"). Minta 2 file terpisah,
nama: `pill_action_cream.png`, `pill_action_accent.png`.

**Catatan integrasi 9-slice (supaya tidak kebentur bug 2026-11-22 lagi)**:
kalau mau pasang via `texture_margin_*` (9-slice sungguhan, supaya 1
gambar bisa dipakai di SEMUA ukuran tombol, bukan cuma rasio 3:1 persis),
minta ChatGPT generate dengan **instruksi tambahan eksplisit**: "the
rounded end caps must occupy exactly the first and last 15% of the image
width, with the middle 70% being a perfectly flat, non-tapering
cross-section" — lalu dev hitung `texture_margin_left/right` = 15% dari
lebar asli, BUKAN angka kira-kira (ini yang gagal sebelumnya).

### 5.2 — Tombol ikon bulat kosong (`icon.s`/`icon.m` frame)

Opsional — kalau mau `BigRoundButton` & ikon kecil juga pakai bingkai
gambar (bukan `StyleBoxFlat` warna solid polos seperti sekarang):

> "A circular button frame, flat warm color fill with a subtle darker
> rim/border for depth, no gradient, completely empty inside (no icon,
> no text), simple flat cartoon style. Canvas 512×512px (ratio 1:1)."

Generate di warna netral (krem/putih) 1 file — warna aksen per modul
tetap di-apply lewat `modulate` di kode (seperti mask mewarnai), BUKAN
generate 6 warna terpisah.

### 5.3 — Ikon navigasi tambahan (lengkapi set `core/assets/images/ui/` yang sudah ada)

Set lama (sudah terpasang): gear, home, speaker on/off, reveal, checkmark,
kunci orang tua. **Tambahan yang direkomendasikan**:

| Ikon | Kegunaan | Ukuran kanvas |
|---|---|---|
| `back_arrow.png` | Tombol "← Kembali" di ParentGuide/Settings (ganti teks panah manual) | 512×512 |
| `close_x.png` | Tombol tutup dialog/overlay (kalau nanti ada yang butuh tutup manual, bukan auto-advance) | 512×512 |
| `next_arrow.png` | "Hewan Lain →" di feature_hewan mode Bareng Orang Tua | 512×512 |
| `info.png` | Ikon info kecil (opsional, kalau nanti ada tooltip bantuan) | 512×512 |

Prompt (ganti `[OBJEK]` sesuai baris tabel): "A simple, bold, instantly
recognizable icon of [OBJEK], flat cartoon style, single warm color fill
(dark brown or orange), thick rounded strokes, centered composition with
even padding. Canvas 512×512px, transparent background."

### 5.4 — Progress/indicator kecil (opsional, prioritas rendah)

Kalau nanti mau ada indikator "soal ke berapa" yang ramah anak (BUKAN
angka "2/4" — itu berisiko terasa skor, lihat prinsip #4
`docs/UI_UX_DESIGN.md`): dot-dot bulat kecil, filled vs outline. Prompt:

> "A small solid circle dot and a small outline-only circle dot, same
> warm accent color, flat cartoon style, simple and minimal, meant to be
> repeated in a row as a non-numeric progress indicator. Canvas 128×128px
> each, transparent background."

File: `progress_dot_filled.png`, `progress_dot_empty.png`.

### 5.5 — TIDAK perlu digenerate (lihat §3)

- Background panel/dialog solid (pakai `StyleBoxFlat`, sudah diperbaiki).
- Versi "tablet" aset manapun (1 set resolusi tinggi sudah cukup).
- Spritesheet animasi maskot multi-frame.
- Variasi warna per-modul untuk `icon.s`/`icon.m` (pakai `modulate`).

## 6. Saran implementasi kode (buat dev, bukan buat ChatGPT)

- Buat 1 helper reusable (`core/scripts/ui_motion.gd` atau serupa) berisi
  fungsi statis `press_bounce(control: Control)` dan `pop_in(control:
  Control)` — dipakai di SEMUA tombol/dialog baru, supaya animasi §4
  konsisten 1 implementasi, bukan copy-paste tween per file (ikuti pola
  duplikasi yang SUDAH disengaja untuk `_add_home_button` kalau mau tetap
  konsisten gaya proyek, atau jadikan ini pengecualian pertama ke arah
  shared helper — ini keputusan arsitektur, diskusikan dulu sebelum
  dieksekusi, jangan langsung refactor besar tanpa persetujuan).
- `pill.action` (§5.1) begitu filenya ada: terapkan dengan pola PERSIS
  sama seperti `_apply_texture_button_style()` di `scenes/home.gd` (whole-
  texture stretch, `custom_minimum_size` rasio 3:1 PAS) — JANGAN pakai
  `texture_margin_*` kecuali sudah ikut catatan 9-slice presisi di §5.1.

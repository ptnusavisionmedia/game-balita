# UI/UX Design Plan

Target pemain: anak **1-5 tahun** (belum/baru bisa baca, motorik halus terbatas). Target pengguna sekunder: orang tua (Settings, parental gate). Semua keputusan di bawah dioptimalkan untuk anak sebagai pemain utama.

## Prinsip desain (wajib dipatuhi di semua modul)

1. **Hit-area besar**: minimal 64dp — `BigRoundButton` di `core/scripts/big_round_button.gd` sudah set `custom_minimum_size = Vector2(88, 88)` secara default. Jempol anak kecil tidak presisi.
2. **Icon/suara dulu, teks belakangan**: anak belum bisa baca. Setiap aksi harus jelas dari gambar/warna/suara saja, teks cuma pelengkap untuk orang tua.
3. **Satu aksi utama per layar**: tidak ada menu bertingkat, tidak ada dialog konfirmasi untuk aksi dalam game.
4. **Tidak ada "game over" yang menghukum**: salah jawab = suara ramah "coba lagi" + boleh coba lagi. Tidak ada skor negatif, tidak ada timer yang menekan, tidak ada layar merah besar.
   - **Update 2026-11-20**: berlaku juga untuk framing akhir sesi — jangan pakai bahasa "menang"/"kalah" di mana pun (teks, komentar kode, SFX/VO). Akhir 1 sesi mini-game cukup dikomunikasikan sebagai **keberhasilan** (confetti + 1 ikon ✓ di `StarRewardOverlay`) diikuti **perpindahan otomatis ke permainan lain** (`GameFlow.finish_game_session()`), bukan skor pertandingan menang/kalah.
   - **Update 2026-11-20 (lanjutan)**: jumlah "bintang" (★☆☆) dan tombol "Lanjut" yang sempat ada di `StarRewardOverlay` **dihapus** — menampilkan "dapet berapa" tetap terasa seperti skor/grading (bentuk halus dari menang/kalah), dan tombol manual tidak perlu karena transisi harus otomatis. `StarRewardOverlay` sekarang cuma: confetti + ikon ✓ ~1.8 detik, lalu auto-lanjut, tanpa teks/angka apa pun yang menilai performa anak. Lihat Decisions Log.
5. **Feedback instan**: tap → respons visual+audio dalam <150ms — `AudioStreamPlayer` Godot sudah latensi rendah bawaan untuk SFX, lihat [[docs/LIBRARIES.md]].
6. **Tidak ada elemen yang bisa memicu kejang foto-sensitif**: hindari flashing/strobing lebih cepat dari ~3Hz di animasi apa pun.
7. **Tidak ada iklan, popup, atau in-app purchase** yang bisa ditekan anak tanpa sengaja. Apa pun yang mengarah keluar app (Settings, dsb) wajib lewat [[docs/PLAN_BASE_MODEL.md|ParentalGateDialog]].
8. **Orientasi dikunci** (potret atau lanskap, pilih salah satu per modul, konsisten) — anak sering membolak-balik device, rotasi otomatis bikin bingung. **Implementasi 2026-11-20**: `project.godot` `[display]` — portrait dikunci (`window/handheld/orientation`) + `window/stretch/mode="canvas_items"` + `aspect="expand"`, base desain 720x1280, supaya UI (ukuran & posisi tombol) konsisten proporsinya di HP kecil maupun tablet besar, bukan beda-beda per device. Lihat Decisions Log.

## Information architecture

**Update 2026-11-20**: Home sengaja disederhanakan jadi 1 aksi utama ("▶ Play") alih-alih langsung menampilkan grid 6 pilihan — konsisten dengan prinsip #3 di atas. Grid tetap ada tapi jadi opsi sekunder ("Pilih Game", disembunyikan default). Navigasi dipusatkan lewat autoload `GameFlow` (lihat `docs/ARCHITECTURE.md`).

```
Splash (logo, auto lanjut ~1.2s)
  └─ Home (1 tombol "▶ Play" besar di tengah + tombol kecil "Pilih Game" + ⚙ Settings)
       ├─ ▶ Play → GameFlow.start_random_game() → 1 mini-game ACAK dari yang sudah
       │   "implemented" (sekarang cuma feature_angka) → mode INFINITE: selesai 1
       │   sesi → lanjut ke mini-game acak LAIN (bukan balik ke Home) — anak bisa
       │   main terus tanpa harus kembali ke menu tiap kali.
       ├─ "Pilih Game" → tampilkan grid 6 tile (manual, GameFlow.start_specific_game) ──┐
       │    ├─ feature_angka   ──┐                                                     │
       │    ├─ feature_warna     │                                                     │
       │    ├─ feature_hewan     ├─ tiap mini-game: Screen soal → feedback instan →    │
       │    ├─ feature_musik     │   StarRewardOverlay → GameFlow.finish_game_session  │
       │    ├─ feature_mewarnai  │   (balik Home kalau mode manual, lanjut acak kalau  │
       │    └─ feature_puzzle  ──┘   mode infinite)                                    │
       │                                                                                │
       ├─ 🏠 tombol darurat SELALU terlihat di tiap mini-game — keluar ke Home          │
       │   kapan saja, penting khusus untuk mode infinite supaya tidak "terjebak" ──────┘
       └─ Settings (lewat ParentalGateDialog — sekarang soal tambah + keypad, bukan
            tahan-tombol, lihat Decisions Log)
            └─ toggle suara, (nanti) pilih profil anak
```

Tidak ada layar "kalah"/"ulangi dari awal" yang terpisah — kondisi "belum selesai" cukup ditangani di dalam screen mini-game itu sendiri (boleh coba lagi soal yang sama).

## Pola interaksi per tipe mini-game

| Modul | Interaksi utama | Catatan |
|---|---|---|
| `feature_angka` | Tap | Pilih angka yang benar dari 3 pilihan |
| `feature_warna` | Tap | Cocokkan warna/bentuk |
| `feature_hewan` | Tap | Tap gambar hewan setelah dengar suaranya |
| `feature_musik` | Tap (bukan drag) | Tombol nada besar, tidak perlu presisi musikal |
| `feature_mewarnai` | Drag/tap warna ke area pola | Area target harus besar & bertoleransi (snap longgar) |
| `feature_puzzle` | Drag | Potongan besar (≤6 keping untuk level awal), snap longgar |

Semua gestur dasar (tap, drag) pakai node bawaan Godot (`Button.pressed`, `Control._get_drag_data()`/`_drop_data()`) — sudah optimal, tidak perlu addon gestur tambahan (lihat [[docs/LIBRARIES.md]]).

## Motion & animasi

- Easing: `Tween` bawaan Godot dengan `Tween.EASE_OUT` + `Tween.TRANS_BACK`/`TRANS_ELASTIC` untuk micro-interaction (kesan "hidup", ramah anak).
- Durasi pendek: 200-500ms. Anak kecil kehilangan fokus kalau animasi kepanjangan.
- Reward: confetti (`CPUParticles2D`) + bintang (`StarRewardOverlay.tscn` di `core/scenes/`) — satu komponen dipakai semua modul, konsisten.
- Transisi antar scene: fade hitam singkat (0.15s in + 0.15s out) via `GameFlow.goto_scene()` — potongan instan terasa kasar untuk anak kecil, dan sekaligus jadi titik debounce anti-klik-ganda (lihat `docs/ARCHITECTURE.md`).

## Color palette

Prinsip pemilihan warna:
- **Bukan merah murni untuk "salah"** — merah/hijau murni berdampingan sulit dibedakan untuk anak dengan buta warna merah-hijau (paling umum). Feedback "coba lagi" pakai **coral/oranye**, bukan merah.
- **Kontras tinggi tapi hangat** — bukan hitam pekat (`#000000`) di atas putih pekat (`#FFFFFF`), yang terasa "tajam"/klinis. Pakai ink `#2B2D42` di atas cream `#FFFDF5`.
- **1 warna aksen per mini-game** supaya ikon di Home langsung bisa dibedakan anak dari warnanya saja (sebelum bisa baca labelnya).

| Token | Hex | Dipakai untuk |
|---|---|---|
| `AppColors.SUNSHINE` | `#FFC93C` | Primary brand, tombol utama |
| `AppColors.CREAM` | `#FFFDF5` | Background utama |
| `AppColors.INK` | `#2B2D42` | Teks |
| `AppColors.LEAF` | `#6FCF97` | Feedback "benar" |
| `AppColors.CORAL` | `#FF8A65` | Feedback "coba lagi" (bukan merah) |
| `AppColors.GOLD` | `#FFD166` | Bintang reward |
| `AppColors.ACCENT_ANGKA` | `#4FC3F7` | Aksen tile `feature_angka` |
| `AppColors.ACCENT_WARNA` | `#FF8A65` | Aksen tile `feature_warna` |
| `AppColors.ACCENT_HEWAN` | `#6FCF97` | Aksen tile `feature_hewan` |
| `AppColors.ACCENT_MUSIK` | `#B39DDB` | Aksen tile `feature_musik` |
| `AppColors.ACCENT_MEWARNAI` | `#F48FB1` | Aksen tile `feature_mewarnai` |
| `AppColors.ACCENT_PUZZLE` | `#4DB6AC` | Aksen tile `feature_puzzle` |

Implementasi: `core/scripts/app_colors.gd` (class `AppColors`, `class_name` global jadi bisa dipanggil `AppColors.SUNSHINE` dari script mana pun tanpa import). **Jangan** tulis hex warna langsung di scene `feature_*` — selalu lewat `AppColors` dari `core/`, supaya ganti 1 warna cukup di 1 tempat.

Tipografi: **Baloo 2** — import file font (`.ttf`) langsung sebagai `FontFile` resource Godot (lihat [[docs/LIBRARIES.md]], tidak perlu package seperti `google_fonts`) — rounded, hangat, tetap jelas dibaca orang tua di Settings/label. File font `.ttf` belum di-upload (tugas Asset 1/UI-UX Designer), lihat `docs/TASK_BOARD.md`.

## Yang belum diputuskan (perlu asset artist / riset lanjut)

- Gaya ilustrasi final (flat vector vs semi-3D vs hand-drawn) — bukan keputusan teknis, perlu brief ke artist. Taruh referensi visual begitu ada di `obsidian-vault/Specs/<modul>.md` masing-masing.
- Apakah perlu dark mode — default-nya **tidak** (anak-anak app selalu pakai tema cerah terang, terlepas dari system theme), dicatat di Decisions Log.

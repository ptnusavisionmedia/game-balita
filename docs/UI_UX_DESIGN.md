# UI/UX Design Plan

Target pemain: anak **1-5 tahun** (belum/baru bisa baca, motorik halus terbatas). Target pengguna sekunder: orang tua (Settings, parental gate). Semua keputusan di bawah dioptimalkan untuk anak sebagai pemain utama.

## Prinsip desain (wajib dipatuhi di semua modul)

1. **Hit-area besar**: minimal 64dp (`AppTheme.minTouchTarget` di `packages/core`). Jempol anak kecil tidak presisi.
2. **Icon/suara dulu, teks belakangan**: anak belum bisa baca. Setiap aksi harus jelas dari gambar/warna/suara saja, teks cuma pelengkap untuk orang tua.
3. **Satu aksi utama per layar**: tidak ada menu bertingkat, tidak ada dialog konfirmasi untuk aksi dalam game.
4. **Tidak ada "game over" yang menghukum**: salah jawab = suara ramah "coba lagi" + boleh coba lagi. Tidak ada skor negatif, tidak ada timer yang menekan, tidak ada layar merah besar.
5. **Feedback instan**: tap → respons visual+audio dalam <150ms (ini alasan [[docs/LIBRARIES.md|SfxService pakai soundpool]], bukan audioplayers, untuk SFX).
6. **Tidak ada elemen yang bisa memicu kejang foto-sensitif**: hindari flashing/strobing lebih cepat dari ~3Hz di animasi apa pun.
7. **Tidak ada iklan, popup, atau in-app purchase** yang bisa ditekan anak tanpa sengaja. Apa pun yang mengarah keluar app (Settings, dsb) wajib lewat [[docs/PLAN_BASE_MODEL.md|ParentalGateDialog]].
8. **Orientasi dikunci** (potret atau lanskap, pilih salah satu per modul, konsisten) — anak sering membolak-balik device, rotasi otomatis bikin bingung.

## Information architecture

```
Splash (logo, auto lanjut ~1.5s)
  └─ Home (grid 6 ikon mini-game + 1 ikon Settings kecil di pojok)
       ├─ feature_angka   ──┐
       ├─ feature_warna     │
       ├─ feature_hewan     ├─ tiap mini-game: Screen soal → feedback instan →
       ├─ feature_musik     │   StarRewardOverlay → balik ke Home
       ├─ feature_mewarnai  │
       └─ feature_puzzle  ──┘
       └─ Settings (lewat ParentalGateDialog)
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

Semua gestur dasar (tap, drag) pakai widget bawaan Flutter (`GestureDetector`, `Draggable`/`DragTarget`) — sudah optimal, tidak perlu library gestur tambahan (lihat [[docs/LIBRARIES.md]]).

## Motion & animasi

- Easing: `Curves.easeOutBack` / `elasticOut` untuk micro-interaction (kesan "hidup", ramah anak) — lewat `flutter_animate`, bukan `AnimationController` manual.
- Durasi pendek: 200-500ms. Anak kecil kehilangan fokus kalau animasi kepanjangan.
- Reward: confetti + bintang (`StarRewardOverlay`, package `confetti`) — satu komponen dipakai semua modul, konsisten.

## Color palette

Prinsip pemilihan warna:
- **Bukan merah murni untuk "salah"** — merah/hijau murni berdampingan sulit dibedakan untuk anak dengan buta warna merah-hijau (paling umum). Feedback "coba lagi" pakai **coral/oranye**, bukan merah.
- **Kontras tinggi tapi hangat** — bukan hitam pekat (`#000000`) di atas putih pekat (`#FFFFFF`), yang terasa "tajam"/klinis. Pakai ink `#2B2D42` di atas cream `#FFFDF5`.
- **1 warna aksen per mini-game** supaya ikon di Home langsung bisa dibedakan anak dari warnanya saja (sebelum bisa baca labelnya).

| Token | Hex | Dipakai untuk |
|---|---|---|
| `AppColors.sunshine` | `#FFC93C` | Primary brand, tombol utama |
| `AppColors.cream` | `#FFFDF5` | Background utama |
| `AppColors.ink` | `#2B2D42` | Teks |
| `AppColors.leaf` | `#6FCF97` | Feedback "benar" |
| `AppColors.coral` | `#FF8A65` | Feedback "coba lagi" (bukan merah) |
| `AppColors.gold` | `#FFD166` | Bintang reward |
| `AppColors.accentAngka` | `#4FC3F7` | Aksen tile `feature_angka` |
| `AppColors.accentWarna` | `#FF8A65` | Aksen tile `feature_warna` |
| `AppColors.accentHewan` | `#6FCF97` | Aksen tile `feature_hewan` |
| `AppColors.accentMusik` | `#B39DDB` | Aksen tile `feature_musik` |
| `AppColors.accentMewarnai` | `#F48FB1` | Aksen tile `feature_mewarnai` |
| `AppColors.accentPuzzle` | `#4DB6AC` | Aksen tile `feature_puzzle` |

Implementasi: `packages/core/lib/src/theme/app_colors.dart` + `app_theme.dart`. **Jangan** tulis hex warna langsung di widget `feature_*` — selalu lewat `AppColors`/`AppTheme` dari `core`, supaya ganti 1 warna cukup di 1 tempat.

Tipografi: **Baloo 2** (via `google_fonts`) — rounded, hangat, tetap jelas dibaca orang tua di Settings/label.

## Yang belum diputuskan (perlu asset artist / riset lanjut)

- Gaya ilustrasi final (flat vector vs semi-3D vs hand-drawn) — bukan keputusan teknis, perlu brief ke artist. Taruh referensi visual begitu ada di `obsidian-vault/Specs/<modul>.md` masing-masing.
- Apakah perlu dark mode — default-nya **tidak** (anak-anak app selalu pakai tema cerah terang, terlepas dari system theme), dicatat di Decisions Log.

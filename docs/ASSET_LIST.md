# Daftar Kebutuhan Aset (Ilustrasi, SFX, VO)

Konsolidasi semua kebutuhan aset dari `obsidian-vault/Specs/feature_*.md` + task board, jadi 1 checklist yang bisa dicek sekali lihat — bukan pengganti spek per modul (detail konteks tetap di `obsidian-vault/Specs/`), ini daftar **file apa, format apa, taruh di mana**.

Semua baris di bawah **placeholder sekarang** (emoji/kotak warna/`SfxService.play(null)`) — base model sengaja dirancang bisa ditest tanpa aset final (lihat `docs/LIBRARIES.md`), tapi makin cepat diganti, makin terasa "jadi" app-nya (lihat `obsidian-vault/Referensi-LucasAndFriends.md` — salah satu alasan "game kurang menarik" adalah ketiadaan aset asli).

## Status umum

> **Update 2026-11-22**: paket `Wawa_Seluruh_Aset.zip` (user, lewat ChatGPT) sudah diintegrasikan ke seluruh modul — lihat `docs/TASK_BOARD.md` baris per-modul untuk detail & link kode. Tabel di bawah ini (per kategori lama) sekarang historis; baris per-aset yang relevan di `TASK_BOARD.md` adalah sumber kebenaran status terkini.

| Kategori | Sudah ada asli? |
|---|---|
| Ilustrasi | ✅ Terpasang semua kategori (hewan/buah/shape-sorter/mewarnai/musik/ikon UI/maskot/app icon-splash/panduan orang tua) — lihat `docs/TASK_BOARD.md` |
| SFX | ✅ `sfx_correct`/`sfx_try_again`/`sfx_tap` + suara 6 hewan + 6 nada musik terpasang. **Suara hewan masih "draf sintetis bergaya kartun"**, bukan rekaman asli — wajib diuji dengar sebelum rilis |
| VO | ✅ VO angka 1-5 terpasang (tombol "🔊 Sebutkan" di `feature_angka`). **PERINGATAN: dibuat lewat mesin Flite/CMU SLT bahasa Inggris — bukan rekaman penutur Indonesia**, wajib direview/diganti sebelum rilis |
| Musik latar (BGM) | — (belum direncanakan, lihat Catatan di bawah — paket aset baru juga tidak menyertakan BGM) |

---

## 1. Ilustrasi (gambar)

PIC: **Asset 1**. Format: `.png` (transparan) atau `.svg` (Godot rasterize otomatis saat import, lihat `docs/LIBRARIES.md`). Gaya: ikuti style guide (belum ada, ini juga task Asset 1 — lihat `docs/TASK_BOARD.md`).

| # | Aset | Jumlah | Ganti placeholder di | Taruh di |
|---|---|---|---|---|
| 1 | Objek hitung (buah/mainan, 1-5 biji bisa digambar sebagai 1 ikon diulang) | 1 ikon dasar | Ikon hati di `feature_angka` | `features/feature_angka/assets/images/` |
| 2 | Hewan: kucing, anjing, sapi, ayam, kambing, bebek | 6 | Emoji di `hewan_data.json` | `features/feature_hewan/assets/images/` |
| 3 | Buah-buahan untuk belajar warna (apel, pisang, jeruk, anggur, melon, blueberry — direvisi 2026-11-22, 1 kategori "buah" konsisten) | 6 | Emoji di `warna_data.json` | `features/feature_warna/assets/images/` |
| 4 | Gambar "Kelinci" dipecah 4 area (telinga kiri/kanan, kepala, badan) — AREA-nya, bukan cuma 1 gambar utuh, karena tiap area harus bisa diwarnai terpisah | 1 set (4 potongan area/mask) | Kotak rounded abu-abu di `feature_mewarnai` | `features/feature_mewarnai/assets/images/` |
| 5 | +1-2 gambar lain buat `feature_mewarnai` (opsional, setelah "Kelinci" jalan) | 1-2 set | — (tambahan) | sama seperti di atas |
| 6 | **Direvisi 2026-11-22**: bentuk geometris gaya shape-sorter (kotak/lingkaran/segitiga solid + versi outline kosong buat slot) — bukan lagi "1 gambar dipotong 4 keping" | 3 keping solid + 3 outline slot | Kotak warna polos di `feature_puzzle` | `features/feature_puzzle/assets/images/` |
| 7 | App icon + splash screen draft | 1 set | Logo teks "Wawa" default di `Splash.tscn` | `assets/` (root, lihat koordinasi Bramantyo export) |
| 7b | Background Home (langit+rumput+matahari versi ilustrasi asli) | 1 | ✅ **Selesai** (2026-11-22) — digenerate user lewat ChatGPT, dipasang di `core/scripts/game_background.gd` via `TextureRect` | `core/assets/images/home_background.png` |
| 7c | Tombol "Play" + "Pilih Game" (desain pill/kapsul reusable) | 2 (primer+sekunder) | ✅ **Selesai** (2026-11-22) — digenerate user lewat ChatGPT, dipasang di `scenes/home.gd` via `StyleBoxTexture` | `core/assets/images/button_primary.png` + `button_secondary.png` |
| 8 | **Maskot karakter "Wawa"** (nama app resmi 2026-11-22) | min. 1 karakter, idealnya beberapa pose (netral/senang/bicara) | Tidak ada sekarang — app ini **belum punya maskot sama sekali** | TBD, kemungkinan `core/assets/images/` (dipakai lintas modul) |
| 9 | (Opsional) Ilustrasi kartu "Panduan Orang Tua" | 6 | Teks polos di `ParentGuide.tscn` | TBD, kemungkinan `core/assets/images/` |
| 10 | Nada musik gaya "toy xylophone" (bukan piano key realistis) | 6 (1 per warna) | Lingkaran polos + "♪" di `musik.gd` | `features/feature_musik/assets/images/` |
| 11 | Ikon UI: gear (settings), home, speaker on/off, magnifying glass, checkmark, padlock | 7 | Emoji unicode (🏠🔊🔍✓⚙) tersebar di banyak scene | `core/assets/images/` — **butuh task kode tambahan** (ganti `Button.text` emoji jadi `Button.icon`/`TextureRect`) |

**Catatan khusus #4 & #6**: beda dari ilustrasi lain yang "1 gambar = 1 file", ini butuh gambar yang **sudah dipikirkan pembagian area/potongannya** dari awal (bukan 1 gambar utuh yang baru dipotong belakangan) — koordinasi dulu sama Dev 4 (pemegang `feature_mewarnai`+`feature_puzzle`) soal bentuk & jumlah area/potongan sebelum mulai gambar, lihat `obsidian-vault/Specs/feature_mewarnai.md` & `feature_puzzle.md` (puzzle sekarang jadi shape-sorter, bukan potong gambar — update spek kalau konsep ini dipakai).

## 2. SFX (efek suara pendek)

PIC: **Farel**. Format: `.wav`/`.ogg`, pendek & ringan (lihat `docs/LIBRARIES.md`). Nada ramah anak — **bukan** suara negatif/menakutkan untuk "coba lagi" (prinsip #4 `docs/UI_UX_DESIGN.md`).

| # | Aset | Jumlah | Dipakai di | Taruh di |
|---|---|---|---|---|
| 1 | `sfx_correct` (jawaban/aksi benar) | 1 (shared semua modul) | `feature_angka`, `feature_hewan`, `feature_warna`, `feature_puzzle` | `features/feature_angka/assets/audio/` (atau pindah ke `core/assets/audio/` kalau mau benar-benar 1 file dipakai ulang — lihat Catatan) |
| 2 | `sfx_try_again` (coba lagi, ramah) | 1 (shared) | `feature_angka`, `feature_hewan`, `feature_warna` | sama seperti di atas |
| 3 | `sfx_tap` (netral, bukan benar/salah) | 1 (shared) | `feature_mewarnai`, `feature_puzzle` (opsional pakai `sfx_correct` juga, lihat spek) | sama seperti di atas |
| 4 | Suara hewan: kucing, anjing, sapi, ayam, kambing, bebek | 6 | `feature_hewan` (dengar suara, kedua mekanik) | `features/feature_hewan/assets/audio/` |
| 5 | Nada musik pendek | 4-6 | `feature_musik` | `features/feature_musik/assets/audio/` |

**Catatan**: file `sfx_correct`/`sfx_try_again`/`sfx_tap` dipakai lintas modul — pertimbangkan taruh di `core/assets/audio/` (bukan di folder `feature_angka`) supaya jelas statusnya "shared", bukan kelihatan seperti milik 1 modul doang. Belum ada keputusan final soal ini, Farel/Bramantyo yang putuskan saat mulai kerja.

## 3. VO (voice-over, Bahasa Indonesia, nada ceria)

PIC: **Farel**.

| # | Aset | Jumlah | Dipakai di | Taruh di |
|---|---|---|---|---|
| 1 | VO angka "satu" s/d "lima" | 5 | `feature_angka` | `features/feature_angka/assets/audio/` |

**Belum ada VO untuk modul lain** (warna/hewan/musik/mewarnai/puzzle) — belum direncanakan di spek manapun. Kalau mau ditambah (misal VO nama warna "Merah"/"Kuning" dkk, atau nama hewan), ini usulan baru yang perlu dikonfirmasi dulu, bukan sesuatu yang sudah disepakati.

## 4. Yang BELUM direncanakan sama sekali (perlu keputusan dulu, bukan langsung dikerjakan)

- **Musik latar (BGM)** — tidak ada di spek manapun sampai sekarang. `AudioService` (autoload) sudah ada infrastrukturnya (terpisah dari `SfxService`), tapi belum ada keputusan mau pakai BGM atau tidak.
- **Maskot karakter "Wawa"** (lihat baris #8 di atas) — namanya sudah ada (app resmi bernama Wawa, 2026-11-22), tapi gaya visual final & di mana saja dipakai (Splash? Home? reward overlay?) masih perlu diputuskan setelah 1 karakter dasar digenerate & direview.

---

Lihat juga: `docs/TASK_BOARD.md` (status klaim per baris asset), `obsidian-vault/Specs/feature_*.md` (detail konteks tiap kebutuhan), `docs/UI_UX_DESIGN.md` (style/color principles yang harus diikuti semua aset), **`docs/STYLE_GUIDE_ILUSTRASI.md`** (gaya visual detail + prompt siap-pakai buat generate AI untuk tiap aset ilustrasi di atas).

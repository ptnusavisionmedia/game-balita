# Daftar Kebutuhan Aset (Ilustrasi, SFX, VO)

Konsolidasi semua kebutuhan aset dari `obsidian-vault/Specs/feature_*.md` + task board, jadi 1 checklist yang bisa dicek sekali lihat — bukan pengganti spek per modul (detail konteks tetap di `obsidian-vault/Specs/`), ini daftar **file apa, format apa, taruh di mana**.

Semua baris di bawah **placeholder sekarang** (emoji/kotak warna/`SfxService.play(null)`) — base model sengaja dirancang bisa ditest tanpa aset final (lihat `docs/LIBRARIES.md`), tapi makin cepat diganti, makin terasa "jadi" app-nya (lihat `obsidian-vault/Referensi-LucasAndFriends.md` — salah satu alasan "game kurang menarik" adalah ketiadaan aset asli).

## Status umum

| Kategori | Sudah ada asli? |
|---|---|
| Ilustrasi | ❌ Belum ada sama sekali (semua placeholder emoji/vektor kode) |
| SFX | ❌ Belum ada sama sekali (semua `null`, senyap) |
| VO | ❌ Belum ada sama sekali |
| Musik latar | — (belum direncanakan, lihat Catatan di bawah) |

---

## 1. Ilustrasi (gambar)

PIC: **Asset 1**. Format: `.png` (transparan) atau `.svg` (Godot rasterize otomatis saat import, lihat `docs/LIBRARIES.md`). Gaya: ikuti style guide (belum ada, ini juga task Asset 1 — lihat `docs/TASK_BOARD.md`).

| # | Aset | Jumlah | Ganti placeholder di | Taruh di |
|---|---|---|---|---|
| 1 | Objek hitung (buah/mainan, 1-5 biji bisa digambar sebagai 1 ikon diulang) | 1 ikon dasar | Ikon hati di `feature_angka` | `features/feature_angka/assets/images/` |
| 2 | Hewan: kucing, anjing, sapi, ayam, kambing, bebek | 6 | Emoji di `hewan_data.json` | `features/feature_hewan/assets/images/` |
| 3 | Benda untuk belajar warna (apel, lemon, daun, jeruk, anggur, blueberry — atau pilihan lain Asset 1) | 6 | Emoji di `warna_data.json` | `features/feature_warna/assets/images/` |
| 4 | Gambar "Kelinci" dipecah 4 area (telinga kiri/kanan, kepala, badan) — AREA-nya, bukan cuma 1 gambar utuh, karena tiap area harus bisa diwarnai terpisah | 1 set (4 potongan area/mask) | Kotak rounded abu-abu di `feature_mewarnai` | `features/feature_mewarnai/assets/images/` |
| 5 | +1-2 gambar lain buat `feature_mewarnai` (opsional, setelah "Kelinci" jalan) | 1-2 set | — (tambahan) | sama seperti di atas |
| 6 | 1 gambar dipecah 4 keping puzzle (potongan asli, bukan kotak warna) | 1 set (4 potongan) | Kotak warna polos di `feature_puzzle` | `features/feature_puzzle/assets/images/` |
| 7 | App icon + splash screen draft | 1 set | Logo teks default di `Splash.tscn` | `assets/` (root, lihat koordinasi Bramantyo export) |
| 8 | **Maskot karakter** (baru — usul dari riset kompetitor, lihat `obsidian-vault/Referensi-LucasAndFriends.md`) | min. 1 karakter, idealnya beberapa pose (netral/senang/bicara) | Tidak ada sekarang — app ini **belum punya maskot sama sekali** | TBD, kemungkinan `core/assets/images/` (dipakai lintas modul) |
| 9 | (Opsional) Ilustrasi kartu "Panduan Orang Tua" | 6 | Teks polos di `ParentGuide.tscn` | TBD, kemungkinan `core/assets/images/` |

**Catatan khusus #4 & #6**: beda dari ilustrasi lain yang "1 gambar = 1 file", ini butuh gambar yang **sudah dipikirkan pembagian area/potongannya** dari awal (bukan 1 gambar utuh yang baru dipotong belakangan) — koordinasi dulu sama Dev 4 (pemegang `feature_mewarnai`+`feature_puzzle`) soal bentuk & jumlah area/potongan sebelum mulai gambar, lihat `obsidian-vault/Specs/feature_mewarnai.md` & `feature_puzzle.md`.

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
- **Maskot karakter** (lihat baris #8 di atas) — baru usulan dari riset kompetitor, bukan keputusan final. Kalau mau dikerjakan, perlu dipikirkan dulu: nama, gaya visual, dipakai di mana saja (Splash? Home? reward overlay?) — ini keputusan desain, bukan cuma "gambar aja".

---

Lihat juga: `docs/TASK_BOARD.md` (status klaim per baris asset), `obsidian-vault/Specs/feature_*.md` (detail konteks tiap kebutuhan), `docs/UI_UX_DESIGN.md` (style/color principles yang harus diikuti semua aset), **`docs/STYLE_GUIDE_ILUSTRASI.md`** (gaya visual detail + prompt siap-pakai buat generate AI untuk tiap aset ilustrasi di atas).

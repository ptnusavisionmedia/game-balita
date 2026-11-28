# Ringkasan Besar — Wawa (supaya context nggak lupa/kelepas)

> Dokumen ini **peta**, bukan pengganti dokumen aslinya — tiap bagian nunjuk ke file sumber yang lebih detail. Kalau ada yang beda antara sini dan sumbernya, **sumbernya yang benar** (dokumen ini cuma rangkuman, bisa ketinggalan update).
>
> Dibuat 2026-11-28 atas permintaan user: "buatkan vault untuk obsidian agar context tidak lupa atau terlepas."

---

## 1. Apa app ini

**Wawa** — game edukatif Android untuk anak **1-5 tahun**, dibangun di Godot 4 (GDScript). Awalnya working title "Bayi GuguGaga" (nama folder repo `bayi-gugugaga/` sengaja tidak diganti, cuma nama tampilan app-nya yang jadi "Wawa").

**Prinsip inti yang TIDAK BOLEH dilanggar tanpa alasan baru** (lihat `obsidian-vault/Decisions Log.md` untuk histori lengkap):
- **Tanpa skor/bintang/menang-kalah** — usia 1-5 belum matang kognitif buat konsep itu (lihat §2 di bawah), dan rapuh kalau dinilai terus-menerus (Erikson).
- **Hit-area besar, teks besar** — balita belum baca, motorik belum presisi.
- **Feedback instan, tanpa hukuman** — salah = "coba lagi" netral, bukan buzzer/animasi negatif.
- **Minim/nol teks wajib dibaca untuk bisa main** — instruksi lewat ikon/warna/suara, bukan kalimat.

Dokumen prinsip desain lengkap: [docs/UI_UX_DESIGN.md](../docs/UI_UX_DESIGN.md).

---

## 2. Dasar teori tumbuh-kembang (kenapa app-nya begini)

Sudah ada riset lengkap di **[docs/PLAN_TUMBUH_KEMBANG.md](../docs/PLAN_TUMBUH_KEMBANG.md)** — ini yang jawab pertanyaan "gimana caranya bikin game balita padahal saya nggak tahu dasarnya". Intinya:

| Teori | Inti | Dampak ke desain app |
|---|---|---|
| **CDC Milestones** | Usia 1-5 BELUM paham konsep menang/kalah secara kognitif (baru matang ~5th) | Dasar kenapa "tanpa skor" bukan cuma gaya, tapi memang sesuai tahap kognitif |
| **Piaget (Praoperasional)** | Anak belajar lewat benda konkret, belum paham angka abstrak | `feature_angka` hitung benda nyata (hati), bukan angka lepas |
| **Erikson (Psikososial)** | Usia ini lagi bangun rasa **otonomi/inisiatif** — gagal dinilai berulang bisa menghambat rasa percaya diri | Dasar "tidak ada game over yang menghukum" |
| **Vygotsky (ZPD/Scaffolding)** | Anak belajar lebih jauh kalau dibantu orang dewasa yang lebih mampu ("math talk" sambil main), dibanding main sendirian | Dasar **Mode "Bareng Orang Tua"** — `ParentGuide.tscn`, mekanik 2-mode `feature_hewan` |
| **Montessori (Sensitive Periods)** | Ada masa anak "peka" ke stimulus tertentu (bahasa 7bln-3th, indra 2.5-6th) + prinsip *auto-education* (belajar sendiri tanpa orang dewasa harus hadir) | Dasar **Mode "Mandiri"** — gameplay harus 100% bisa dimainkan tanpa baca instruksi |

Pemetaan teori → 6 modul (kalimat scaffolding per modul dll) ada di `docs/PLAN_TUMBUH_KEMBANG.md` §3, isi lengkap kartu panduan ada di `core/data/parent_guide.json`.

**Soal "tebak hewan"/"tebak barang apa ini" yang disebut user** — ini **SUDAH ADA**, bukan fitur baru:
- `feature_hewan` (lihat [obsidian-vault/Specs/feature_hewan.md](Specs/feature_hewan.md)) punya **2 mekanik**: Mandiri (dengar suara → pilih gambar yang benar) dan **Bareng Orang Tua** (gambar disamarkan, orang tua putar suara, anak nebak, orang tua buka jawaban manual — TANPA tanda benar/salah, karena ini bukan kuis).
- Diakses lewat layar **Gamemodes** (`scenes/game_modes.gd`) kartu "🤝 Bareng Orang Tua" → `ParentGuide.tscn` → tombol "Mulai Main Bareng" di kartu Suara Hewan.
- 5 modul lain juga masing-masing punya 1 "skill tebak" sendiri (lihat tabel §3 di atas) — bukan cuma hewan.

---

## 3. Struktur navigasi app (per 2026-11-28)

```
Splash → (cek ProgressRepository.toddler_mode)
         ├── true  → TouchAndListen.tscn ("Sentuh & Dengar", 1-2 tahun)
         └── false → Home.tscn (3-5 tahun)
                      ├── ▶ Play (lingkaran besar) → acak infinite 6 modul
                      ├── "Gamemodes" → GameModes.tscn, 4 kartu tema:
                      │     ├── 🧒 Main Sendiri    → grid pilih manual 6 modul
                      │     ├── 🤝 Bareng Orang Tua → ParentGuide.tscn
                      │     ├── 🎨 Jelajah Kreatif  → acak Mewarnai/Puzzle
                      │     └── ⭐ Tantangan Harian  → 1 modul tetap/hari
                      └── ⚙ Settings (di balik ParentalGateDialog, soal +)
                            ├── toggle Suara
                            ├── toggle "Mode Usia Anak" (1-2 / 3-5 tahun)
                            └── "Panduan Orang Tua" → ParentGuide.tscn
```

**6 mini-game** (`features/feature_*`): Angka (hitung benda), Warna (cocokkan warna buah), Hewan (tebak suara/gambar, 2 mekanik), Musik (tap bebas xylophone), Mewarnai (isi area line-art), Puzzle (**drag-and-drop** shape-sorter — lihat §5).

Semua navigasi scene WAJIB lewat `GameFlow.goto_scene(...)` (autoload, `core/scripts/game_flow.gd`), bukan `change_scene_to_file` langsung — supaya fade transisi & anti-klik-ganda konsisten.

---

## 4. Status kerja (ringkas dari docs/TASK_BOARD.md — itu sumber lengkapnya)

**Base model (6 modul + core) — Done semua.** Yang masih `Open`/`Claimed` dan belum tuntas:
- `docs/QA_CHECKLIST.md` belum dibuat (Fase C `PLAN_TUMBUH_KEMBANG.md` — audit "bisa dimainkan tanpa baca" tiap modul).
- Test interaktif di **device/emulator Android asli** — baru dites di desktop Windows (Godot editor), belum pernah di HP/tablet sungguhan.
- Beberapa aset masih **"draf sintetis"**: SFX dasar, VO angka (dibuat mesin TTS bahasa Inggris, BUKAN penutur Indonesia asli), suara hewan — **wajib direview/diganti sebelum rilis**.
- Maskot pose netral/berbicara belum dipakai di mana pun (ada file-nya, belum ada keputusan penempatan).
- Privacy Policy sudah ditulis (`docs/PRIVACY_POLICY.md`) tapi belum dipublish ke URL publik (wajib sebelum submit Play Store).
- Marketing (riset referensi, draft listing Play Store) — belum dikerjakan, bukan scope teknis.

---

## 5. Keputusan besar yang gampang kelupaan (histori lengkap: Decisions Log.md)

- **Nama app**: "Wawa" (final, 2026-11-22). Folder repo tetap `bayi-gugugaga/`.
- **Puzzle**: drag-and-drop asli (2026-11-26, versi ke-4) — bukan API drag bawaan Godot (`_get_drag_data` dkk, 3x gagal karena preview-nya pakai koordinat OS terpisah dari transform canvas-stretch), tapi digerakkan manual lewat `_input()` + `global_position`.
- **2 bug class UI yang harus diingat kalau bikin tombol/ikon baru**:
  1. `TextureRect` butuh `expand_mode = EXPAND_IGNORE_SIZE`, kalau tidak ikon jadi raksasa (lapor ukuran asli file, bukan `custom_minimum_size`).
  2. `Button.icon` butuh `expand_icon = true` (+ `icon_max_width`), kalau tidak sama persis jadi raksasa.
  3. **(baru 2026-11-26)** `Button.icon_alignment` default **LEFT** (bukan CENTER kayak teks) — tombol ikon-saja (tanpa teks) kegeser ke kiri kalau tidak di-set manual. Sudah di-fix di `UIStyle.apply_icon_frame`.
- **Container full-rect (anchor 0,0,1,1) yang di-`add_child` SETELAH tombol lain** bisa "menelan" klik tombol itu (default `mouse_filter = STOP`) — set `mouse_filter = IGNORE` di container pembungkusnya.
- **Tier usia 1-2 tahun** ("Sentuh & Dengar", 2026-11-26) — layar terpisah, nol navigasi, tap mana saja = gambar+bunyi, diset lewat Settings, BUKAN dideteksi otomatis dari umur beneran (app tidak tanya umur anak).

---

## 6. Yang BELUM dikerjakan / masih ide terbuka (jangan dianggap sudah ada)

- Audit "bisa dimainkan tanpa baca" per modul (Fase C) — belum sistematis dicek satu-satu.
- Background gameplay (`GameBackground`) masih 1 gambar statis (langit+rumput+awan+bunga baked jadi satu PNG) — belum ada elemen bergerak/animasi.
- Review konten "Panduan Orang Tua" oleh manusia yang paham anak usia dini (Fase D `PLAN_TUMBUH_KEMBANG.md`) — belum ada yang review, ini **bukan nasihat medis**.
- Ilustrasi mode-mode baru (badge Gamemodes) baru 2026-11-28 diganti dari emoji jadi gambar asli (digenerate via ChatGPT) — gaya belum tentu 100% seragam sama ilustrasi lain, perlu dicek lagi kalau mau benar-benar konsisten.

---

## Peta dokumen (biar nggak nyasar)

| Mau tahu apa | Buka file |
|---|---|
| Aturan main sesi kerja (klaim task, dll) | [CLAUDE.md](../CLAUDE.md) |
| Semua keputusan + alasannya, kronologis | [Decisions Log.md](Decisions%20Log.md) |
| Status tiap task | [docs/TASK_BOARD.md](../docs/TASK_BOARD.md) |
| Dasar teori tumbuh-kembang lengkap | [docs/PLAN_TUMBUH_KEMBANG.md](../docs/PLAN_TUMBUH_KEMBANG.md) |
| Prinsip desain UI/UX + palet warna | [docs/UI_UX_DESIGN.md](../docs/UI_UX_DESIGN.md) |
| Spek per modul (gameplay detail) | [Specs/feature_*.md](Specs/) |
| Gaya ilustrasi + prompt AI image-gen | [docs/STYLE_GUIDE_ILUSTRASI.md](../docs/STYLE_GUIDE_ILUSTRASI.md), [docs/STYLE_GUIDE_GUI_HUD.md](../docs/STYLE_GUIDE_GUI_HUD.md) |
| Aset apa saja yang ada/dibutuhkan | [docs/ASSET_LIST.md](../docs/ASSET_LIST.md) |

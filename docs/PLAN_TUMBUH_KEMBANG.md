# Plan: Fitur Tumbuh Kembang — "Bareng Orang Tua" & "Belajar Mandiri"

Status: **DRAFT PLAN, belum dieksekusi** — menunggu konfirmasi sebelum ditambahkan ke `docs/TASK_BOARD.md` sebagai task nyata. Dokumen ini jawaban atas permintaan: *"pelajari teori tumbuh kembang anak, buat dimana orang tua bisa mengajari atau anak bisa belajar sendiri."*

Pelengkap `docs/UI_UX_DESIGN.md` (prinsip desain) dan `docs/PLAN_BASE_MODEL.md` (scope base model) — dokumen ini jawab pertanyaan **"kenapa" di balik tiap modul** (dasar ilmiahnya) dan **bagaimana app mendukung 2 cara main**: ditemani orang tua, atau dimainkan sendiri oleh anak.

---

## 1. Landasan teori (ringkas, dipetakan ke usia 1-5 tahun)

Prinsip desain yang sudah ada di `docs/UI_UX_DESIGN.md` (hit-area besar, tanpa hukuman, feedback instan, dst.) sebenarnya **sudah konsisten** dengan 4 teori utama tumbuh-kembang anak usia dini. Bagian ini menjelaskan teorinya supaya keputusan desain selanjutnya (termasuk 2 mode baru di bawah) punya dasar, bukan tebakan.

### 1.1 Milestone CDC "Learn the Signs. Act Early." (patokan usia konkret)

CDC mendefinisikan milestone sebagai hal yang **bisa dilakukan ≥75% anak** di usia tertentu, dibagi 4 kategori: *bermain, belajar, bicara, bergerak*. ([CDC — Developmental Milestones](https://www.cdc.gov/ncbddd/actearly/milestones/))

| Usia | Contoh milestone relevan ke app ini |
|---|---|
| ~1 tahun | Makan pakai sendok, naik tangga rendah dibantu — motorik kasar/halus masih berkembang → **hit-area besar wajib**. |
| ~2.5 tahun | Main *di samping* anak lain, mulai main *bersama* sesekali — belum siap kompetisi/multiplayer. |
| ~3 tahun | Ngobrol 2 arah sederhana, bisa gambar lingkaran kalau dicontohkan — dasar untuk `feature_mewarnai`. |
| ~5 tahun | Ikut aturan main & bisa bergiliran — baru di usia ini konsep "menang/kalah" mulai masuk akal secara kognitif, **di bawah itu konsepnya belum matang** — ini menguatkan kenapa keputusan "tidak ada menang/kalah" (Decisions Log 2026-11-20) memang tepat secara perkembangan, bukan cuma preferensi gaya.

**Implikasi desain**: app ini menyasar 1-5 tahun — rentang **sebelum** anak siap paham menang/kalah secara kognitif (baru matang ~5 tahun). Jadi larangan "menang/kalah" bukan cuma gaya UX, tapi **sesuai tahap kognitif target usia**.

### 1.2 Piaget — Tahap Praoperasional (±2-7 tahun)

Anak mulai bisa berpikir simbolik (1 benda/kata mewakili benda lain — dasar bermain pura-pura & bahasa), tapi belum bisa *conservation* (paham jumlah/ukuran tetap sama walau bentuk berubah) dan masih egosentris (sulit ambil sudut pandang orang lain). ([SimplyPsychology — Preoperational Stage](https://www.simplypsychology.org/preoperational.html))

**Implikasi desain**: `feature_angka` yang sekarang (hitung objek konkret, bukan simbol abstrak "5" lepas dari bendanya) **sudah sesuai** — anak usia ini belajar angka lewat benda nyata (hati/objek di layar), bukan angka abstrak dulu.

### 1.3 Erikson — Tahap Psikososial (1-3 th: Otonomi vs Rasa Malu; 3-6 th: Inisiatif vs Rasa Bersalah)

Anak usia 1-3 butuh kesempatan **mencoba sendiri** tanpa dihukum kalau gagal (bangun rasa otonomi). Usia 3-6 butuh ruang **berinisiatif** (mencoba ide sendiri) tanpa rasa bersalah kalau salah. Keduanya rapuh kalau anak terus-terusan "gagal"/dinilai.

**Implikasi desain**: ini dasar psikologis langsung untuk prinsip #4 `docs/UI_UX_DESIGN.md` ("tidak ada game over yang menghukum") dan keputusan hapus bintang/skor (Decisions Log 2026-11-20) — bukan cuma "biar lucu", tapi karena **dinilai/gagal berulang di usia ini bisa menghambat rasa percaya diri yang sedang dibangun**.

### 1.4 Vygotsky — Zone of Proximal Development (ZPD) & Scaffolding

Ada "zona" antara apa yang anak bisa kerjakan **sendiri** dan apa yang baru bisa dengan **bantuan orang yang lebih mampu** (orang tua/pengasuh). Bantuan itu ("scaffolding") idealnya dikurangi pelan-pelan seiring anak makin mahir. Riset *guided play* menunjukkan peran aktif orang tua (misal "math talk" sambil main) mendorong perkembangan lebih jauh dibanding main sendirian atau diajari penuh tanpa main. ([NAEYC — Scaffolding](https://www.naeyc.org/resources/pubs/yc/may2017/rocking-and-rolling-empowering-infants-and-toddlers), [SimplyPsychology — ZPD](https://www.simplypsychology.org/zone-of-proximal-development.html))

**Implikasi desain**: ini dasar teori utama untuk **Mode "Bareng Orang Tua"** di bagian 2 — bukan cuma orang tua duduk nonton, tapi dikasih *panduan konkret apa yang harus dikatakan/dilakukan* supaya masuk kategori "scaffolding", bukan sekadar menemani.

### 1.5 Montessori — Sensitive Periods & Auto-Edukasi

Montessori mengamati ada periode usia tertentu anak jadi sangat "peka" ke stimulus tertentu — bahasa (0-6, puncak tutur 7bln-3th), ketertiban/urutan (2-4th), penghalusan indra (2.5-6th), gerak. Satu prinsip inti Montessori: **lingkungan dirancang supaya anak bisa belajar & mengoreksi diri sendiri tanpa orang dewasa harus hadir terus** ("auto-education") — bahan belajar dirancang self-correcting. ([Montessori Academy — Sensitive Periods](https://montessoriacademy.com.au/the-sensitive-periods/))

**Implikasi desain**: ini dasar teori utama untuk **Mode "Belajar Mandiri"** — app yang sudah dirancang dengan feedback instan + tidak ada hukuman salah **sudah** mendekati prinsip self-correcting Montessori; tinggal dipastikan benar-benar bisa dimainkan **tanpa orang tua perlu baca instruksi ke anak** (minim teks, instruksi lewat ikon/suara/animasi).

---

## 2. Dua mode, 1 app (bukan 2 app terpisah)

Bukan membangun fitur baru yang berdiri sendiri — **menambah 1 layer konten** di atas 6 modul yang sudah ada, supaya 1 modul bisa dipakai 2 cara:

| | **Mode "Bareng Orang Tua"** (scaffolded, Vygotsky) | **Mode "Mandiri"** (self-correcting, Montessori) |
|---|---|---|
| Siapa mulai main | Orang tua buka dari Home, baca kartu panduan dulu | Anak bisa tap "▶ Play" sendiri, tanpa baca apa pun |
| Isi tambahan | Kartu "Panduan Orang Tua" per modul: apa yang dilatih + kalimat contoh buat diucapkan orang tua sambil main (lihat 2.1) | Tidak ada tambahan teks — gameplay yang sudah ada (ikon/suara/animasi) HARUS cukup tanpa bacaan |
| Akses | Lewat Settings (⚙), di balik `ParentalGateDialog` yang sudah ada — konten untuk orang tua, bukan anak | Default — ini sudah persis flow "▶ Play" yang sudah jalan sekarang |
| Perubahan kode | **Baru**: 1 scene + konten (bagian 4) | **Tidak ada perubahan gameplay** — cuma audit: pastikan tiap modul memang bisa dimengerti tanpa teks (lihat 2.2) |

Ini sengaja **tidak** jadi 2 app/2 flow terpisah yang membingungkan — anak tetap cuma lihat 1 tombol "▶ Play" seperti sekarang (prinsip #3, satu aksi utama per layar). "Mode Bareng Orang Tua" murni konten **untuk orang tua baca**, bukan UI baru yang anak lihat.

### 2.1 Isi kartu "Panduan Orang Tua" (1 per modul, 6 total)

Format tiap kartu (pendek, bukan artikel panjang — orang tua baca ini sambil anak nunggu main):

1. **Lagi belajar apa?** — 1 kalimat, bahasa awam (bukan jargon teori). Contoh `feature_angka`: *"Anak belajar menghitung benda nyata — bukan angka abstrak dulu, karena di usia ini belajar lebih mudah lewat benda yang kelihatan."*
2. **Kenapa tidak ada nilai/menang-kalah di sini?** — 1 kalimat penjelasan, sama untuk semua modul (rujuk Erikson: percaya diri dulu, skor belakangan) — bukan per-modul, cukup sekali muncul yang pertama kali orang tua buka panduan.
3. **Coba ucapkan ini sambil main** (scaffolding ala Vygotsky/*math talk*) — 2-3 contoh kalimat pendek yang orang tua bisa ucapkan, spesifik per modul. Contoh `feature_angka`: *"Ada berapa hati, ya? Yuk hitung bareng: satu... dua..."*
4. **Lanjutan di luar app** — 1 ide aktivitas offline sederhana yang pakai skill yang sama. Contoh `feature_angka`: *"Hitung jumlah sendok pas bantu siapin makan."*

### 2.2 Audit "bisa dimainkan tanpa baca" (Mode Mandiri)

Checklist per modul (ditambahkan ke `docs/QA_CHECKLIST.md` begitu dibuat, lihat Dev Testing di `docs/TASK_BOARD.md`):

- [ ] Tujuan tiap layar jelas dari **ikon/warna/suara** saja — tutup mata bayangkan anak yang belum bisa baca, apakah tetap tahu harus tap apa?
- [ ] Tidak ada instruksi teks yang **wajib** dibaca untuk lanjut (teks boleh ada untuk orang tua, tapi anak tidak boleh "nyangkut" kalau tidak baca).
- [ ] Jawaban salah tidak butuh "diajari ulang" oleh orang tua untuk paham caranya coba lagi (feedback-nya self-explanatory).

---

## 3. Pemetaan teori → 6 modul (ringkas, detail lengkap masuk tiap `obsidian-vault/Specs/<modul>.md`)

| Modul | Skill utama (teori) | Contoh kalimat scaffolding (orang tua) |
|---|---|---|
| `feature_angka` | Number sense konkret (Piaget praoperasional), bukan angka abstrak | "Ada berapa hati? Yuk hitung bareng." |
| `feature_warna` | Penghalusan indra (Montessori sensitive period 2.5-6th) + kategorisasi awal | "Yang mana warnanya sama kayak apel?" |
| `feature_hewan` | Periode sensitif bahasa/vokabular (Montessori, puncak 7bln-3th) + simbol (Piaget) | "Ini suaranya siapa? Coba tiru!" |
| `feature_musik` | Ritme, koordinasi motor, regulasi emosi lewat suara | "Ayo tepuk tangan ikutin iramanya!" |
| `feature_mewarnai` | Motorik halus + ekspresi simbolik (gambar lingkaran ~3th, CDC) | "Warna apa yang kamu suka buat ini?" |
| `feature_puzzle` | Penalaran spasial, problem-solving — area paling pas buat scaffolding ZPD (Vygotsky) karena butuh "sedikit bantuan pas mentok" | "Coba potongan yang bentuknya mirip ini dulu." |

---

## 4. Rencana implementasi (fasing, belum dikerjakan — perlu konfirmasi dulu)

### Fase A — Konten dulu, bukan kode (paling murah, bisa mulai duluan)
- Tulis isi 6 kartu (bagian 2.1) dalam 1 file data, misal `core/data/parent_guide.json` atau `.tres` Resource Godot — **bukan hardcode di scene**, supaya non-coder (Asset/Bramantyo) bisa edit tanpa sentuh `.gd`.
- Draft isinya **wajib direview** minimal 1 orang yang paham anak usia dini (bisa orang tua di tim sendiri, tidak harus psikolog profesional) sebelum publish — lihat bagian 6 (risiko).

### Fase B — 1 scene baru: `ParentGuide.tscn` + `parent_guide.gd`
- Dibuka dari Settings (`scenes/settings.gd`), **di belakang `ParentalGateDialog` yang sudah ada** — konten ini untuk orang tua, bukan untuk anak pencet-pencet.
- List 6 kartu (reuse pola `GridContainer`/`VBoxContainer` yang sudah ada di `home.gd`), tap 1 modul → tampil isi kartu (bagian 2.1) dalam `ScrollContainer` (karena teksnya lebih panjang dari UI lain, perlu scroll-safe — pelajaran dari bug `ParentalGateDialog` yang kolaps, Decisions Log 2026-11-20).
- **Tidak mengubah `GameFlow` atau navigasi gameplay existing sama sekali** — murni fitur baca-baca di Settings, risiko regresi ke gameplay = nol.

### Fase C — Audit Mode Mandiri (bagian 2.2)
- Jalan paralel, tidak bergantung Fase A/B — cek 1 modul yang sudah ada (`feature_angka`) dulu sebagai contoh, baru jadi acuan buat 5 modul lain pas dikerjakan.

### Fase D — Review konten oleh non-sesi-AI
- **Wajib** sebelum konten tumbuh-kembang ini dianggap final/dipublikasikan — lihat risiko di bagian 6.

---

## 5. Siapa kerjakan apa (usul, bukan keputusan final — perlu dikonfirmasi ke tim)

| Bagian | Usul PIC | Alasan |
|---|---|---|
| Fase A (tulis konten 6 kartu) | Bramantyo (draft awal) + review tim | Bramantyo sudah pegang `core/` tempat data ini akan hidup |
| Fase B (scene `ParentGuide`) | Bramantyo | Scope `scenes/`+`core/` miliknya (lihat `docs/TEAM.md`) |
| Ilustrasi kartu (opsional, bisa teks dulu) | Asset 1 | Sudah pegang ilustrasi/style guide |
| Fase C (audit per modul) | Dev 2-4 masing-masing modulnya + Dev Testing | Scope modul masing-masing |
| Fase D (review konten) | Tim + (opsional) konsultasi eksternal | Lihat bagian 6 |

---

## 6. Risiko & batasan (penting, jangan dilewat)

- **Ini bukan nasihat medis/klinis.** Konten di bagian 2.1 ditulis sebagai *tips umum bermain*, bukan panduan diagnosis/terapi. Kalau ada anak yang keterlambatan (developmental delay), app ini **tidak** menggantikan konsultasi profesional (dokter anak/psikolog). Tambahkan 1 baris disclaimer di `ParentGuide.tscn`: *"Tiap anak berkembang dengan laju berbeda. Kalau ada kekhawatiran, konsultasikan ke dokter anak."* — rujuk ke [CDC Act Early](https://www.cdc.gov/act-early/milestones/) untuk orang tua yang mau cek milestone resmi.
- **Sumber riset di dokumen ini dari web search umum (SimplyPsychology, NAEYC, Montessori Academy, CDC)** — cukup kredibel untuk level "tips umum di app edukasi", tapi **bukan** level jurnal akademik. Kalau produk ini nanti diskalakan serius (misal diklaim "berbasis riset" di marketing/Play Store listing), sebaiknya konten di-review ulang oleh yang punya latar belakang PAUD/psikologi anak sungguhan — catat ini di `docs/TASK_BOARD.md` sebagai item terbuka, bukan dianggap selesai dari 1 sesi riset AI.
- **Jangan overclaim di marketing** (`docs/WORK_BREAKDOWN.md` Job 8/Asset 3) — boleh bilang "dirancang dengan prinsip tumbuh-kembang anak usia dini", **jangan** bilang "disetujui ahli" atau semacamnya kalau memang belum direview manusia yang kompeten.

---

## Sumber bacaan (dipakai buat landasan di atas)

- [CDC — Developmental Milestones](https://www.cdc.gov/ncbddd/actearly/milestones/)
- [CDC — Milestones by 5 Years](https://www.cdc.gov/ncbddd/actearly/milestones/milestones-5yr.html)
- [SimplyPsychology — Piaget's Preoperational Stage](https://www.simplypsychology.org/preoperational.html)
- [NAEYC — Rocking and Rolling: Scaffolding in Infants' and Toddlers' Learning](https://www.naeyc.org/resources/pubs/yc/may2017/rocking-and-rolling-empowering-infants-and-toddlers)
- [SimplyPsychology — Zone of Proximal Development](https://www.simplypsychology.org/zone-of-proximal-development.html)
- [Montessori Academy — The Sensitive Periods](https://montessoriacademy.com.au/the-sensitive-periods/)

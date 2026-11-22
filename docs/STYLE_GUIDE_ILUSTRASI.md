# Style Guide Ilustrasi — siap buat generate AI

Status: draft pertama (sesi AI, 2026-11-21) — **wajib direview Asset 1** sebelum dipakai produksi sungguhan, ini cuma kerangka supaya siapa pun (manusia atau tool AI image-gen) bisa langsung mulai tanpa menebak-nebak gaya. Melengkapi `docs/ASSET_LIST.md` (daftar aset APA) — dokumen ini jawab **gaya visualnya BAGAIMANA**, plus prompt siap-pakai per aset.

Dasar: `docs/UI_UX_DESIGN.md` (prinsip desain & palet warna), `obsidian-vault/Referensi-LucasAndFriends.md` (riset kompetitor), `core/scripts/app_colors.gd` (token warna yang sudah ada di kode).

---

## 1. Arah gaya visual (sekali ditentukan, berlaku semua aset)

**Flat vector illustration, bentuk membulat (rounded), proporsi "chibi"-ringan** — mirip gaya ilustrasi app edukasi anak modern (Khan Academy Kids, Lucas & Friends, Duolingo ABC), **bukan** gaya realistis/fotografis, **bukan** gaya anime/kartun tajam bersudut.

Ciri wajib:
- **Bentuk membulat, tanpa sudut tajam** — konsisten dengan `BigRoundButton`/tombol yang sudah semua `corner_radius` 12-999px.
- **Outline tebal konsisten** (kalau pakai outline) — 1 ketebalan garis dipakai di SEMUA aset, jangan campur tipis-tebal antar gambar.
- **Flat shading** — warna blok datar, bayangan minimal (boleh 1 lapis shading lembut buat kedalaman, TIDAK gradasi kompleks/realistis).
- **Proporsi ramah anak**: untuk karakter/hewan, kepala/mata sedikit lebih besar dari proporsi natural (gaya "kawaii ringan"), badan membulat — bukan hewan proporsi anatomis akurat.
- **1 objek = 1 makna jelas dari siluet** — anak usia 1-5 belum proses detail rumit, jadi bentuk harus gampang dikenali walau dikecilkan jadi ikon kecil.

## 2. Aturan warna (wajib, bukan saran)

- **Jangan pakai merah murni (`#FF0000`)** di mana pun, termasuk di dalam ilustrasi itu sendiri (apel merah dsb pakai merah hangat, lihat `AppColors.CORAL #FF8A65` sebagai acuan kehangatan, bukan kecerahan sirine).
- **Objek/karakter pakai warna hangat jenuh** (sesuai prinsip `obsidian-vault/Referensi-LucasAndFriends.md`) — latar/dekorasi biar `GameBackground` kode yang urus (langit `#BDEBFB` + rumput `#C3EFA0`/`#AEE487`), jadi **ilustrasi object TIDAK PERLU gambar latar sendiri** — selalu isolated/transparan.
- **1 warna aksen dominan per modul** (sudah ada di kode, jangan ubah, cuma diikuti):

| Modul | Hex aksen |
|---|---|
| `feature_angka` | `#4FC3F7` |
| `feature_warna` | `#FF8A65` |
| `feature_hewan` | `#6FCF97` |
| `feature_musik` | `#B39DDB` |
| `feature_mewarnai` | `#F48FB1` |
| `feature_puzzle` | `#4DB6AC` |

(Dipakai buat aksen frame/badge/dekorasi kecil, bukan warna utama objeknya — warna utama objek boleh sesuai benda aslinya, misal apel tetap merah-hangat walau modulnya `feature_warna` beraksen oranye.)

## 3. Spesifikasi teknis file

- **Format**: PNG transparan (RGBA), bukan JPEG (butuh transparansi buat ditumpuk di atas `GameBackground`).
- **Kanvas**: persegi (1:1), objek diposisikan di tengah dengan margin ±12-15% dari tepi (supaya tidak kepotong kalau di-scale beda ukuran).
- **Resolusi sumber**: minimal 512×512px (Godot resize otomatis ke ukuran tampil, lebih baik mulai gede lalu diperkecil daripada sebaliknya).
- **Tidak ada teks/tulisan** di dalam gambar — anak belum bisa baca, teks taruh di UI (Label), bukan di aset gambar.
- **Tidak ada bayangan drop-shadow keras** — kalau mau kedalaman, pakai shading lembut built-in di ilustrasinya sendiri, bukan shadow layer terpisah yang keras.

## 4. Yang HARUS dihindari (negative prompt, berlaku semua aset)

`photorealistic, realistic, 3D render, sharp corners, thin fragile lines, scary face, sharp teeth, aggressive expression, text, watermark, signature, pure red #FF0000, busy background, cluttered scene, gradient background, drop shadow, anime style, chibi extreme (kepala terlalu besar sampai tidak proporsional), multiple conflicting color schemes`

---

## 5. Prompt siap-pakai per aset

Prompt ditulis Bahasa Inggris (lebih konsisten hasilnya di kebanyakan tool AI image-gen), pakai template umum + detail spesifik. **Prefix wajib** dipakai di semua prompt (tempel di depan detail spesifik):

> **Prefix**: *"Flat vector illustration, rounded friendly shapes, thick consistent outline, soft flat shading, warm saturated colors, isolated on transparent background, children's educational app style, centered composition, no text —"*

### 5.1 Hewan (`feature_hewan`) — 6 ekor

1. *"...a cute cartoon cat sitting, friendly smiling face, orange and white fur, big round eyes"*
2. *"...a cute cartoon dog sitting, friendly smiling face, brown and cream fur, floppy ears, big round eyes"*
3. *"...a cute cartoon cow standing, friendly smiling face, white with black patches, big round eyes"*
4. *"...a cute cartoon rooster/chicken standing, friendly smiling face, red comb, white and brown feathers, big round eyes"*
5. *"...a cute cartoon goat standing, friendly smiling face, white and brown fur, small horns, big round eyes"*
6. *"...a cute cartoon duck standing, friendly smiling face, yellow feathers, orange beak, big round eyes"*

### 5.2 Benda untuk belajar warna (`feature_warna`) — 6 benda

1. *"...a single red apple, warm red-coral color, simple shiny highlight"* (merah hangat, bukan merah sirine)
2. *"...a single yellow lemon, bright warm yellow"*
3. *"...a single green leaf, fresh green color, simple vein detail"*
4. *"...a single orange, warm orange color, simple leaf on top"*
5. *"...a bunch of purple grapes, warm purple color, simple grape cluster shape"*
6. *"...a single blueberry, deep warm blue-purple color"*

### 5.3 Puzzle (`feature_puzzle`) — 1 gambar untuk dipecah 4 keping

*"...a simple cute scene with one main subject (e.g. a smiling sun, or a simple house with a tree), bold simple shapes, designed to be easily split into 4 equal quadrant pieces, clear color blocks per quadrant for easy visual matching"*

**Catatan khusus** (bukan sekadar prompt): gambar ini **tidak bisa langsung "jadi" dari 1x generate AI** — AI cuma hasilkan gambar utuhnya, pemotongan jadi 4 keping tetap kerja manual (crop jadi 4 bagian sama besar lewat image editor), karena AI tidak tahu di mana "garis potong" yang pas buat gameplay. Sudah dicatat juga di `obsidian-vault/Specs/feature_puzzle.md`.

### 5.4 Mewarnai (`feature_mewarnai`) — gambar "Kelinci" 4 area

*"...a simple cute rabbit sitting, line art only (no fill color), bold thick black outlines, clearly separated regions for: left ear, right ear, head, body — each region a closed outline shape"*

**Catatan khusus** (lebih rumit dari aset lain): ini **BUKAN** gambar berwarna biasa — harus **line art kosong** (outline doang, tanpa warna), dan tiap area (telinga kiri/kanan, kepala, badan) harus jadi **bentuk tertutup terpisah** supaya nanti bisa di-convert jadi 4 region yang masing-masing bisa diisi warna beda secara independen di kode. AI image-gen biasa **tidak otomatis menghasilkan file dengan region terpisah** — hasil AI cuma referensi visual/line art, proses jadi 4 `Polygon2D`/area game-ready tetap butuh kerja manual (trace ulang di software vector seperti Illustrator/Inkscape, atau Dev 4 bikin ulang bentuknya langsung di Godot berdasar referensi ini). Koordinasi dengan Dev 4 dulu (lihat `obsidian-vault/Specs/feature_mewarnai.md`).

### 5.5 Objek hitung (`feature_angka`)

*"...a simple heart shape icon, warm coral-pink color, slightly 3D puffy look, single consistent object repeated to represent counting 1 to 5"*

(Ganti icon hati placeholder sekarang dengan versi "jadi" dari gaya yang sama — bukan harus ganti objeknya, hati tetap oke selama gayanya konsisten, atau boleh diganti objek lain misal bintang/apel kalau Asset 1 lebih suka.)

### 5.6 App icon & splash

*"...app icon, a smiling sun character with simple rounded rays, warm yellow/orange gradient within flat-shading limits, centered, bold and recognizable at small size"*

### 5.7b Menu utama / Home (2026-11-22 — percobaan generate AI diblokir, lihat Decisions Log)

Akses generate AI dari sesi ini masih diblokir ("Requires basic plan or higher", sama seperti kendala 2026-11-19/20). Prompt di bawah ini **siap ditempel manual** ke tool AI image (Midjourney/ChatGPT/Ideogram/dll) oleh tim.

**Background Home** (1 gambar, landscape):

> *"Flat vector cartoon illustration, children's educational mobile game main menu background, wide landscape scene: soft pastel blue sky at top with a few fluffy rounded clouds, warm smiling cartoon sun in upper corner with simple rounded rays, two-tone fresh green rolling grass hills at bottom with small simple flowers, bright cheerful colors, rounded friendly shapes, thick consistent outlines, flat soft shading, no gradients that look realistic, no photorealism, no text, no characters in the center (keep center area relatively open and uncluttered for UI buttons to be placed on top), toy-like charming art style similar to Duolingo ABC or Khan Academy Kids, vibrant but not neon"* — aspect ratio **16:9**.

**Tombol utama "Play"** (reusable, bukan gambar sekali pakai — lihat catatan di bawah):

> *"Flat vector cartoon game UI button asset, wide rounded pill / capsule shape banner, warm saturated yellow-orange gradient within flat shading limits, thick cute dark outline, glossy soft highlight on top edge, small flat drop shadow underneath, flat straight stretchable middle section with rounded end caps (like a mobile game 'Play' button background), completely empty inside with no text or icon, isolated on transparent background, children's educational app style, not realistic, no 3D render"* — aspect ratio **3:1**.

**Tombol sekunder "Pilih Game"** (keluarga visual sama, varian lebih kalem):

> *"Flat vector cartoon game UI button asset, wide rounded pill / capsule shape banner, same style and outline thickness as a matching primary button but in a secondary/lighter variant: soft cream white fill with a warm colored outline border, subtle flat shading, small flat drop shadow underneath, flat straight stretchable middle section with rounded end caps, completely empty inside with no text or icon, isolated on transparent background, children's educational app style, not realistic, no 3D render"* — aspect ratio **3:1**.

**Kenapa "reusable"/responsive penting** (sesuai permintaan user): tombol **jangan** digambar sebagai 1 ukuran tetap dengan teks ter-bake di dalamnya — teks ("▶ Play", "Pilih Game") tetap dirender terpisah oleh Godot (`Label`/`Button.text`) di ATAS gambar ini. Desain pill/kapsul dengan "ujung bulat + badan tengah lurus" supaya nanti bisa dipasang sebagai **`NinePatchRect`** (9-slice) di Godot — 1 gambar kecil bisa di-stretch jadi tombol lebar berapa pun (menyesuaikan teks "▶ Play" vs "Pilih Game" yang beda panjang, atau beda ukuran layar HP/tablet) tanpa distorsi di bagian ujung bulatnya. Begitu file-nya ada, implementasi `NinePatchRect` ini task kode terpisah (bukan cuma taruh file gambar), catat sebagai task baru di `docs/TASK_BOARD.md` kalau sudah mau dikerjakan.

### 5.7 Maskot karakter (usulan baru, BELUM diputuskan — lihat `obsidian-vault/Referensi-LucasAndFriends.md`)

*"...a cute round friendly mascot character, bright warm yellow-orange color, big round eyes, simple smiling expression, soft rounded body with no arms/legs detail OR simple stubby arms and legs, standing pose, children's educational app mascot style"*

**Catatan**: ini baru ide, belum ada keputusan nama/kepribadian/dipakai di mana saja (Splash? Home? reward overlay?). Kalau mau lanjut, perlu 1 keputusan desain dulu sebelum generate banyak pose — generate 1 karakter dasar dulu, review, baru putuskan pose tambahan apa saja yang dibutuhkan.

---

## 6. Alur kerja disarankan

1. Generate 1 aset dulu (saran: 1 hewan, misal kucing) pakai prompt di atas.
2. Cek hasilnya cocok sama prinsip bagian 1-4 (bentuk membulat, tanpa merah murni, transparan, dst).
3. Kalau sudah pas, generate 5 hewan sisanya pakai prompt yang sama + referensi gambar pertama (banyak tool AI bisa "image-to-image" pakai referensi gaya) — supaya 6 hewan terasa 1 keluarga visual yang sama, bukan 6 gaya berbeda.
4. Ulangi pola yang sama buat kategori lain (warna, lalu puzzle, lalu mewarnai — mewarnai paling akhir karena butuh proses manual tambahan).
5. Review ulang semua aset bersama tim sebelum commit ke `features/feature_*/assets/images/` (lihat path di `docs/ASSET_LIST.md`).

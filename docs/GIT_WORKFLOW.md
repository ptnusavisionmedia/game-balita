# Cara Kolaborasi Git — Panduan Lengkap untuk Pemula

Dokumen ini untuk kamu yang **baru pertama kali kerja tim lewat Git/GitHub**. Dibaca pelan-pelan, tidak perlu hafal, cukup paham alurnya — nanti jadi kebiasaan.

---

## 1. Konsep dasar (wajib paham dulu sebelum praktik)

| Istilah | Analoginya | Artinya |
|---|---|---|
| **Repository (repo)** | Folder proyek bersama | Tempat semua kode & histori perubahan disimpan — di kita: [github.com/ptnusavisionmedia/game-balita](https://github.com/ptnusavisionmedia/game-balita) |
| **Clone** | Download folder proyek ke laptop kamu | Hanya dilakukan **sekali** di awal per laptop |
| **Branch** | Cabang/salinan kerja terpisah | Supaya kamu bisa coba-coba ubah kode **tanpa mengganggu** kode orang lain atau versi yang sudah jalan (`main`) |
| **`main`** | Versi "yang sudah pasti benar" | Branch utama. Kode di sini harus selalu dalam kondisi jalan/stabil |
| **Commit** | "Save point" di game | Simpan sekelompok perubahan dengan catatan singkat, bisa di-rewind kalau salah |
| **Push** | Upload | Kirim commit dari laptop kamu ke GitHub |
| **Pull** | Download update | Ambil perubahan terbaru dari GitHub ke laptop kamu |
| **Pull Request (PR)** | "Minta izin gabung" | Permintaan supaya kerjaan di branch kamu digabung ke `main`, sekaligus tempat orang lain **review** kerjaan kamu dulu |
| **Merge** | Gabung | Proses menyatukan branch kamu ke `main`, setelah PR disetujui |
| **Conflict (tabrakan)** | Dua orang edit baris yang sama di file yang sama | Git tidak tahu versi mana yang benar, minta kamu putuskan manual |

**Kenapa pakai branch, bukan langsung edit di `main`?** Supaya kalau kerjaan kamu belum selesai/ada bug, `main` (yang dipakai semua orang sebagai basis) tidak ikut rusak.

---

## 2. Kenapa di proyek ini risiko tabrakan KECIL (tapi bukan nol)

Struktur proyek ini sengaja dibuat per-modul (lihat [docs/ARCHITECTURE.md](ARCHITECTURE.md)):

```
core/                        ← dipegang Bramantyo, SEMUA orang depend ke sini
scenes/                       ← dipegang Dev App
features/
  feature_angka/     ← dipegang Dev 2 — HANYA Dev 2 yang edit folder ini
  feature_warna/     ← dipegang Dev Warna — HANYA dia yang edit folder ini
  feature_hewan/     ← dipegang Dev 3
  feature_musik/     ← dipegang Dev Musik
  feature_mewarnai/  ← dipegang Dev 4
  feature_puzzle/    ← dipegang Dev Puzzle
```

Kalau kamu pegang `feature_angka` dan temanmu pegang `feature_warna`, kalian **tidak pernah menyentuh file yang sama** — jadi secara teknis hampir mustahil tabrakan, asal:

1. Kamu **cuma** mengedit folder modul kamu sendiri, tidak sentuh folder modul orang lain.
2. Kalau butuh sesuatu dari `core/` (misalnya tombol/suara yang belum ada), **minta ke Bramantyo**, jangan langsung edit `core/` sendiri, apalagi `feature_*` lain.

Satu-satunya titik rawan tabrakan: `core/` dan `scenes/`, karena semua orang depend ke situ. Itu kenapa dipegang 2 orang berbeda (Bramantyo + Dev App) yang saling koordinasi, lihat `docs/TEAM.md`.

---

## 3. Setup sekali di awal (per laptop)

```bash
# 1. Download proyek ke laptop (sekali saja)
git clone https://github.com/ptnusavisionmedia/game-balita.git
cd game-balita

# 2. Kenalkan diri ke Git (sekali per laptop)
git config --global user.name "Nama Kamu"
git config --global user.email "email-github-kamu@gmail.com"
```

---

## 4. Alur kerja harian (ULANGI setiap kali mulai kerjaan baru)

### Langkah 1 — Pastikan kamu mulai dari kode TERBARU

```bash
git checkout main
git pull origin main
```

> Ibarat: sebelum mulai nulis, pastikan kamu baca draft paling baru, bukan draft seminggu lalu.

### Langkah 2 — Buat branch baru khusus kerjaan ini

```bash
git checkout -b feature/angka-level-1
```

Format nama branch: `feature/<nama-modul>-<deskripsi-singkat>`. Contoh:
- `feature/angka-level-1`
- `feature/warna-shape-matching`
- `feature/puzzle-drag-snap`

> **Kenapa bukan langsung kerja di `main`?** Karena kalau kerjaanmu belum selesai dan tiba-tiba harus berhenti, `main` tidak ikut berantakan. Juga supaya ada "pintu review" (PR) sebelum masuk ke kode utama.

### Langkah 3 — Kerja seperti biasa

Edit file **hanya** di `features/<modul-kamu>/...` (atau `core/`/`scenes/` sesuai peranmu). Jangan edit folder modul orang lain, jangan edit `core/` tanpa koordinasi dengan Bramantyo.

### Langkah 4 — Simpan kerjaanmu (commit), sesering mungkin

```bash
git add features/feature_angka
git commit -m "angka: tambah layar soal level 1"
```

Tips nulis pesan commit: `<modul>: <apa yang berubah>`, singkat, pakai bahasa biasa. Commit kecil-kecil lebih baik daripada 1 commit besar di akhir — lebih mudah di-rewind kalau ada yang salah.

### Langkah 5 — Upload branch kamu ke GitHub

```bash
git push -u origin feature/angka-level-1
```

> Ini **TIDAK** langsung masuk ke `main`. Ini cuma upload branch kamu sendiri — aman, tidak mempengaruhi siapa pun.

### Langkah 6 — Buka Pull Request (PR) di GitHub

1. Buka [github.com/ptnusavisionmedia/game-balita](https://github.com/ptnusavisionmedia/game-balita).
2. GitHub biasanya langsung menampilkan tombol kuning **"Compare & pull request"** setelah kamu push — klik itu.
3. Isi judul & deskripsi singkat (boleh ikuti template yang sudah ada otomatis).
4. Klik **Create pull request**.
5. GitHub otomatis minta review ke pemilik modul terkait (diatur lewat [.github/CODEOWNERS](../.github/CODEOWNERS)).

### Langkah 7 — Tunggu review, perbaiki kalau diminta

Kalau reviewer kasih komentar "tolong ubah X", kamu edit lagi di branch yang sama (langkah 3-5 lagi, branch-nya tidak usah baru), push lagi — PR yang sama otomatis ter-update.

### Langkah 8 — Setelah PR di-merge

```bash
git checkout main
git pull origin main
```

Branch `feature/angka-level-1` boleh dihapus (GitHub biasanya kasih tombol "Delete branch" otomatis setelah merge). Lalu **ulangi dari Langkah 1** untuk kerjaan selanjutnya.

---

## 5. Aturan supaya kolaborasi 15 orang tetap rapi

1. ❌ **Jangan pernah** `git push` langsung ke `main`, **kecuali** commit yang HANYA mengubah baris status di `docs/TASK_BOARD.md` (klaim/done task — lihat `CLAUDE.md` LANGKAH 0). Semua perubahan lain lewat Pull Request, walau kerjaan kecil.
2. ✅ **1 Pull Request = 1 modul** (idealnya). Jangan campur perubahan `feature_angka` dan `feature_warna` di PR yang sama — ini aturan kebiasaan, bukan dipaksa alat apa pun, supaya tidak menghalangi fix mendesak yang kebetulan menyentuh 2 modul.
3. ✅ **Commit sering, kecil-kecil**, dengan pesan jelas — bukan 1 commit raksasa "update banyak" di akhir minggu.
4. ✅ Sebelum mulai kerjaan baru, **selalu** `git checkout main && git pull origin main` dulu (Langkah 1) — supaya kamu kerja dari versi terbaru.
5. ❌ **Jangan edit folder/file di luar scope kamu**, kecuali bug fix kecil yang urgent (PR terpisah + tag pemiliknya). Scope persis per peran ada di [docs/ROLES.md](ROLES.md) — baca itu kalau ragu. Kalau nemu bug yang tidak mendesak, cukup laporkan (buat Issue di GitHub), jangan edit langsung.
6. ✅ Butuh sesuatu dari `core`? Minta ke Bramantyo, jangan copy-paste kode `core` ke modulmu sendiri.
7. ✅ Buka project di Godot Editor dan cek tidak ada error di panel Output sebelum push (lihat [CONTRIBUTING.md](../CONTRIBUTING.md)) — supaya tidak kirim kode yang jelas-jelas error.
8. ✅ PR kamu otomatis minta review ke pemilik folder terkait ([.github/CODEOWNERS](../.github/CODEOWNERS)) — ini cuma auto-assign reviewer, bukan gate yang blok merge, supaya proses tetap cepat.

---

## 6. Kalau tetap kejadian conflict (tabrakan)

Ini paling sering terjadi kalau 2 orang **sama-sama ubah file yang sama** (biasanya cuma `core`/`app`, karena modul lain terpisah). Kalau ini terjadi:

1. Jangan panik — tidak ada kerjaan yang hilang, Git cuma minta diputuskan mana yang dipakai.
2. Jalankan:
   ```bash
   git checkout main
   git pull origin main
   git checkout feature/nama-branch-kamu
   git merge main
   ```
3. Git akan menandai file yang konflik dengan tulisan seperti ini di dalam file:
   ```
   <<<<<<< HEAD
   kode versi kamu
   =======
   kode versi orang lain
   >>>>>>> main
   ```
4. Edit manual — pilih/gabungkan yang benar, **hapus** baris `<<<<<<<`, `=======`, `>>>>>>>`.
5. Simpan file, lalu:
   ```bash
   git add <file-yang-tadi-konflik>
   git commit -m "fix: resolve merge conflict"
   git push
   ```
6. Kalau bingung/tidak yakin mana yang benar — **tanya dulu** ke orang yang ubah bagian itu sebelum asal pilih, atau tanya Bramantyo.

> Kalau kamu disiplin ikuti bagian 4 & 5 di atas (jangan edit folder orang lain, selalu pull sebelum mulai), kemungkinan besar kamu **tidak akan pernah** ketemu conflict selama proyek ini.

---

## 7. Belum nyaman pakai command line?

Boleh pakai **[GitHub Desktop](https://desktop.github.com/)** (aplikasi dengan tampilan visual, drag-and-drop, tanpa perlu ketik command). Alurnya sama persis seperti di atas (branch → commit → push → pull request), cuma semua lewat klik tombol. Cocok untuk yang masih belum terbiasa dengan terminal.

---

## 8. Ringkasan super singkat (tempel di sticky note)

```
checkout main → pull → checkout -b feature/xxx
   ↓ kerja di folder modul sendiri saja
   ↓ add → commit (sering-sering)
   ↓ push
   ↓ buka Pull Request di GitHub
   ↓ tunggu review → perbaiki kalau diminta → merge
   ↓ checkout main → pull → (ulang dari atas)
```

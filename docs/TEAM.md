# Pembagian tim (7 orang)

Prinsip: **1 orang = 1 modul penuh** (UI, logic, asset, test untuk modul itu), supaya tiap orang bisa kerja paralel dari awal sampai selesai tanpa menunggu orang lain, dan tiap sesi Claude cukup diberi konteks 1 folder package saja.

| # | Nama (isi) | Modul (`packages/...`) | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 1 | _(Lead/Architect)_ | `core` + `app` | Design system, navigasi utama, parental gate, integrasi semua fitur, review PR yang menyentuh `core` | `@` |
| 2 | | `feature_angka` | Mini-game berhitung (1-10, drag angka, suara hitung) | `@` |
| 3 | | `feature_warna` | Mini-game kenal warna & bentuk dasar | `@` |
| 4 | | `feature_hewan` | Mini-game suara & nama hewan | `@` |
| 5 | | `feature_musik` | Mini-game piano/perkusi sederhana | `@` |
| 6 | | `feature_mewarnai` | Mini-game mewarnai (tap/drag warna ke pola) | `@` |
| 7 | | `feature_puzzle` | Mini-game puzzle & mencocokkan bentuk/gambar | `@` |

> Isi kolom Nama & GitHub username, lalu update `.github/CODEOWNERS` agar sinkron.

## Kenapa bukan dibagi per layer (FE/BE/Asset/QA)?

Untuk game anak sesederhana ini, tiap mini-game kecil dan hampir berdiri sendiri (tidak ada backend, tidak ada state kompleks antar-fitur). Membagi per layer justru membuat 1 fitur butuh koordinasi 3-4 orang untuk hal sepele. Membagi per fitur membuat setiap orang punya "produk kecil" yang jelas selesainya, dan cocok dengan cara kerja AI-assisted dev: tiap sesi Claude paling efektif kalau scope-nya sempit dan jelas.

Role lintas-modul yang tetap perlu disepakati di awal (bisa dirangkap, tidak perlu orang baru):
- **Asset style guide**: siapa yang menentukan gaya ilustrasi/warna supaya 7 mini-game terasa satu produk (biasanya pemegang `core`).
- **QA lintas modul**: sebelum rilis, satu orang (bisa bergilir) main-in semua modul di device low-end.
- **Release manager**: yang pegang `app`, karena dia yang build APK final.

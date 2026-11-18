# Pembagian tim (7 orang)

Prinsip: **1 orang = 1 modul penuh** (UI, logic, asset, test untuk modul itu), supaya tiap orang bisa kerja paralel dari awal sampai selesai tanpa menunggu orang lain, dan tiap sesi Claude cukup diberi konteks 1 folder package saja.

| # | Nama (isi) | Modul (`packages/...`) | Tanggung jawab | GitHub username |
|---|---|---|---|---|
| 1 | Dev 1 (Lead/Architect) | `core` + `app` | Design system, navigasi utama, parental gate, integrasi semua fitur, review PR yang menyentuh `core` | `@lead-username` |
| 2 | Dev 2 | `feature_angka` | Mini-game berhitung (1-10, drag angka, suara hitung) | `@dev-angka` |
| 3 | Dev 3 | `feature_warna` | Mini-game kenal warna & bentuk dasar | `@dev-warna` |
| 4 | Dev 4 | `feature_hewan` | Mini-game suara & nama hewan | `@dev-hewan` |
| 5 | Dev 5 | `feature_musik` | Mini-game piano/perkusi sederhana | `@dev-musik` |
| 6 | Dev 6 | `feature_mewarnai` | Mini-game mewarnai (tap/drag warna ke pola) | `@dev-mewarnai` |
| 7 | Dev 7 | `feature_puzzle` | Mini-game puzzle & mencocokkan bentuk/gambar | `@dev-puzzle` |

> Placeholder. Ganti "Dev 1".."Dev 7" dengan nama asli dan `@...` dengan username GitHub asli, lalu pastikan `.github/CODEOWNERS` tetap sinkron.

## Kenapa bukan dibagi per layer (FE/BE/Asset/QA)?

Untuk game anak sesederhana ini, tiap mini-game kecil dan hampir berdiri sendiri (tidak ada backend, tidak ada state kompleks antar-fitur). Membagi per layer justru membuat 1 fitur butuh koordinasi 3-4 orang untuk hal sepele. Membagi per fitur membuat setiap orang punya "produk kecil" yang jelas selesainya, dan cocok dengan cara kerja AI-assisted dev: tiap sesi Claude paling efektif kalau scope-nya sempit dan jelas.

Role lintas-modul yang tetap perlu disepakati di awal (bisa dirangkap, tidak perlu orang baru):
- **Asset style guide**: siapa yang menentukan gaya ilustrasi/warna supaya 7 mini-game terasa satu produk (biasanya pemegang `core`).
- **QA lintas modul**: sebelum rilis, satu orang (bisa bergilir) main-in semua modul di device low-end.
- **Release manager**: yang pegang `app`, karena dia yang build APK final.

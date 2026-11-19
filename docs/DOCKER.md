# Docker

## Kenapa

Tim ada 15 orang, semua pakai laptop berbeda. Masalah klasik: "di laptop saya export APK jalan, di laptop kamu error" karena versi Godot beda. Docker di sini dipakai supaya **CI (dan siapa pun yang mau) pakai versi Godot yang sama persis** untuk build/export headless.

## Yang BISA dilakukan lewat Docker

- Export project headless (`godot --headless --export-release/--export-debug`) — build APK/executable tanpa buka editor GUI.
- Validasi project (`godot --headless --check-only` atau sejenisnya) di CI.

## Yang TIDAK bisa lewat Docker

- **Edit/buka project di Godot Editor** (GUI). Editor Godot butuh tampilan grafis interaktif — tidak praktis (dan tidak didukung) jalan di dalam container headless. Untuk kerja harian (edit scene, drag node, preview animasi), tetap install **Godot Editor native** di laptop masing-masing. Docker di sini cuma untuk CI/export yang konsisten, bukan pengganti environment development.

## Install Docker Desktop (sekali per laptop)

Docker Desktop di Windows butuh WSL2 + restart — **jalankan sendiri** langkah ini (bukan sesuatu yang aman dilakukan otomatis dari sesi AI):

```powershell
wsl --install
winget install Docker.DockerDesktop
```

Restart laptop, buka Docker Desktop sekali untuk menyelesaikan setup awal, baru lanjut ke bawah.

## Pakai

Image resmi komunitas untuk CI Godot: [`barichello/godot-ci`](https://github.com/abarichello/godot-ci) (dipakai luas untuk GitHub Actions export headless). Contoh:

```bash
docker run --rm -v "$PWD:/project" barichello/godot-ci:4.3 \
  godot --headless --path /project --export-debug "Android" build/app-debug.apk
```

Export preset ("Android", dst) perlu disiapkan dulu lewat Godot Editor (`Project > Export...`) — hasilnya tersimpan di `export_presets.cfg` (sudah di-`.gitignore` karena bisa berisi path/keystore lokal; kalau mau di-share ke tim, pertimbangkan commit versi tanpa data sensitif).

CI (GitHub Actions, belum dibuat ulang untuk Godot — lihat `docs/TASK_BOARD.md`) akan pakai image yang sama supaya hasil lokal dan di CI konsisten.

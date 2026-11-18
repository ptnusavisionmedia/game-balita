# Kerja tim 7 orang yang semua pakai Claude/AI

Struktur modular di repo ini sudah dirancang supaya tiap orang bisa buka sesi Claude Code sendiri-sendiri tanpa saling ganggu. Beberapa aturan praktis tambahan:

## 1. Scope tiap sesi Claude ke 1 package

Saat mulai kerja, buka Claude Code dengan working directory diarahkan ke `packages/feature_xxx` milikmu (atau beri instruksi di awal: *"kerja hanya di packages/feature_angka, jangan ubah file di luar itu"*). Ini membuat:
- Context window AI lebih fokus → hasil lebih akurat.
- Tidak ada risiko AI "merapikan" atau mengubah file milik orang lain.

## 2. `core` adalah kontrak publik — dokumentasikan, jangan sering diubah bebas

Karena semua modul depend ke `core`, perubahan di sana berdampak ke 6 modul lain sekaligus. Aturannya:
- Setiap widget/service publik di `core` wajib punya doc comment (`///`) yang jelas, supaya sesi Claude milik orang lain cukup baca signature-nya, tidak perlu baca implementasi `core`.
- Perubahan breaking di `core` → wajib PR terpisah, di-review pemegang `core`, dan diumumkan di grup tim sebelum di-merge.
- Kalau fitur butuh sesuatu yang belum ada di `core`: minta ke pemegang `core`/`app`, jangan copy-paste logic sendiri di tiap modul (nanti duplikat 6x).

## 3. Branch & PR

- Branch: `feature/<nama-modul>-<deskripsi-singkat>`, contoh `feature/angka-drag-interaction`.
- 1 PR = 1 modul (hindari PR yang menyentuh 2 `feature_*` berbeda).
- Isi PR template: tandai apakah mayoritas kode dihasilkan AI (`AI-assisted: yes/no`) — bukan untuk melarang, tapi supaya reviewer tahu perlu cek lebih teliti bagian mana (biasanya: audio timing, hit-area tombol, edge case input anak-anak seperti multi-touch acak).
- CI jalan per-package lewat Melos (`melos run analyze`, `melos run test`) sebelum merge.

## 4. Review silang ringan

Karena tiap orang pegang modul berbeda, reviewer tidak perlu paham detail game-nya — cukup cek 3 hal yang sama di semua PR:
1. Tidak ada import ke `feature_*` lain (melanggar aturan arsitektur).
2. Tombol/area sentuh cukup besar untuk anak 1-5 tahun (target minimal ~64dp).
3. Tidak ada asset/audio yang hilang referensinya (app tidak crash saat dibuka).

## 5. Sinkronisasi harian

Karena semua kerja AI-assisted, progres bisa sangat cepat tapi juga mudah divergen. Standup harian singkat (5-10 menit, bisa via chat) cukup jawab 3 hal per orang: modul apa, kemarin sampai mana, ada blocker di `core`/`app` atau tidak. Skill `engineering:standup` bisa dipakai untuk merapikan update ini dari commit/PR masing-masing.

## 6. Rilis

Hanya pemegang `app` yang menjalankan build APK final (`flutter build apk --split-per-abi`), setelah semua `feature_*` di-merge ke `main` dan lolos checklist QA lintas modul (lihat `docs/TEAM.md`).

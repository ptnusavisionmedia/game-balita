# Master Prompt — Cara Mulai Sesi Claude untuk Proyek Ini

Dokumen ini isinya **template prompt** yang kamu tempel sebagai pesan **pertama** setiap kali buka sesi Claude (Claude Code/claude.ai) baru untuk kerja di repo ini. Tujuannya: Claude langsung tahu siapa kamu, scope kerja kamu, dan otomatis ikut protokol `CLAUDE.md` LANGKAH 0 — tanpa kamu perlu jelaskan ulang tiap kali.

## Kenapa butuh ini (bukan cuma andalkan CLAUDE.md)

`CLAUDE.md` di root repo **otomatis terbaca** Claude Code tiap sesi dibuka di folder ini — itu sudah cukup untuk aturan umum (urutan dokumen, cara klaim task, batas folder). Tapi `CLAUDE.md` **tidak tahu siapa kamu**. Master prompt ini isinya info yang cuma kamu yang tahu: nama, role, dan task yang mau dikerjakan sekarang.

## Template — Developer

```
Saya [NAMA KAMU], role saya [Bramantyo / Dev 2 / Dev 3 / Dev 4 / Dev Testing] di
proyek Bayi GuguGaga (lihat docs/TEAM.md untuk detail role ini).

Scope folder saya: [isi dari docs/ROLES.md, misal "features/feature_angka/ dan
features/feature_warna/"]. JANGAN edit file di luar itu kecuali bug fix kecil
yang urgent (ikuti aturan di docs/ROLES.md).

Sebelum mulai: ikuti CLAUDE.md LANGKAH 0 — cek docs/TASK_BOARD.md, klaim task
yang relevan dengan role saya, commit "claim: ..." duluan sebelum kerja.

Task yang mau saya kerjakan sekarang: [isi task spesifik, atau tulis "lihat
docs/JOBS_BASE_MODEL.md bagian saya dan tanya saya kalau ada beberapa pilihan"].

Jelaskan dulu rencana kamu secara singkat sebelum mulai coding — saya mau
review dulu sebelum dieksekusi.
```

## Template — Asset/Design Creator (tidak coding)

```
Saya [NAMA KAMU], role saya [Asset 1 - Ilustrasi / Asset 2 - Audio-VO / Asset 3
- Video-Marketing] di proyek Bayi GuguGaga. Saya TIDAK coding.

Tolong bantu saya: [isi kebutuhan konkret, misal "susun draft style guide
ilustrasi", "cari referensi SFX ramah anak", "buat storyboard video promo"].

Taruh/simpan hasilnya di folder yang sesuai (lihat docs/ROLES.md): ilustrasi di
`features/<modul>/assets/images/`, audio di `features/<modul>/assets/audio/`,
konten promosi di `marketing/`.

Sebelum mulai: ikuti CLAUDE.md LANGKAH 0 — cek docs/TASK_BOARD.md, klaim task
yang relevan dengan role saya.

Task yang mau saya kerjakan sekarang: [isi, atau lihat docs/JOBS_BASE_MODEL.md
Job 6-8].
```

## Catatan pemakaian

- Isi bagian `[...]` sesuai dirimu — jangan kirim mentah dengan tanda kurung siku-nya.
- Kalau task belum jelas mau yang mana, biarkan Claude tanya (sudah diwajibkan di `CLAUDE.md` — Claude tidak akan asal klaim task orang lain).
- Master prompt ini **bukan pengganti** baca `docs/TEAM.md`/`docs/ROLES.md` sendiri — cukup untuk tahu role & scope kasar, tapi kalau ragu, baca dokumennya langsung.
- Kalau kamu salah satu dari 8 orang di tim dan belum tahu role GitHub username kamu, isi placeholder nama dulu (`@dev-angka-warna` dst di `docs/TEAM.md`/`.github/CODEOWNERS`) — bukan bagian dari prompt ini, tapi perlu diisi sekali di awal biar PR auto-assign reviewer jalan.

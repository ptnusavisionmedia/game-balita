# Privacy Policy — Wawa

Status: **DRAFT**, belum dipublikasikan. PIC: Bramantyo (lihat `docs/TEAM.md`, `obsidian-vault/Decisions Log.md` 2026-11-20).

> **Sebelum submit ke Play Store**, dokumen ini wajib: (1) diisi bagian `[ISI: ...]` di bawah, (2) di-review oleh tim, (3) **dipublikasikan di URL publik** (bukan cuma file di repo) — Google Play Console mensyaratkan link privacy policy yang bisa diakses browser tanpa login, misalnya lewat GitHub Pages dari repo ini atau halaman di situs resmi tim. Sampai 3 langkah itu selesai, app **tidak bisa** disubmit.

---

## 1. Ringkasan (bahasa sederhana untuk orang tua)

**Wawa tidak mengumpulkan, menyimpan di server, atau membagikan data pribadi apa pun.** Semua progres permainan disimpan **hanya di device Anda**, tidak pernah dikirim ke internet. Tidak ada akun, tidak ada iklan, tidak ada pembelian dalam aplikasi, tidak ada pelacakan.

## 2. Data apa yang disimpan, dan di mana

| Data | Disimpan di mana | Dikirim ke internet? |
|---|---|---|
| Hasil/skor per modul (`ProgressRepository`) | Lokal di device (`ConfigFile`, folder data aplikasi) | **Tidak** |
| Pengaturan suara on/off | Lokal di device | **Tidak** |
| Nama, email, nomor telepon, foto, lokasi, kontak | **Tidak pernah diminta/disimpan** | — |
| Identitas perangkat (advertising ID, IMEI, dll) | **Tidak diakses** | — |

App **tidak meminta izin khusus apa pun** di Android (tidak ada akses kamera, mikrofon, lokasi, kontak, penyimpanan eksternal, atau internet) — lihat `export_presets.cfg` (`permissions/custom_permissions` kosong). Satu-satunya "penyimpanan" adalah data internal aplikasi milik Android sendiri (sandbox per-app), yang otomatis terhapus kalau aplikasi di-uninstall atau pengguna pilih "Hapus data" di Pengaturan Android.

## 3. Pihak ketiga

**Tidak ada SDK pihak ketiga** di aplikasi ini — tidak ada SDK iklan (AdMob dkk), tidak ada SDK analytics (Firebase Analytics dkk), tidak ada SDK login/sosial. Lihat `docs/LIBRARIES.md` — semua fitur (audio, animasi, penyimpanan progres) pakai fitur bawaan Godot Engine, bukan library eksternal yang mengirim data keluar device.

Konsekuensinya: **tidak ada data yang dibagikan ke pihak ketiga mana pun**, karena tidak ada jalur komunikasi keluar yang dibangun di aplikasi ini sama sekali (app berjalan 100% offline).

## 4. Iklan & pembelian dalam aplikasi

**Tidak ada.** Lihat prinsip desain #7 `docs/UI_UX_DESIGN.md` — sengaja tidak ada iklan, popup, atau in-app purchase, supaya anak kecil tidak bisa menekan sesuatu yang mengarah keluar aplikasi atau memicu transaksi tanpa sengaja.

## 5. Kepatuhan Google Play Families Policy

Aplikasi ini ditujukan untuk anak usia 1-5 tahun (dengan orang tua sebagai pengawas), dan dirancang mematuhi [Google Play Families Policy](https://play.google.com/about/families/):

- **Tidak ada pengumpulan data pribadi dari anak** (lihat bagian 2) — tidak ada formulir, tidak ada login, tidak ada chat.
- **Tidak ada iklan berperilaku (behavioral advertising)** — karena memang tidak ada iklan sama sekali (bagian 4).
- **Tidak ada link keluar aplikasi yang bisa ditekan anak tanpa sengaja** — satu-satunya jalan keluar (Settings, yang berisi toggle suara) dilindungi `ParentalGateDialog` (soal tambah sederhana + keypad angka, dirancang agar anak kecil tidak bisa menjawab tapi orang tua bisa) — lihat `docs/UI_UX_DESIGN.md` prinsip #7 dan `core/scripts/parental_gate_dialog.gd`.
- **Konten sesuai umur**: tidak ada kekerasan, tidak ada "game over" yang menghukum (prinsip #4), tidak ada elemen yang memicu kejang foto-sensitif (prinsip #6).
- **Tidak ada fitur media sosial/chat** yang memungkinkan anak berkomunikasi dengan orang lain.

## 6. Hak pengguna (orang tua/wali)

Karena tidak ada data yang dikirim ke server mana pun, **tidak ada data untuk diminta dihapus/diekspor dari pihak kami** — semua data ada di device Anda dan sepenuhnya dalam kendali Anda:
- **Hapus semua data**: uninstall aplikasi, atau Pengaturan Android → Aplikasi → Wawa → Hapus Data.
- **Lihat data**: data cuma berupa angka skor/pengaturan suara, tidak ada data sensitif untuk "dilihat" dalam arti privasi.

## 7. Perubahan kebijakan ini

Kalau kebijakan ini berubah (misal nanti ditambah fitur baru yang butuh izin/koneksi internet), versi baru akan dipublikasikan di URL yang sama, dengan tanggal update di bagian paling atas dokumen, dan dicatat di `obsidian-vault/Decisions Log.md`.

## 8. Kontak

`[ISI: email/kontak tim untuk pertanyaan privasi — wajib diisi sebelum publish, lihat PIC Bramantyo]`

---

*Terakhir diperbarui: 2026-11-20 (draft pertama, belum dipublikasikan).*

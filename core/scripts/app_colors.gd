class_name AppColors
extends RefCounted
## Palet warna Wawa. Rasional lengkap (kontras, kenapa bukan merah
## untuk "coba lagi", dsb) ada di docs/UI_UX_DESIGN.md. Cuma definisi di sini
## — tambah warna baru di sini dulu, jangan taruh hex langsung di scene lain.

const SUNSHINE := Color("#FFC93C")  # primary brand
const CREAM := Color("#FFFDF5")  # background utama
const INK := Color("#2B2D42")  # teks

const LEAF := Color("#6FCF97")  # benar
const CORAL := Color("#FF8A65")  # coba lagi (bukan merah)
const GOLD := Color("#FFD166")  # bintang reward

## Background "langit + rumput" dipakai `GameBackground` di semua layar
## main game — terinspirasi riset kompetitor (lihat
## obsidian-vault/Referensi-LucasAndFriends.md): warna sejuk pastel =
## dekorasi/latar, warna hangat jenuh = elemen interaktif.
const SKY := Color("#BDEBFB")
const GRASS := Color("#C3EFA0")
const GRASS_DARK := Color("#AEE487")

const ACCENT_ANGKA := Color("#4FC3F7")
const ACCENT_WARNA := Color("#FF8A65")
const ACCENT_HEWAN := Color("#6FCF97")
const ACCENT_MUSIK := Color("#B39DDB")
const ACCENT_MEWARNAI := Color("#F48FB1")
const ACCENT_PUZZLE := Color("#4DB6AC")

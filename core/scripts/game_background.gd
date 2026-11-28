extends Control
class_name GameBackground
## Background Home + semua `feature_*`.
##
## Update 2026-11-22: diganti dari versi code-drawn (langit+rumput+
## matahari lewat `_draw()`) jadi **ilustrasi asli** — digenerate user
## sendiri lewat ChatGPT, pakai prompt dari
## `docs/STYLE_GUIDE_ILUSTRASI.md` bagian 5.7b, ditaruh di
## `core/assets/images/home_background.png`. Lihat Decisions Log.
##
## `STRETCH_KEEP_ASPECT_COVERED` + `clip_contents` — gambar sumber (16:9)
## nyaris sama rasio dengan base desain 1280x720, tapi device nyata bisa
## beda rasio (HP vs tablet) — mode ini jamin TIDAK PERNAH distorsi
## (gambar diperbesar proporsional lalu dipotong tepinya kalau perlu),
## bukan di-stretch paksa jadi gepeng/melar.

const BACKGROUND_TEXTURE := preload("res://core/assets/images/home_background.png")

## Update 2026-11-28 (hasil riset komposisi warna, lihat obsidian-vault/
## Decisions Log.md): referensi game anak yang "enak dipandang" selalu
## mewarnai BACKGROUND sesuai tema/kategori yang sedang dibuka, bukan 1
## background generik yang sama di semua layar — anak langsung dapat
## isyarat warna "saya lagi main yang mana" begitu layar terbuka, bukan
## cuma dari judul teks. Set `tint_color` (biasanya `AppColors.ACCENT_*`
## modulnya) SEBELUM `add_child(GameBackground.new())` di tiap `feature_*`.
## Sengaja TINT TIPIS (~10% alpha) di ATAS ilustrasi asli, BUKAN ganti
## gambar background — prinsip sama dengan awan: nambah "rasa", bukan
## bikin elemen baru yang mengalihkan fokus dari konten utama.
const TINT_ALPHA := 0.1
@export var tint_color: Color = Color(0, 0, 0, 0)

## Update 2026-11-28 (atas permintaan user, "background hambar/statis"):
## tambah 1-2 awan kecil yang GESER PELAN horizontal di atas gambar statis
## (bukan ganti gambar background-nya) — supaya layar terasa hidup tanpa
## elemen baru yang bisa mengalihkan fokus dari tombol/konten utama.
## Sengaja CUMA posisi (bukan animasi lain yang lebih ramai) & kecepatan
## sangat pelan (~1 lintasan layar per 40-55 detik) — prinsip "dekorasi,
## bukan distraksi" (docs/UI_UX_DESIGN.md: warna sejuk pastel = dekorasi).
const CLOUD_TEXTURE_PATH := "res://core/assets/images/decor/cloud_small.png"
const CLOUD_CONFIGS := [
	{"y_ratio": 0.08, "size": 120.0, "duration": 42.0, "start_ratio": 0.15},
	{"y_ratio": 0.18, "size": 80.0, "duration": 55.0, "start_ratio": 0.65},
]

## Update 2026-11-28 (fix bug dilaporkan user: "awan sangat besar
## tiba-tiba bergeser"): dulu posisi digerakkan `Tween` yang DIBUAT ULANG
## tiap 1 siklus penuh, dengan `screen_width` dihitung ULANG persis di
## awal tiap siklus itu — kalau viewport resize SELAMA tween jalan,
## target akhir tween (`right_edge`) lama sudah tidak sesuai lebar layar
## BARU, jadi di titik sambung siklus kelihatan lompat/snap. Sekarang
## posisi digerakkan manual tiap frame lewat `_process` dan
## `get_rect().size.x` dibaca ULANG TIAP FRAME (bukan di-cache per
## siklus) — resize kapan pun tidak pernah bikin snap, karena posisi
## selalu dihitung ulang relatif lebar layar SAAT ITU, bukan lebar lama.
var _clouds: Array = []


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true

	var texture_rect := TextureRect.new()
	texture_rect.texture = BACKGROUND_TEXTURE
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	# expand_mode = IGNORE_SIZE WAJIB di sini — tanpa ini, TextureRect
	# melapor "minimum size"-nya = ukuran asli gambar (1672x941), jadi
	# yang kelihatan cuma bagian kiri-atas gambar hampir 1:1 piksel
	# (kebanyakan langit, rumputnya nyaris hilang di bawah batas layar)
	# — bukan di-scale buat nutup seluruh layar. Bug ini dilaporkan user
	# 2026-11-22 ("bg tidak full dipakai"). Lihat Decisions Log.
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(texture_rect)

	if tint_color.a > 0.0:
		var tint_rect := ColorRect.new()
		tint_rect.color = Color(tint_color.r, tint_color.g, tint_color.b, TINT_ALPHA)
		tint_rect.anchor_right = 1.0
		tint_rect.anchor_bottom = 1.0
		tint_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(tint_rect)

	if FileAccess.file_exists(CLOUD_TEXTURE_PATH):
		for config in CLOUD_CONFIGS:
			_add_drifting_cloud(config)


## 1 awan = 1 TextureRect digeser tiap frame di `_process` (lihat
## komentar `_clouds` di atas untuk alasan kenapa bukan `Tween` lagi).
## `visible = false` sampai posisi awal valid — mencegah kedip 1 frame
## di pojok kiri-atas (0,0) sebelum offset sungguhan diset.
func _add_drifting_cloud(config: Dictionary) -> void:
	var cloud := TextureRect.new()
	cloud.texture = load(CLOUD_TEXTURE_PATH)
	var size: float = config["size"]
	cloud.custom_minimum_size = Vector2(size, size)
	cloud.size = Vector2(size, size)
	cloud.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	cloud.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	cloud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cloud.anchor_top = config["y_ratio"]
	cloud.anchor_bottom = config["y_ratio"]
	cloud.visible = false
	add_child(cloud)

	_clouds.append({
		"node": cloud,
		"duration": float(config["duration"]),
		"progress": float(config["start_ratio"]),
	})


func _process(delta: float) -> void:
	if _clouds.is_empty():
		return
	var screen_width := get_rect().size.x
	if screen_width <= 0.0:
		return  # layout belum siap, tunggu frame berikutnya (lihat komentar `_clouds`)

	for c in _clouds:
		var cloud: TextureRect = c["node"]
		if not is_instance_valid(cloud):
			continue
		var cloud_width: float = cloud.size.x
		var progress: float = c["progress"] + delta / c["duration"]
		c["progress"] = fmod(progress, 1.0)

		var left_edge := -cloud_width
		var right_edge := screen_width + cloud_width
		var x: float = lerp(left_edge, right_edge, c["progress"])
		cloud.offset_left = x
		cloud.offset_right = x + cloud_width
		cloud.offset_top = 0.0
		cloud.offset_bottom = cloud_width
		cloud.visible = true

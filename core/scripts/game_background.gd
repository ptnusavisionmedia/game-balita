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

	if FileAccess.file_exists(CLOUD_TEXTURE_PATH):
		for config in CLOUD_CONFIGS:
			_add_drifting_cloud(config)


## 1 awan = 1 TextureRect yang digeser looping dari luar kiri layar ke
## luar kanan layar pakai `Tween` (posisi relatif terhadap LEBAR LAYAR
## SAAT INI, bukan angka piksel tetap, supaya tetap benar di device
## rasio berapa pun — pola sama alasannya kayak semua anchor di app ini).
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
	add_child(cloud)

	var duration: float = config["duration"]
	var start_ratio: float = config["start_ratio"]

	# `call_deferred` + loop manual (bukan `Tween.set_loops()`) — supaya
	# titik mulai tiap awan ditentukan `start_ratio` (awan tidak semua
	# mulai dari tepi kiri bersamaan, terasa lebih alami), baru siklus
	# berikutnya full dari luar-kiri ke luar-kanan.
	_drift_once.call_deferred(cloud, duration, start_ratio)


func _drift_once(cloud: TextureRect, duration: float, start_ratio: float) -> void:
	if not is_instance_valid(cloud):
		return
	var screen_width := get_rect().size.x
	if screen_width <= 0.0:
		screen_width = 1280.0  # fallback kalau dipanggil sebelum layout siap

	var cloud_width: float = cloud.size.x
	var left_edge := -cloud_width
	var right_edge := screen_width + cloud_width
	var start_x: float = lerp(left_edge, right_edge, start_ratio)

	cloud.offset_left = start_x
	cloud.offset_right = start_x + cloud_width
	cloud.offset_top = 0.0
	cloud.offset_bottom = cloud_width

	var remaining_ratio := (right_edge - start_x) / (right_edge - left_edge)
	var tween := create_tween()
	tween.tween_property(cloud, "offset_left", right_edge, duration * remaining_ratio)
	tween.parallel().tween_property(cloud, "offset_right", right_edge + cloud_width, duration * remaining_ratio)
	tween.tween_callback(func():
		if is_instance_valid(cloud):
			_drift_once(cloud, duration, 0.0)  # siklus berikutnya selalu dari tepi kiri
	)

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


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true

	var texture_rect := TextureRect.new()
	texture_rect.texture = BACKGROUND_TEXTURE
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(texture_rect)

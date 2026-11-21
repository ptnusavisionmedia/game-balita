extends Control
class_name GameBackground
## Background "langit + rumput" 2-nada + matahari — dipakai di Home dan
## semua `feature_*`, gantikan latar polos/kosong yang sebelumnya cuma
## warna default kosong di sebagian besar mini-game (salah satu alasan
## "game kurang menarik" yang dilaporkan user 2026-11-21).
##
## Terinspirasi riset kompetitor (lihat
## obsidian-vault/Referensi-LucasAndFriends.md): warna sejuk pastel buat
## latar/dekorasi, warna hangat jenuh (`AppColors.SUNSHINE`/aksen modul)
## buat elemen interaktif — anak bisa bedain "ini bisa ditekan" dari
## kehangatan warnanya tanpa perlu baca. Murni gambar vektor lewat
## `_draw()` (pola sama `ModuleIcon`), tidak perlu ilustrasi baru.

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


func _draw() -> void:
	var s := size
	if s.x <= 0 or s.y <= 0:
		return

	var sky_height := s.y * 0.62
	draw_rect(Rect2(Vector2.ZERO, Vector2(s.x, sky_height)), AppColors.SKY)
	draw_rect(Rect2(Vector2(0, sky_height), Vector2(s.x, s.y - sky_height)), AppColors.GRASS)
	draw_rect(Rect2(Vector2(0, sky_height + (s.y - sky_height) * 0.4), Vector2(s.x, (s.y - sky_height) * 0.6)), AppColors.GRASS_DARK)

	# Matahari sederhana, pojok kanan atas — dekorasi, bukan interaktif.
	draw_circle(Vector2(s.x * 0.88, s.y * 0.14), s.x * 0.045, AppColors.SUNSHINE)

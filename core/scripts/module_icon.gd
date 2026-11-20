extends Control
class_name ModuleIcon
## Ikon placeholder per mini-game, digambar langsung pakai bentuk vector
## dasar (`draw_circle`/`draw_rect`) — bukan file gambar. Dipakai sampai
## Asset 1 kirim ilustrasi final (lihat docs/JOBS_BASE_MODEL.md Job 6).
##
## Kenapa digambar kode, bukan file placeholder: generate image AI tidak
## tersedia di environment ini (butuh plan berbayar) — lihat Decisions Log
## 2026-11-20. Ini jalan tengah gratis & langsung jadi sampai ada ilustrasi asli.

@export var kind: String = "angka"  # angka | warna | hewan | musik | mewarnai | puzzle


func _ready() -> void:
	custom_minimum_size = Vector2(72, 72)


func _draw() -> void:
	var size := get_size()
	var center := size / 2.0
	match kind:
		"angka":
			_draw_angka(center, size)
		"warna":
			_draw_warna(center, size)
		"hewan":
			_draw_hewan(center, size)
		"musik":
			_draw_musik(center, size)
		"mewarnai":
			_draw_mewarnai(center, size)
		"puzzle":
			_draw_puzzle(center, size)


## Angka: 3 titik berjajar, mewakili "berhitung".
func _draw_angka(center: Vector2, size: Vector2) -> void:
	var r := size.x * 0.09
	for i in range(3):
		var x := center.x + (i - 1) * r * 3.0
		draw_circle(Vector2(x, center.y), r, Color.WHITE)


## Warna: beberapa bulatan warna tersusun melingkar.
func _draw_warna(center: Vector2, size: Vector2) -> void:
	var colors := [AppColors.ACCENT_ANGKA, AppColors.GOLD, AppColors.LEAF, Color.WHITE]
	var r := size.x * 0.12
	var orbit := size.x * 0.2
	for i in range(colors.size()):
		var angle := TAU * i / colors.size() - PI / 2.0
		var pos := center + Vector2(cos(angle), sin(angle)) * orbit
		draw_circle(pos, r, colors[i])


## Hewan: muka bulat sederhana dengan 2 telinga.
func _draw_hewan(center: Vector2, size: Vector2) -> void:
	var r := size.x * 0.22
	draw_circle(center, r, Color.WHITE)
	var ear_r := size.x * 0.09
	draw_circle(center + Vector2(-r * 0.7, -r * 0.7), ear_r, Color.WHITE)
	draw_circle(center + Vector2(r * 0.7, -r * 0.7), ear_r, Color.WHITE)
	var eye_r := size.x * 0.04
	draw_circle(center + Vector2(-r * 0.35, -r * 0.1), eye_r, AppColors.INK)
	draw_circle(center + Vector2(r * 0.35, -r * 0.1), eye_r, AppColors.INK)
	draw_circle(center + Vector2(0, r * 0.35), eye_r * 1.3, AppColors.INK)


## Musik: 1 not musik sederhana (kepala bulat + tangkai).
func _draw_musik(center: Vector2, size: Vector2) -> void:
	var note_r := size.x * 0.12
	var head := center + Vector2(-size.x * 0.1, size.y * 0.12)
	draw_circle(head, note_r, Color.WHITE)
	draw_rect(Rect2(head.x + note_r - 2.0, head.y - size.y * 0.4, 4.0, size.y * 0.4), Color.WHITE)


## Mewarnai: 3 krayon warna-warni berjajar.
func _draw_mewarnai(center: Vector2, size: Vector2) -> void:
	var colors := [AppColors.ACCENT_ANGKA, AppColors.LEAF, AppColors.CORAL]
	var w := size.x * 0.09
	var h := size.y * 0.5
	for i in range(colors.size()):
		var x := center.x + (i - 1) * w * 1.8
		draw_rect(Rect2(x - w / 2.0, center.y - h / 2.0, w, h), colors[i])


## Puzzle: grid 2x2 kotak selang-seling, mewakili keping puzzle.
func _draw_puzzle(center: Vector2, size: Vector2) -> void:
	var colors := [Color.WHITE, AppColors.GOLD, AppColors.GOLD, Color.WHITE]
	var cell := size.x * 0.16
	var gap := size.x * 0.03
	var idx := 0
	for row in range(2):
		for col in range(2):
			var x := center.x - cell - gap / 2.0 + col * (cell + gap)
			var y := center.y - cell - gap / 2.0 + row * (cell + gap)
			draw_rect(Rect2(x, y, cell, cell), colors[idx])
			idx += 1

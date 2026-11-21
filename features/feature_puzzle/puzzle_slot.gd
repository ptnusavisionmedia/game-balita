extends Panel
## 1 slot target puzzle. "Snap longgar" = area drop-nya besar (ukuran
## slot sendiri, bukan radius piksel kecil) & cuma cek id keping cocok,
## bukan posisi presisi. Lihat obsidian-vault/Specs/feature_puzzle.md.
##
## Pakai `Panel` bawaan Godot (bukan Control + `_draw()` manual) — lihat
## catatan bug & alasan di `puzzle_piece.gd` & Decisions Log 2026-11-21.

signal piece_dropped(piece_id: String)

var expected_piece_id: String = ""
var expected_color: Color = Color.WHITE
var filled: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_apply_empty_style()


func _apply_empty_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = AppColors.INK
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	add_theme_stylebox_override("panel", style)


func _apply_filled_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = expected_color
	style.set_corner_radius_all(12)
	add_theme_stylebox_override("panel", style)


## Keping yang TIDAK cocok cuma ditolak secara diam-diam (Godot otomatis
## balikin ke posisi semula) — tidak ada suara/animasi "salah" di modul
## ini, lihat spek bagian Feedback.
func _can_drop_data(_at_position: Vector2, data) -> bool:
	return not filled and data is Dictionary and data.get("piece_id", "") == expected_piece_id


func _drop_data(_at_position: Vector2, data) -> void:
	filled = true
	_apply_filled_style()
	piece_dropped.emit(data.get("piece_id", ""))

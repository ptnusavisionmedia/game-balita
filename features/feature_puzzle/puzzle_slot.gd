extends Control
## 1 slot target puzzle. "Snap longgar" = area drop-nya besar (ukuran
## slot sendiri, bukan radius piksel kecil) & cuma cek id keping cocok,
## bukan posisi presisi. Lihat obsidian-vault/Specs/feature_puzzle.md.
##
## Gambar lewat `_draw()` langsung di root (pola sama `puzzle_piece.gd`
## & `ModuleIcon`) — bukan child Panel terpisah, lihat catatan bug di
## `puzzle_piece.gd` & Decisions Log 2026-11-21.

signal piece_dropped(piece_id: String)

var expected_piece_id: String = ""
var expected_color: Color = Color.WHITE
var filled: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _draw() -> void:
	if filled:
		draw_rect(Rect2(Vector2.ZERO, size), expected_color)
	else:
		draw_rect(Rect2(Vector2.ZERO, size), AppColors.INK, false, 3.0)


## Keping yang TIDAK cocok cuma ditolak secara diam-diam (ditolak di
## `_can_drop_data`, Godot otomatis balikin ke posisi semula) — tidak
## ada suara/animasi "salah" di modul ini, lihat spek bagian Feedback.
func _can_drop_data(_at_position: Vector2, data) -> bool:
	return not filled and data is Dictionary and data.get("piece_id", "") == expected_piece_id


func _drop_data(_at_position: Vector2, data) -> void:
	filled = true
	queue_redraw()
	piece_dropped.emit(data.get("piece_id", ""))

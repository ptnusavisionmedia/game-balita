extends Control
## 1 slot target puzzle. "Snap longgar" = area drop-nya besar (ukuran
## slot sendiri, bukan radius piksel kecil) & cuma cek id keping cocok,
## bukan posisi presisi. Lihat obsidian-vault/Specs/feature_puzzle.md.

signal piece_dropped(piece_id: String)

var expected_piece_id: String = ""
var expected_color: Color = Color.WHITE
var filled: bool = false

var _panel: Panel


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_panel = Panel.new()
	_panel.anchor_right = 1.0
	_panel.anchor_bottom = 1.0
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panel)
	_apply_empty_style()


func _apply_empty_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = AppColors.INK
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	_panel.add_theme_stylebox_override("panel", style)


func mark_filled_visual() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = expected_color
	style.set_corner_radius_all(12)
	_panel.add_theme_stylebox_override("panel", style)


func _can_drop_data(_at_position: Vector2, data) -> bool:
	return not filled and data is Dictionary and data.get("piece_id", "") == expected_piece_id


## Keping yang TIDAK cocok cuma ditolak secara diam-diam (tidak snap,
## kembali ke posisi semula otomatis karena memang tidak dianggap
## "didrop" di slot ini) — tidak ada suara/animasi "salah" di modul ini,
## lihat obsidian-vault/Specs/feature_puzzle.md bagian Feedback.
func _drop_data(_at_position: Vector2, data) -> void:
	filled = true
	mark_filled_visual()
	piece_dropped.emit(data.get("piece_id", ""))

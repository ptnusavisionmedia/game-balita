extends Control
## 1 keping puzzle draggable — lihat obsidian-vault/Specs/feature_puzzle.md.
## Placeholder: kotak warna polos (ganti potongan gambar asli begitu ada)
## — warna piece = warna slot tujuan, jadi anak bisa cocokkan dari warna
## sambil nunggu ilustrasi final.

var piece_id: String = ""
var piece_color: Color = Color.WHITE

var _panel: Panel


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_panel = Panel.new()
	_panel.anchor_right = 1.0
	_panel.anchor_bottom = 1.0
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panel)

	var style := StyleBoxFlat.new()
	style.bg_color = piece_color
	style.set_corner_radius_all(12)
	_panel.add_theme_stylebox_override("panel", style)


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := Panel.new()
	preview.size = size
	var style := StyleBoxFlat.new()
	style.bg_color = piece_color
	style.set_corner_radius_all(12)
	preview.add_theme_stylebox_override("panel", style)
	set_drag_preview(preview)
	return {"piece_id": piece_id}

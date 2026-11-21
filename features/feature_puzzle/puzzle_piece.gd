extends Control
## 1 keping puzzle draggable — lihat obsidian-vault/Specs/feature_puzzle.md.
## Placeholder: kotak warna polos (ganti potongan gambar asli begitu ada).
##
## Gambar lewat `_draw()` LANGSUNG di root Control (pola sama ModuleIcon),
## BUKAN lewat child Panel terpisah — versi awal pakai child Panel dengan
## mouse_filter IGNORE di atasnya, tapi itu bikin piece TIDAK BISA
## diklik/di-drag sama sekali (dilaporkan user 2026-11-21). _get_drag_data
## cuma reliable kalau node yang override dia juga yang langsung menang
## hit-test mouse, tanpa child lain yang berpotensi menutupi. Lihat
## Decisions Log.

var piece_id: String = ""
var piece_color: Color = Color.WHITE


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), piece_color)


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := ColorRect.new()
	preview.size = size
	preview.color = piece_color
	set_drag_preview(preview)
	return {"piece_id": piece_id}

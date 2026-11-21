extends ColorRect
## 1 keping puzzle draggable — lihat obsidian-vault/Specs/feature_puzzle.md.
## Placeholder: kotak warna polos (ganti potongan gambar asli begitu ada).
##
## Update 2026-11-21 (ke-2): dulu pakai Control + child Panel (terbukti
## tidak bisa diklik sama sekali), diganti ke Control + `_draw()` manual
## (jadi bisa diklik tapi cuma di 1 titik kecil, bukan seluruh kotak —
## hit-test vs area gambar tidak sinkron). Sekarang pakai `ColorRect`
## bawaan Godot langsung — node ini sudah mengurus ukuran & hit-test-nya
## sendiri secara konsisten (dipakai juga di background Home/Splash,
## fade_rect GameFlow), jadi dijamin area klik = area gambar. Lihat
## Decisions Log 2026-11-21.

var piece_id: String = ""
var piece_color: Color = Color.WHITE


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	color = piece_color


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := ColorRect.new()
	preview.size = size
	preview.color = piece_color
	set_drag_preview(preview)
	return {"piece_id": piece_id}

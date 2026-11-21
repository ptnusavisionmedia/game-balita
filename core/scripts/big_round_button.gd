extends Button
class_name BigRoundButton
## Tombol bulat besar, hit-area minimum 120px (lihat docs/UI_UX_DESIGN.md
## — dinaikkan dari 88px 2026-11-21, mengikuti rekomendasi riset
## kompetitor di obsidian-vault/Referensi-LucasAndFriends.md).
## Dipakai semua mini-game supaya konsisten.

@export var accent_color: Color = AppColors.SUNSHINE


func _ready() -> void:
	custom_minimum_size = Vector2(120, 120)
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_font_size_override("font_size", 28)

	var style := StyleBoxFlat.new()
	style.bg_color = accent_color
	style.set_corner_radius_all(999)
	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("hover", style)
	add_theme_stylebox_override("pressed", style)
	add_theme_stylebox_override("focus", style)

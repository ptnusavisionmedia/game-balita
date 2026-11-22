extends Control
## Splash screen singkat (logo/judul) sebelum Home — auto lanjut lewat
## GameFlow setelah ~1.2 detik. Lihat docs/UI_UX_DESIGN.md "Information
## architecture" (Splash → Home).

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var bg := ColorRect.new()
	bg.color = AppColors.SUNSHINE
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)

	var title := Label.new()
	title.text = "Wawa"
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.anchor_right = 1.0
	title.anchor_bottom = 1.0
	add_child(title)

	await get_tree().create_timer(1.2).timeout
	GameFlow.goto_scene("res://scenes/Home.tscn")

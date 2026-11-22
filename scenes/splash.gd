extends Control
## Splash screen singkat (logo/judul) sebelum Home — auto lanjut lewat
## GameFlow setelah ~1.2 detik. Lihat docs/UI_UX_DESIGN.md "Information
## architecture" (Splash → Home).
##
## Update 2026-11-22: pakai maskot "Wawa" pose melambai (lihat
## docs/ASSET_LIST.md #8) kalau filenya ada — fallback judul teks polos
## kalau belum.

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var bg := ColorRect.new()
	bg.color = AppColors.SUNSHINE
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 12)
	add_child(vbox)

	var mascot_path := "res://core/assets/images/mascot/wawa_melambai.png"
	if FileAccess.file_exists(mascot_path):
		var mascot := TextureRect.new()
		mascot.texture = load(mascot_path)
		mascot.custom_minimum_size = Vector2(240, 240)
		mascot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		mascot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		vbox.add_child(mascot)

	var title := Label.new()
	title.text = "Wawa"
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	await get_tree().create_timer(1.2).timeout
	GameFlow.goto_scene("res://scenes/Home.tscn")

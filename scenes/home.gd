extends Control
## Menu utama: 1 tombol besar per mini-game + tombol Settings.
## Tambah mini-game baru = tambah 1 baris di `_GAMES`, tidak lebih.

const _GAMES := [
	{"name": "Angka", "kind": "angka", "scene": "res://features/feature_angka/Angka.tscn"},
	{"name": "Warna", "kind": "warna", "scene": "res://features/feature_warna/Warna.tscn"},
	{"name": "Hewan", "kind": "hewan", "scene": "res://features/feature_hewan/Hewan.tscn"},
	{"name": "Musik", "kind": "musik", "scene": "res://features/feature_musik/Musik.tscn"},
	{"name": "Mewarnai", "kind": "mewarnai", "scene": "res://features/feature_mewarnai/Mewarnai.tscn"},
	{"name": "Puzzle", "kind": "puzzle", "scene": "res://features/feature_puzzle/Puzzle.tscn"},
]

## Warna aksen per modul, sinkron dengan docs/UI_UX_DESIGN.md.
static func _accent_for(kind: String) -> Color:
	match kind:
		"angka": return AppColors.ACCENT_ANGKA
		"warna": return AppColors.ACCENT_WARNA
		"hewan": return AppColors.ACCENT_HEWAN
		"musik": return AppColors.ACCENT_MUSIK
		"mewarnai": return AppColors.ACCENT_MEWARNAI
		"puzzle": return AppColors.ACCENT_PUZZLE
		_: return AppColors.SUNSHINE

const ParentalGateDialogScene := preload("res://core/scenes/ParentalGateDialog.tscn")


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var bg := ColorRect.new()
	bg.color = AppColors.CREAM
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.add_theme_constant_override("separation", 12)
	add_child(vbox)

	var title := Label.new()
	title.text = "Bayi GuguGaga"
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", AppColors.INK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var settings_button := Button.new()
	settings_button.text = "⚙ Pengaturan"
	settings_button.pressed.connect(_open_settings)
	vbox.add_child(settings_button)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	vbox.add_child(grid)

	for game in _GAMES:
		var button := Button.new()
		button.custom_minimum_size = Vector2(150, 150)
		button.pressed.connect(_open_game.bind(game["scene"]))

		var style := StyleBoxFlat.new()
		style.bg_color = _accent_for(game["kind"])
		style.set_corner_radius_all(16)
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style)
		button.add_theme_stylebox_override("pressed", style)
		button.add_theme_stylebox_override("focus", style)

		var tile_box := VBoxContainer.new()
		tile_box.anchor_right = 1.0
		tile_box.anchor_bottom = 1.0
		tile_box.alignment = BoxContainer.ALIGNMENT_CENTER
		tile_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(tile_box)

		var icon := ModuleIcon.new()
		icon.kind = game["kind"]
		icon.custom_minimum_size = Vector2(72, 72)
		tile_box.add_child(icon)

		var label := Label.new()
		label.text = game["name"]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color.WHITE)
		tile_box.add_child(label)

		grid.add_child(button)


func _open_game(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)


func _open_settings() -> void:
	var gate := ParentalGateDialogScene.instantiate()
	add_child(gate)
	gate.passed.connect(func():
		gate.queue_free()
		get_tree().change_scene_to_file("res://scenes/Settings.tscn")
	)
	gate.cancelled.connect(func(): gate.queue_free())

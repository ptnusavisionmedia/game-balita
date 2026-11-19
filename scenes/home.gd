extends Control
## Menu utama: 1 tombol besar per mini-game + tombol Settings.
## Tambah mini-game baru = tambah 1 baris di `_GAMES`, tidak lebih.

const _GAMES := [
	{"name": "Angka", "scene": "res://features/feature_angka/Angka.tscn"},
	{"name": "Warna", "scene": "res://features/feature_warna/Warna.tscn"},
	{"name": "Hewan", "scene": "res://features/feature_hewan/Hewan.tscn"},
	{"name": "Musik", "scene": "res://features/feature_musik/Musik.tscn"},
	{"name": "Mewarnai", "scene": "res://features/feature_mewarnai/Mewarnai.tscn"},
	{"name": "Puzzle", "scene": "res://features/feature_puzzle/Puzzle.tscn"},
]

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
		button.text = game["name"]
		button.custom_minimum_size = Vector2(150, 150)
		button.pressed.connect(_open_game.bind(game["scene"]))
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

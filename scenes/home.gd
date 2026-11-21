extends Control
## Menu utama: 1 tombol "Play" besar di tengah (mode acak infinite lewat
## `GameFlow`) + tombol sekunder "Pilih Game" (grid manual, tersembunyi
## default) + Settings. Lihat obsidian-vault/Decisions Log.md 2026-11-20
## untuk alasan desain ini (sebelumnya langsung tampilkan grid 6 tile).

const ParentalGateDialogScene := preload("res://core/scenes/ParentalGateDialog.tscn")

var _grid: GridContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	add_child(GameBackground.new())

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var title := Label.new()
	title.text = "Bayi GuguGaga"
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", AppColors.INK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var play_button := BigRoundButton.new()
	play_button.accent_color = AppColors.SUNSHINE
	play_button.custom_minimum_size = Vector2(160, 160)
	play_button.text = "▶ Play"
	play_button.pressed.connect(_on_play_pressed)
	vbox.add_child(play_button)

	var choose_button := Button.new()
	choose_button.text = "Pilih Game"
	choose_button.pressed.connect(_on_toggle_grid)
	vbox.add_child(choose_button)

	_grid = GridContainer.new()
	_grid.columns = 2
	_grid.add_theme_constant_override("h_separation", 16)
	_grid.add_theme_constant_override("v_separation", 16)
	_grid.visible = false
	vbox.add_child(_grid)

	for game in GameFlow.GAMES:
		_grid.add_child(_make_tile(game))

	var settings_button := Button.new()
	settings_button.text = "⚙"
	settings_button.custom_minimum_size = Vector2(56, 56)
	settings_button.anchor_left = 1.0
	settings_button.anchor_right = 1.0
	settings_button.offset_left = -64.0
	settings_button.offset_right = -8.0
	settings_button.offset_top = 12.0
	settings_button.offset_bottom = 68.0
	settings_button.pressed.connect(_open_settings)
	add_child(settings_button)


func _make_tile(game: Dictionary) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(120, 120)
	button.pressed.connect(_on_tile_pressed.bind(game["scene"]))

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
	icon.custom_minimum_size = Vector2(56, 56)
	tile_box.add_child(icon)

	var label := Label.new()
	label.text = game["name"]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.WHITE)
	tile_box.add_child(label)

	return button


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


func _on_play_pressed() -> void:
	GameFlow.start_random_game()


func _on_toggle_grid() -> void:
	_grid.visible = not _grid.visible


func _on_tile_pressed(scene_path: String) -> void:
	GameFlow.start_specific_game(scene_path)


func _open_settings() -> void:
	var gate := ParentalGateDialogScene.instantiate()
	add_child(gate)
	gate.passed.connect(func():
		gate.queue_free()
		GameFlow.infinite_mode = false
		GameFlow.goto_scene("res://scenes/Settings.tscn")
	)
	gate.cancelled.connect(func(): gate.queue_free())

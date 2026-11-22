extends Control
## Cocokkan warna — lihat obsidian-vault/Specs/feature_warna.md.
## 1 mekanik (self-correcting, pola sama feature_angka): tampil lingkaran
## warna acuan, pilih benda yang warnanya sama dari 3 pilihan.

const SESSION_QUESTIONS := 4
const DATA_PATH := "res://features/feature_warna/data/warna_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

var _colors: Array = []
var _targets: Array = []
var _question_index: int = 0
var _correct_count: int = 0

var _reference_circle: ColorRect
var _reference_label: Label
var _choices_box: HBoxContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	_colors = _load_color_data()
	if _colors.is_empty():
		push_warning("feature_warna: warna_data.json kosong/gagal dibaca — modul tidak bisa jalan.")
		return

	randomize()
	var pool_indices := range(_colors.size())
	pool_indices.shuffle()
	for i in range(SESSION_QUESTIONS):
		_targets.append(pool_indices[i % pool_indices.size()])

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var title := Label.new()
	title.text = "Cari Warna yang Sama"
	title.add_theme_font_size_override("font_size", 34)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_reference_circle = ColorRect.new()
	_reference_circle.custom_minimum_size = Vector2(96, 96)
	# SHRINK_CENTER — tanpa ini VBoxContainer men-stretch ke lebar penuh
	# layar (bug yang sama dilaporkan user di scenes/home.gd 2026-11-21).
	_reference_circle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(_reference_circle)

	_reference_label = Label.new()
	_reference_label.add_theme_font_size_override("font_size", 28)
	_reference_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_reference_label)

	_choices_box = HBoxContainer.new()
	_choices_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices_box.add_theme_constant_override("separation", 16)
	vbox.add_child(_choices_box)

	_render_question()
	_add_home_button()


func _load_color_data() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return parsed if parsed is Array else []


## Tombol darurat, selalu terlihat — pola wajib dari feature_angka.
func _add_home_button() -> void:
	var home_button := Button.new()
	_apply_home_icon(home_button)
	home_button.custom_minimum_size = Vector2(72, 72)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 80.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 84.0
	home_button.pressed.connect(func(): GameFlow.go_home())
	add_child(home_button)


## Ikon rumah asli (lihat docs/ASSET_LIST.md #11) — fallback emoji kalau
## file belum ada. Dipakai 6 modul feature_* (duplikasi disengaja, pola
## sama `_add_home_button`, lihat komentarnya).
func _apply_home_icon(button: Button) -> void:
	var path := "res://core/assets/images/ui/home.png"
	if FileAccess.file_exists(path):
		button.icon = load(path)
		button.expand_icon = true
	else:
		button.text = "🏠"


func _current_target() -> Dictionary:
	return _colors[_targets[_question_index]]


func _choice_indices_for(target_index: int) -> Array:
	var choices: Array = [target_index]
	var attempts := 0
	while choices.size() < mini(3, _colors.size()) and attempts < 20:
		var candidate := randi() % _colors.size()
		if not choices.has(candidate):
			choices.append(candidate)
		attempts += 1
	choices.shuffle()
	return choices


func _render_question() -> void:
	var target: Dictionary = _current_target()
	_reference_circle.color = Color(target.get("color_hex", "#FFFFFF"))
	_reference_label.text = target.get("name", "?")

	for child in _choices_box.get_children():
		child.queue_free()

	for idx in _choice_indices_for(_targets[_question_index]):
		var color_data: Dictionary = _colors[idx]
		var button := BigRoundButton.new()
		button.accent_color = Color(color_data.get("color_hex", "#FFFFFF"))
		var image_path: String = color_data.get("image", "")
		if image_path != "" and FileAccess.file_exists(image_path):
			button.icon = load(image_path)
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 84)
		else:
			# Placeholder visual: emoji, sampai ilustrasi asli ada.
			button.text = color_data.get("placeholder_emoji", "?")
		button.pressed.connect(_on_choice_pressed.bind(idx))
		_choices_box.add_child(button)


func _on_choice_pressed(chosen_index: int) -> void:
	if chosen_index == _targets[_question_index]:
		SfxService.play(load("res://core/assets/audio/sfx_correct.wav"))
		_correct_count += 1
		if _question_index + 1 >= _targets.size():
			_show_reward()
		else:
			_question_index += 1
			_render_question()
	else:
		SfxService.play(load("res://core/assets/audio/sfx_try_again.wav"))


func _show_reward() -> void:
	var overlay := StarRewardOverlayScene.instantiate()
	overlay.stars_earned = _correct_count
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_warna", _correct_count)
		GameFlow.finish_game_session()
	)

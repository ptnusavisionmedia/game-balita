extends Control
## Mini-game berhitung: tampilkan N objek (1-5), anak pilih angka yang
## sesuai. Modul ini jadi contoh pola untuk 5 modul `feature_*` lain —
## lihat obsidian-vault/Specs/feature_angka.md.

const QUESTIONS_PER_SESSION := 4
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

var _targets: Array[int] = []
var _question_index: int = 0
var _correct_count: int = 0

var _hearts_box: HBoxContainer
var _choices_box: HBoxContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	randomize()
	for i in range(QUESTIONS_PER_SESSION):
		_targets.append(randi_range(1, 5))

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var title := Label.new()
	title.text = "Berhitung"
	title.add_theme_font_size_override("font_size", 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_hearts_box = HBoxContainer.new()
	_hearts_box.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(_hearts_box)

	_choices_box = HBoxContainer.new()
	_choices_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices_box.add_theme_constant_override("separation", 16)
	vbox.add_child(_choices_box)

	_render_question()
	_add_home_button()


## Tombol darurat, selalu terlihat — supaya mode "Play acak infinite" (lihat
## GameFlow) tidak "menjebak" anak/orang tua harus main terus tanpa jalan
## keluar. Pola ini wajib ditiru di 5 modul feature_* lain begitu dikerjakan.
func _add_home_button() -> void:
	var home_button := Button.new()
	home_button.text = "🏠"
	home_button.custom_minimum_size = Vector2(56, 56)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 64.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 68.0
	home_button.pressed.connect(func(): GameFlow.go_home())
	add_child(home_button)


func _current_target() -> int:
	return _targets[_question_index]


func _choices_for(target: int) -> Array[int]:
	var choices: Array[int] = [target]
	while choices.size() < 3:
		var candidate: int = clampi(target + randi_range(-2, 2), 1, 5)
		if not choices.has(candidate):
			choices.append(candidate)
	choices.shuffle()
	return choices


func _render_question() -> void:
	for child in _hearts_box.get_children():
		child.queue_free()
	for child in _choices_box.get_children():
		child.queue_free()

	var target := _current_target()
	for i in range(target):
		var heart := Label.new()
		heart.text = "♥"
		heart.add_theme_font_size_override("font_size", 40)
		heart.add_theme_color_override("font_color", AppColors.CORAL)
		_hearts_box.add_child(heart)

	for choice in _choices_for(target):
		var button := BigRoundButton.new()
		button.accent_color = AppColors.ACCENT_ANGKA
		button.text = str(choice)
		button.pressed.connect(_on_choice_pressed.bind(choice))
		_choices_box.add_child(button)


func _on_choice_pressed(choice: int) -> void:
	if choice == _current_target():
		# TODO Asset 2: isi dengan AudioStream SFX "benar" begitu file-nya ada.
		SfxService.play(null)
		_correct_count += 1
		if _question_index + 1 >= _targets.size():
			_show_reward()
		else:
			_question_index += 1
			_render_question()
	else:
		# TODO Asset 2: isi dengan AudioStream SFX "coba lagi" begitu file-nya ada.
		SfxService.play(null)


func _show_reward() -> void:
	var stars := roundi(float(_correct_count) * 3.0 / float(_targets.size()))
	var overlay := StarRewardOverlayScene.instantiate()
	overlay.stars_earned = stars
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_angka", stars)
		# GameFlow.finish_game_session() — bukan langsung ke Home — supaya
		# mode "Play acak infinite" lempar ke mini-game lain, bukan mampir Home.
		GameFlow.finish_game_session()
	)

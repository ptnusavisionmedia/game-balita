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
		get_tree().change_scene_to_file("res://scenes/Home.tscn")
	)

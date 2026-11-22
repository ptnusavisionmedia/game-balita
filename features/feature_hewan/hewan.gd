extends Control
## Tebak hewan dari suara — 2 mekanik, lihat obsidian-vault/Specs/feature_hewan.md.
## Fork ditentukan dari JALUR MASUK, bukan pertanyaan baru ke anak:
## - `GameFlow.guided_mode == false` (lewat Home seperti biasa) → Mandiri:
##   dengar suara, pilih gambar yang benar dari 3 pilihan (pola feature_angka).
## - `GameFlow.guided_mode == true` (lewat "Mulai main bareng" di ParentGuide,
##   belum ada scene-nya — Fase B docs/PLAN_TUMBUH_KEMBANG.md) → Bareng Orang
##   Tua: gambar disamarkan, orang tua putar suara & buka jawaban manual,
##   TIDAK ADA tanda benar/salah (ini bukan kuis).

const SESSION_ROUNDS := 4
const DATA_PATH := "res://features/feature_hewan/data/hewan_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

var _animals: Array = []

# Mandiri
var _targets: Array = []
var _question_index: int = 0
var _correct_count: int = 0
var _hearts_label: Label
var _choices_box: HBoxContainer

# Bareng Orang Tua
var _shown_count: int = 0
var _guided_order: Array = []
var _guided_index: int = 0
var _revealed: bool = false
var _reveal_icon: Label
var _reveal_image: TextureRect
var _reveal_name: Label
var _hint_label: Label


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	_animals = _load_animal_data()
	if _animals.is_empty():
		push_warning("feature_hewan: hewan_data.json kosong/gagal dibaca — modul tidak bisa jalan.")
		return

	if GameFlow.guided_mode:
		_setup_guided()
	else:
		_setup_mandiri()

	_add_home_button()


func _load_animal_data() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var text := FileAccess.get_file_as_string(DATA_PATH)
	var parsed = JSON.parse_string(text)
	return parsed if parsed is Array else []


## Tombol darurat, selalu terlihat — supaya mode "Play acak infinite" (lihat
## GameFlow) tidak "menjebak" anak/orang tua harus main terus tanpa jalan
## keluar. Pola wajib dari feature_angka, diikuti di sini juga.
func _add_home_button() -> void:
	var home_button := Button.new()
	_apply_home_icon(home_button)
	home_button.custom_minimum_size = Vector2(56, 56)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 64.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 68.0
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


# ---------------------------------------------------------------------------
# Mekanik Mandiri (self-correcting, pola sama feature_angka)
# ---------------------------------------------------------------------------

func _setup_mandiri() -> void:
	randomize()
	var pool_indices := range(_animals.size())
	pool_indices.shuffle()
	for i in range(SESSION_ROUNDS):
		_targets.append(pool_indices[i % pool_indices.size()])

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var title := Label.new()
	title.text = "Suara Siapa Ini?"
	title.add_theme_font_size_override("font_size", 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var play_sound_button := Button.new()
	play_sound_button.text = "🔊 Dengar Suaranya"
	play_sound_button.custom_minimum_size = Vector2(0, 64)
	play_sound_button.pressed.connect(_play_current_target_sound)
	vbox.add_child(play_sound_button)

	_choices_box = HBoxContainer.new()
	_choices_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices_box.add_theme_constant_override("separation", 16)
	vbox.add_child(_choices_box)

	_render_mandiri_question()


func _current_target() -> Dictionary:
	return _animals[_targets[_question_index]]


func _play_current_target_sound() -> void:
	SfxService.play(_load_sfx(_current_target().get("sfx", "")))


## Suara hewan (draf sintetis, lihat docs/ASSET_LIST.md) sengaja dimuat
## lewat `load()` langsung (bukan preload) karena path-nya datang dari
## JSON data, bukan konstanta yang diketahui saat compile.
func _load_sfx(path: String) -> AudioStream:
	if path == "" or not FileAccess.file_exists(path):
		return null
	return load(path)


func _choice_indices_for(target_index: int) -> Array:
	var choices: Array = [target_index]
	var attempts := 0
	while choices.size() < mini(3, _animals.size()) and attempts < 20:
		var candidate := randi() % _animals.size()
		if not choices.has(candidate):
			choices.append(candidate)
		attempts += 1
	choices.shuffle()
	return choices


func _render_mandiri_question() -> void:
	for child in _choices_box.get_children():
		child.queue_free()

	_play_current_target_sound()

	for idx in _choice_indices_for(_targets[_question_index]):
		var animal: Dictionary = _animals[idx]
		var button := BigRoundButton.new()
		button.accent_color = AppColors.ACCENT_HEWAN
		_apply_animal_icon(button, animal)
		button.pressed.connect(_on_choice_pressed.bind(idx))
		_choices_box.add_child(button)


## Pasang ilustrasi asli dari paket aset (fallback ke emoji kalau file
## belum ada) — `Button.icon` bawaan Godot, bukan `BigRoundButton` baru.
func _apply_animal_icon(button: Button, animal: Dictionary) -> void:
	var image_path: String = animal.get("image", "")
	if image_path != "" and FileAccess.file_exists(image_path):
		button.icon = load(image_path)
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.add_theme_constant_override("icon_max_width", 72)
		button.text = animal.get("name", "?")
	else:
		button.text = "%s\n%s" % [animal.get("placeholder_emoji", "?"), animal.get("name", "?")]


func _on_choice_pressed(chosen_index: int) -> void:
	if chosen_index == _targets[_question_index]:
		SfxService.play(load("res://core/assets/audio/sfx_correct.wav"))
		_correct_count += 1
		if _question_index + 1 >= _targets.size():
			_show_reward(_correct_count)
		else:
			_question_index += 1
			_render_mandiri_question()
	else:
		SfxService.play(load("res://core/assets/audio/sfx_try_again.wav"))


# ---------------------------------------------------------------------------
# Mekanik Bareng Orang Tua (eksplorasi, TANPA benar/salah)
# ---------------------------------------------------------------------------

func _setup_guided() -> void:
	randomize()
	_guided_order = range(_animals.size())
	_guided_order.shuffle()

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var title := Label.new()
	title.text = "Tebak Suara Hewan"
	title.add_theme_font_size_override("font_size", 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_hint_label = Label.new()
	_hint_label.text = "Coba tanya: \"ini suaranya siapa?\" sebelum buka jawabannya."
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_color_override("font_color", AppColors.INK)
	_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_hint_label.custom_minimum_size = Vector2(360, 0)
	vbox.add_child(_hint_label)

	_reveal_icon = Label.new()
	_reveal_icon.add_theme_font_size_override("font_size", 72)
	_reveal_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_reveal_icon)

	_reveal_image = TextureRect.new()
	_reveal_image.custom_minimum_size = Vector2(160, 160)
	_reveal_image.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_reveal_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_reveal_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_reveal_image.visible = false
	vbox.add_child(_reveal_image)

	_reveal_name = Label.new()
	_reveal_name.add_theme_font_size_override("font_size", 24)
	_reveal_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_reveal_name)

	var button_row := HBoxContainer.new()
	button_row.alignment = BoxContainer.ALIGNMENT_CENTER
	button_row.add_theme_constant_override("separation", 16)
	vbox.add_child(button_row)

	var play_sound_button := Button.new()
	play_sound_button.text = "🔊 Dengar Suaranya"
	play_sound_button.custom_minimum_size = Vector2(0, 64)
	play_sound_button.pressed.connect(func():
		var animal: Dictionary = _animals[_guided_order[_guided_index]]
		SfxService.play(_load_sfx(animal.get("sfx", "")))
	)
	button_row.add_child(play_sound_button)

	var reveal_button := Button.new()
	var reveal_icon_path := "res://core/assets/images/ui/reveal.png"
	if FileAccess.file_exists(reveal_icon_path):
		reveal_button.icon = load(reveal_icon_path)
		reveal_button.text = "Lihat Jawaban"
	else:
		reveal_button.text = "🔍 Lihat Jawaban"
	reveal_button.custom_minimum_size = Vector2(0, 64)
	reveal_button.pressed.connect(_on_reveal_pressed)
	button_row.add_child(reveal_button)

	var next_button := Button.new()
	next_button.text = "Hewan Lain →"
	next_button.custom_minimum_size = Vector2(0, 64)
	next_button.pressed.connect(_on_next_animal_pressed)
	vbox.add_child(next_button)

	_shown_count = 1
	_render_guided_current(false)


func _render_guided_current(revealed: bool) -> void:
	_revealed = revealed
	if revealed:
		var animal: Dictionary = _animals[_guided_order[_guided_index]]
		var image_path: String = animal.get("image", "")
		if image_path != "" and FileAccess.file_exists(image_path):
			_reveal_image.texture = load(image_path)
			_reveal_image.visible = true
			_reveal_icon.visible = false
		else:
			_reveal_icon.text = animal.get("placeholder_emoji", "?")
			_reveal_icon.visible = true
			_reveal_image.visible = false
		_reveal_name.text = animal.get("name", "?")
	else:
		# Disamarkan — silhouette "?" sampai tap "Lihat Jawaban".
		_reveal_image.visible = false
		_reveal_icon.visible = true
		_reveal_icon.text = "？"
		_reveal_name.text = ""
	# Petunjuk cuma muncul di hewan pertama, supaya tidak mengganggu
	# giliran berikutnya (lihat obsidian-vault/Specs/feature_hewan.md).
	_hint_label.visible = (_shown_count == 1)


func _on_reveal_pressed() -> void:
	# TIDAK ADA skor/tanda benar-salah di sini — cuma menampilkan jawaban,
	# bukan menilai tebakan anak (lihat prinsip #4 docs/UI_UX_DESIGN.md).
	var animal: Dictionary = _animals[_guided_order[_guided_index]]
	SfxService.play(_load_sfx(animal.get("sfx", "")))
	_render_guided_current(true)


func _on_next_animal_pressed() -> void:
	if _shown_count >= SESSION_ROUNDS:
		_show_reward(SESSION_ROUNDS)
		return
	_guided_index += 1
	if _guided_index >= _guided_order.size():
		_guided_order.shuffle()
		_guided_index = 0
	_shown_count += 1
	_render_guided_current(false)


# ---------------------------------------------------------------------------
# Reward — sama untuk kedua mekanik
# ---------------------------------------------------------------------------

func _show_reward(stars: int) -> void:
	var overlay := StarRewardOverlayScene.instantiate()
	overlay.stars_earned = stars
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_hewan", stars)
		GameFlow.finish_game_session()
	)

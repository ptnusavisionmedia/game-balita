extends Control
## Satu-satunya layar untuk orang tua: toggle suara. Diakses lewat
## ParentalGateDialog dulu — lihat home.gd.

var _sound_button: Button


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.add_theme_constant_override("separation", 16)
	add_child(vbox)

	var title := Label.new()
	title.text = "Pengaturan"
	title.add_theme_font_size_override("font_size", 34)
	vbox.add_child(title)

	_sound_button = Button.new()
	_sound_button.custom_minimum_size = Vector2(0, 72)
	_sound_button.toggle_mode = true
	_sound_button.button_pressed = ProgressRepository.sound_enabled
	_render_sound_button()
	_sound_button.toggled.connect(_on_sound_toggled)
	vbox.add_child(_sound_button)

	var parent_guide_button := Button.new()
	parent_guide_button.text = "Panduan Orang Tua"
	parent_guide_button.custom_minimum_size = Vector2(0, 72)
	parent_guide_button.pressed.connect(func(): GameFlow.goto_scene("res://scenes/ParentGuide.tscn"))
	vbox.add_child(parent_guide_button)

	var back_button := Button.new()
	back_button.text = "Kembali"
	back_button.custom_minimum_size = Vector2(0, 72)
	back_button.pressed.connect(func(): GameFlow.go_home())
	vbox.add_child(back_button)


func _on_sound_toggled(value: bool) -> void:
	ProgressRepository.set_sound_enabled(value)
	SfxService.muted = not value
	AudioService.muted = not value
	_render_sound_button()


## Ikon speaker on/off asli (lihat docs/ASSET_LIST.md #11) — fallback teks
## kalau file belum ada.
func _render_sound_button() -> void:
	var on_path := "res://core/assets/images/ui/speaker_on.png"
	var off_path := "res://core/assets/images/ui/speaker_off.png"
	var path := on_path if _sound_button.button_pressed else off_path
	if FileAccess.file_exists(path):
		_sound_button.icon = load(path)
		# Fix bug 2026-11-22 (dilaporkan user, screenshot): tanpa
		# `expand_icon` + `icon_max_width`, `Button.icon` digambar di
		# UKURAN ASLI FILE (bisa 512-1024px), bukan di-scale ke ukuran
		# tombol — bikin ikon raksasa nutupin seluruh layar Settings. Pola
		# yang sama juga WAJIB dipakai di setiap `Button.icon` lain.
		_sound_button.expand_icon = true
		_sound_button.add_theme_constant_override("icon_max_width", 64)
		_sound_button.text = "Suara"
	else:
		_sound_button.text = "🔊 Suara" if _sound_button.button_pressed else "🔇 Suara"

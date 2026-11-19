extends Control
## Satu-satunya layar untuk orang tua: toggle suara. Diakses lewat
## ParentalGateDialog dulu — lihat home.gd.

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
	title.add_theme_font_size_override("font_size", 28)
	vbox.add_child(title)

	var sound_check := CheckBox.new()
	sound_check.text = "Suara"
	sound_check.button_pressed = ProgressRepository.sound_enabled
	sound_check.toggled.connect(_on_sound_toggled)
	vbox.add_child(sound_check)

	var back_button := Button.new()
	back_button.text = "Kembali"
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Home.tscn"))
	vbox.add_child(back_button)


func _on_sound_toggled(value: bool) -> void:
	ProgressRepository.set_sound_enabled(value)
	SfxService.muted = not value
	AudioService.muted = not value

extends Control
## Placeholder mini-game musik — lihat obsidian-vault/Specs/feature_musik.md.
## Belum coding fitur (base model fokus feature_angka dulu sebagai pilot).

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(vbox)

	var label := Label.new()
	label.text = "Musik\n(belum dikerjakan)"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

	var back_button := Button.new()
	back_button.text = "Kembali"
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Home.tscn"))
	vbox.add_child(back_button)

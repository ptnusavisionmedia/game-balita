extends Control
class_name StarRewardOverlay
## Overlay perayaan di akhir sesi mini-game: confetti + jumlah bintang.
## Dipakai sama oleh semua `feature_*` supaya rasa keberhasilannya konsisten.
## Bukan framing "menang/kalah" — tombol "Lanjut" cuma pindah ke mini-game
## lain (lihat prinsip #4 docs/UI_UX_DESIGN.md).
##
## Confetti pakai `CPUParticles2D` bawaan Godot (particle system teruji),
## bukan animasi partikel buatan sendiri — lihat docs/LIBRARIES.md.

signal continued

@export var stars_earned: int = 0
@export var max_stars: int = 3


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.4)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	add_child(backdrop)

	if stars_earned > 0:
		_spawn_confetti()

	var card := PanelContainer.new()
	card.anchor_left = 0.5
	card.anchor_top = 0.5
	card.anchor_right = 0.5
	card.anchor_bottom = 0.5
	add_child(card)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	card.add_child(vbox)

	var stars_row := HBoxContainer.new()
	stars_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(stars_row)
	for i in range(max_stars):
		var star := Label.new()
		star.text = "★" if i < stars_earned else "☆"
		star.add_theme_font_size_override("font_size", 48)
		star.add_theme_color_override("font_color", AppColors.GOLD)
		stars_row.add_child(star)

	var continue_button := Button.new()
	continue_button.text = "Lanjut"
	continue_button.custom_minimum_size = Vector2(120, 64)
	continue_button.pressed.connect(func(): continued.emit())
	vbox.add_child(continue_button)


func _spawn_confetti() -> void:
	var confetti := CPUParticles2D.new()
	add_child(confetti)
	confetti.position = Vector2(get_viewport_rect().size.x / 2.0, 0)
	confetti.amount = 60
	confetti.lifetime = 2.0
	confetti.one_shot = true
	confetti.explosiveness = 0.8
	confetti.direction = Vector2(0, 1)
	confetti.spread = 180
	confetti.gravity = Vector2(0, 300)
	confetti.initial_velocity_min = 100
	confetti.initial_velocity_max = 300
	confetti.color = AppColors.GOLD
	confetti.emitting = true

extends Control
class_name ParentalGateDialog
## Gate sederhana sebelum masuk Settings: tahan tombol 3 detik. Anak kecil
## biasanya tidak sabar menahan 3 detik penuh, orang tua bisa.
## Lihat docs/UI_UX_DESIGN.md.

signal passed
signal cancelled

const HOLD_SECONDS := 3.0

var _held_time: float = 0.0
var _holding: bool = false
var _progress: ProgressBar


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.5)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	add_child(backdrop)

	var card := PanelContainer.new()
	card.anchor_left = 0.5
	card.anchor_top = 0.5
	card.anchor_right = 0.5
	card.anchor_bottom = 0.5
	add_child(card)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	card.add_child(vbox)

	var label := Label.new()
	label.text = "Mode Orang Tua\nTahan tombol di bawah selama 3 detik"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

	_progress = ProgressBar.new()
	_progress.min_value = 0
	_progress.max_value = HOLD_SECONDS
	_progress.value = 0
	_progress.custom_minimum_size = Vector2(160, 24)
	vbox.add_child(_progress)

	var hold_button := Button.new()
	hold_button.text = "Tahan Di Sini"
	hold_button.custom_minimum_size = Vector2(160, 64)
	hold_button.button_down.connect(_start_hold)
	hold_button.button_up.connect(_stop_hold)
	vbox.add_child(hold_button)

	var cancel_button := Button.new()
	cancel_button.text = "Batal"
	cancel_button.pressed.connect(func(): cancelled.emit())
	vbox.add_child(cancel_button)


func _start_hold() -> void:
	_holding = true
	_held_time = 0.0


func _stop_hold() -> void:
	_holding = false
	_held_time = 0.0
	if _progress:
		_progress.value = 0


func _process(delta: float) -> void:
	if _holding:
		_held_time += delta
		_progress.value = _held_time
		if _held_time >= HOLD_SECONDS:
			_holding = false
			passed.emit()

extends Control
class_name ParentalGateDialog
## Gate sebelum masuk Settings: soal tambah sederhana ("4 + 5 = ?"), orang
## tua ketik jawabannya lewat keypad angka di layar. Anak kecil belum bisa
## hitung, orang tua bisa — pola umum di app anak. Lihat docs/UI_UX_DESIGN.md.
##
## Sebelumnya pakai "tahan tombol 3 detik" — diganti total jadi soal tambah
## atas permintaan user (2026-11-20), lihat obsidian-vault/Decisions Log.md.

signal passed
signal cancelled

const MAX_ANSWER_DIGITS := 2

var _a: int
var _b: int
var _answer_text: String = ""

var _question_label: Label
var _answer_label: Label


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	randomize()
	_new_question()

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
	vbox.add_theme_constant_override("separation", 12)
	card.add_child(vbox)

	var title := Label.new()
	title.text = "Mode Orang Tua"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_question_label = Label.new()
	_question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_question_label.add_theme_font_size_override("font_size", 28)
	vbox.add_child(_question_label)

	_answer_label = Label.new()
	_answer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_answer_label.add_theme_font_size_override("font_size", 24)
	_answer_label.add_theme_color_override("font_color", AppColors.ACCENT_ANGKA)
	_answer_label.custom_minimum_size = Vector2(0, 36)
	vbox.add_child(_answer_label)

	var keypad := GridContainer.new()
	keypad.columns = 3
	keypad.add_theme_constant_override("h_separation", 8)
	keypad.add_theme_constant_override("v_separation", 8)
	vbox.add_child(keypad)

	for i in range(1, 10):
		keypad.add_child(_make_digit_button(i))
	keypad.add_child(_make_backspace_button())
	keypad.add_child(_make_digit_button(0))
	keypad.add_child(_make_confirm_button())

	var cancel_button := Button.new()
	cancel_button.text = "Batal"
	cancel_button.pressed.connect(func(): cancelled.emit())
	vbox.add_child(cancel_button)

	_update_display()


func _new_question() -> void:
	_a = randi_range(2, 9)
	_b = randi_range(2, 9)
	_answer_text = ""


func _update_display() -> void:
	_question_label.text = "%d + %d = ?" % [_a, _b]
	_answer_label.text = _answer_text if _answer_text != "" else "_"


func _make_digit_button(d: int) -> Button:
	var button := Button.new()
	button.text = str(d)
	button.custom_minimum_size = Vector2(56, 56)
	button.pressed.connect(_on_digit_pressed.bind(d))
	return button


func _make_backspace_button() -> Button:
	var button := Button.new()
	button.text = "⌫"
	button.custom_minimum_size = Vector2(56, 56)
	button.pressed.connect(_on_backspace_pressed)
	return button


func _make_confirm_button() -> Button:
	var button := Button.new()
	button.text = "✓"
	button.custom_minimum_size = Vector2(56, 56)
	button.pressed.connect(_on_confirm_pressed)
	return button


func _on_digit_pressed(d: int) -> void:
	if _answer_text.length() < MAX_ANSWER_DIGITS:
		_answer_text += str(d)
	_update_display()


func _on_backspace_pressed() -> void:
	if _answer_text.length() > 0:
		_answer_text = _answer_text.substr(0, _answer_text.length() - 1)
	_update_display()


## Jawaban salah = soal baru dibuat (bukan cuma "coba lagi" soal yang sama),
## supaya tidak bisa ditembus anak lewat coba-coba asal tanpa benar-benar hitung.
func _on_confirm_pressed() -> void:
	if _answer_text == str(_a + _b):
		passed.emit()
	else:
		_new_question()
		_update_display()

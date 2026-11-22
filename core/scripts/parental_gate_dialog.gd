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

	# CenterContainer, bukan PanelContainer dianchor ke 1 titik tengah —
	# anchor titik (0.5/0.5/0.5/0.5) tanpa offset bikin rect-nya kolaps ke
	# size (0,0), jadi semua isi (soal+keypad) numpuk/ke-collapse ("ancur").
	# CenterContainer full-rect otomatis center-kan child sesuai minimum
	# size-nya, tanpa perlu hitung offset manual. Lihat Decisions Log 2026-11-20.
	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)

	var card := PanelContainer.new()
	# Fix bug 2026-11-22 (dilaporkan user, screenshot): `PanelContainer`
	# tanpa stylebox eksplisit pakai panel tema default Godot yang nyaris
	# transparan — teks/tombol Home di belakang bocor tembus, bikin
	# dialog susah dibaca. Kasih background solid + border eksplisit,
	# sama pola kartu di scenes/parent_guide.gd.
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = AppColors.CREAM
	card_style.border_color = AppColors.INK
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(20)
	card_style.set_content_margin_all(20)
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	card.add_child(vbox)

	# Update 2026-11-22: susunan judul+tutup mengikuti mockup
	# `previews/09_parental_gate.png` paket Wawa_GUI_HUD_Pack.zip — kunci
	# orang tua pindah jadi ikon kecil DI DALAM judul (bukan baris sendiri
	# di atas), ditambah tombol tutup (X) bulat di kanan, gantikan tombol
	# "Batal" di paling bawah (lebih jelas & konsisten sama pola ParentGuide).
	var header_row := HBoxContainer.new()
	vbox.add_child(header_row)

	var title_box := HBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 8)
	header_row.add_child(title_box)

	var lock_icon_path := "res://core/assets/images/ui/parental_lock.png"
	if FileAccess.file_exists(lock_icon_path):
		var lock_icon := TextureRect.new()
		lock_icon.texture = load(lock_icon_path)
		lock_icon.custom_minimum_size = Vector2(32, 32)
		# expand_mode = IGNORE_SIZE WAJIB — tanpa ini TextureRect melapor
		# "minimum size"-nya = ukuran asli file (bisa 1024x1024), bukan
		# custom_minimum_size di atas (bug sama persis GameBackground
		# 2026-11-22, dilaporkan user lagi di sini: ikon kunci jadi raksasa
		# nutupin seluruh layar).
		lock_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		lock_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		title_box.add_child(lock_icon)

	var title := Label.new()
	title.text = "Untuk Orang Tua"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", AppColors.INK)
	title_box.add_child(title)

	var close_button := Button.new()
	UIStyle.apply_icon_frame(close_button)
	var close_icon_path := "res://core/assets/images/ui/close_x.png"
	if FileAccess.file_exists(close_icon_path):
		close_button.icon = load(close_icon_path)
		close_button.expand_icon = true
		close_button.add_theme_constant_override("icon_max_width", 40)
	else:
		close_button.text = "✕"
	close_button.pressed.connect(func(): cancelled.emit())
	header_row.add_child(close_button)

	_question_label = Label.new()
	_question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_question_label.add_theme_font_size_override("font_size", 34)
	_question_label.add_theme_color_override("font_color", AppColors.INK)
	vbox.add_child(_question_label)

	_answer_label = Label.new()
	_answer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_answer_label.add_theme_font_size_override("font_size", 30)
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

	_update_display()


func _new_question() -> void:
	_a = randi_range(2, 9)
	_b = randi_range(2, 9)
	_answer_text = ""


func _update_display() -> void:
	_question_label.text = "%d + %d = ?" % [_a, _b]
	_answer_label.text = _answer_text if _answer_text != "" else "_"


## Update 2026-11-22: keypad pakai bingkai bulat `UIStyle.apply_icon_frame`
## (token `icon.s` 88x88, lihat mockup `previews/09_parental_gate.png`) +
## font digit dibesarkan ke 40px (token "Digit keypad" di
## docs/STYLE_GUIDE_GUI_HUD.md / GUI_HUD_SPEC paket).
func _make_digit_button(d: int) -> Button:
	var button := Button.new()
	UIStyle.apply_icon_frame(button)
	UIStyle.apply_ink_text_color(button)
	button.text = str(d)
	button.add_theme_font_size_override("font_size", 40)
	button.pressed.connect(_on_digit_pressed.bind(d))
	return button


func _make_backspace_button() -> Button:
	var button := Button.new()
	UIStyle.apply_icon_frame(button)
	UIStyle.apply_ink_text_color(button)
	button.text = "Hapus"
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(_on_backspace_pressed)
	return button


func _make_confirm_button() -> Button:
	var button := Button.new()
	UIStyle.apply_icon_frame(button)
	var checkmark_path := "res://core/assets/images/ui/checkmark.png"
	if FileAccess.file_exists(checkmark_path):
		button.icon = load(checkmark_path)
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 40)
	else:
		button.text = "✓"
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

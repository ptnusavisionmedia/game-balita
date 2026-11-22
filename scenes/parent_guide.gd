extends Control
## "Panduan Orang Tua" — daftar kartu per modul, akses dari Settings
## (sudah di belakang ParentalGateDialog). Isi: kalimat scaffolding
## (Vygotsky) buat diucapkan orang tua sambil main, BUKAN panduan buat
## menilai performa anak. Lihat docs/PLAN_TUMBUH_KEMBANG.md.
##
## Untuk modul yang punya mekanik "Bareng Orang Tua" sendiri (sekarang
## cuma feature_hewan, lihat obsidian-vault/Specs/feature_hewan.md), kartu
## detailnya dapat tombol "Mulai main bareng" → GameFlow.start_guided_game().

const DATA_PATH := "res://core/data/parent_guide.json"

var _cards: Array = []
var _content: VBoxContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	_cards = _load_cards()

	var bg := ColorRect.new()
	bg.color = AppColors.CREAM
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)

	# CenterContainer + ScrollContainer (bukan anchor 1-titik tanpa offset)
	# supaya tidak kolaps ke size (0,0) & tetap scroll-safe kalau konten
	# lebih tinggi dari layar — lihat bug ParentalGateDialog, Decisions
	# Log 2026-11-20.
	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)

	var panel := PanelContainer.new()
	center.add_child(panel)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(620, 560)
	panel.add_child(scroll)

	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 14)
	scroll.add_child(_content)

	_render_list()


func _load_cards() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return parsed if parsed is Array else []


func _clear_content() -> void:
	for child in _content.get_children():
		child.queue_free()


func _add_wrapped_label(text: String, font_size: int = 20) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.custom_minimum_size = Vector2(520, 0)
	label.add_theme_font_size_override("font_size", font_size)
	_content.add_child(label)


func _render_list() -> void:
	_clear_content()

	var title := Label.new()
	title.text = "Panduan Orang Tua"
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content.add_child(title)

	_add_wrapped_label("Di app ini sengaja tidak ada bintang/skor atau \"menang-kalah\" — usia 1-5 tahun masih membangun rasa percaya diri, bukan dinilai dulu. Kartu di bawah ide ngobrol & bantu sambil main, bukan cara menilai anak.")

	for card in _cards:
		var button := Button.new()
		button.text = str(card.get("title", "?"))
		button.custom_minimum_size = Vector2(0, 72)
		var icon_path := "res://core/assets/images/parent_guide/panduan_%s.png" % str(card.get("kind", ""))
		if FileAccess.file_exists(icon_path):
			button.icon = load(icon_path)
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 48)
		button.pressed.connect(_render_detail.bind(card))
		_content.add_child(button)

	_add_wrapped_label("Catatan: tiap anak berkembang dengan laju berbeda. Kalau ada kekhawatiran, konsultasikan ke dokter anak.", 16)

	var back_button := Button.new()
	back_button.text = "← Kembali ke Pengaturan"
	back_button.custom_minimum_size = Vector2(0, 72)
	back_button.pressed.connect(func(): GameFlow.goto_scene("res://scenes/Settings.tscn"))
	_content.add_child(back_button)


func _render_detail(card: Dictionary) -> void:
	_clear_content()

	var title := Label.new()
	title.text = str(card.get("title", "?"))
	title.add_theme_font_size_override("font_size", 30)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_content.add_child(title)

	_add_wrapped_label("Lagi belajar apa?\n" + str(card.get("what_learning", "")))

	var phrases: Array = card.get("scaffolding_phrases", [])
	var phrases_text := "Coba ucapkan ini sambil main:"
	for phrase in phrases:
		phrases_text += "\n• %s" % phrase
	_add_wrapped_label(phrases_text)

	_add_wrapped_label("Lanjutan di luar app:\n" + str(card.get("offline_activity", "")))

	var guided_scene: String = str(card.get("guided_scene", ""))
	if guided_scene != "":
		var guided_button := Button.new()
		guided_button.text = "▶ Mulai main bareng"
		guided_button.custom_minimum_size = Vector2(0, 72)
		guided_button.pressed.connect(func(): GameFlow.start_guided_game(guided_scene))
		_content.add_child(guided_button)

	var back_button := Button.new()
	back_button.text = "← Kembali ke daftar"
	back_button.custom_minimum_size = Vector2(0, 72)
	back_button.pressed.connect(_render_list)
	_content.add_child(back_button)

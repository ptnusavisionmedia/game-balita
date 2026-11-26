extends Control
## Satu-satunya layar untuk orang tua: toggle suara + akses Panduan Orang
## Tua. Diakses lewat ParentalGateDialog dulu — lihat home.gd.
##
## Update 2026-11-22: redesain mengikuti mockup `previews/10_pengaturan.png`
## paket Wawa_GUI_HUD_Pack.zip — 1 kartu krem opak berisi baris per
## pengaturan (label + subjudul + tombol pil di kanan), bukan daftar
## tombol polos ditumpuk seperti sebelumnya.

var _sound_button: Button


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	var back_button := Button.new()
	UIStyle.apply_icon_frame(back_button)
	var back_icon_path := "res://core/assets/images/ui/back_arrow.png"
	if FileAccess.file_exists(back_icon_path):
		back_button.icon = load(back_icon_path)
		back_button.expand_icon = true
		back_button.add_theme_constant_override("icon_max_width", 48)
	else:
		back_button.text = "←"
	back_button.anchor_left = 0.0
	back_button.anchor_right = 0.0
	back_button.offset_left = 8.0
	back_button.offset_right = 96.0
	back_button.offset_top = 12.0
	back_button.offset_bottom = 100.0
	back_button.pressed.connect(func(): GameFlow.go_home())
	add_child(back_button)

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	# Bug class sama persis GameModes (lihat scenes/game_modes.gd,
	# Decisions Log 2026-11-26): `vbox` full-rect di-add SETELAH
	# `back_button`, default `mouse_filter = STOP` bikin area kosongnya
	# "menelan" klik di pojok kiri atas sebelum sempat jatuh ke
	# back_button di baliknya.
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vbox)

	var title := Label.new()
	title.text = "Pengaturan"
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", AppColors.INK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = AppColors.CREAM
	card_style.border_color = AppColors.SUNSHINE
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(24)
	card_style.set_content_margin_all(36)
	card.add_theme_stylebox_override("panel", card_style)
	vbox.add_child(card)

	var card_box := VBoxContainer.new()
	card_box.custom_minimum_size = Vector2(840, 0)
	card_box.add_theme_constant_override("separation", 24)
	card.add_child(card_box)

	_sound_button = Button.new()
	_sound_button.toggle_mode = true
	_sound_button.button_pressed = ProgressRepository.sound_enabled
	_sound_button.toggled.connect(_on_sound_toggled)
	card_box.add_child(_make_setting_row(
		"Suara", "Musik dan bunyi permainan", _sound_button
	))
	_render_sound_button()

	var divider := HSeparator.new()
	card_box.add_child(divider)

	var parent_guide_button := Button.new()
	parent_guide_button.text = "Buka Panduan"
	var info_path := "res://core/assets/images/ui/info.png"
	if FileAccess.file_exists(info_path):
		parent_guide_button.icon = load(info_path)
		parent_guide_button.expand_icon = true
		parent_guide_button.add_theme_constant_override("icon_max_width", 36)
	parent_guide_button.pressed.connect(func(): GameFlow.goto_scene("res://scenes/ParentGuide.tscn"))
	UIStyle.apply_pill_action(parent_guide_button)
	card_box.add_child(_make_setting_row(
		"Panduan Orang Tua", "Ide untuk bermain bersama", parent_guide_button
	))


## 1 baris pengaturan: label bold + subjudul kecil di kiri, 1 tombol
## aksi (pil) di kanan — pola dari mockup, dipakai ulang buat baris
## "Suara" dan "Panduan Orang Tua" supaya konsisten.
func _make_setting_row(label_text: String, subtitle_text: String, action_button: Button) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 4)
	row.add_child(text_box)

	var label := Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_color_override("font_color", AppColors.INK)
	text_box.add_child(label)

	var subtitle := Label.new()
	subtitle.text = subtitle_text
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.add_theme_color_override("font_color", AppColors.INK)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_box.add_child(subtitle)

	action_button.add_theme_font_size_override("font_size", 24)
	row.add_child(action_button)
	return row


func _on_sound_toggled(value: bool) -> void:
	ProgressRepository.set_sound_enabled(value)
	SfxService.muted = not value
	AudioService.muted = not value
	_render_sound_button()


## Ikon speaker on/off asli (lihat docs/ASSET_LIST.md #11) — fallback teks
## kalau file belum ada. Teks tombol juga tampilkan status ("Aktif"/
## "Nonaktif") mengikuti mockup, bukan cuma label "Suara" statis.
func _render_sound_button() -> void:
	var on_path := "res://core/assets/images/ui/speaker_on.png"
	var off_path := "res://core/assets/images/ui/speaker_off.png"
	var is_on := _sound_button.button_pressed
	var path := on_path if is_on else off_path
	if FileAccess.file_exists(path):
		_sound_button.icon = load(path)
		_sound_button.expand_icon = true
		_sound_button.add_theme_constant_override("icon_max_width", 36)
	_sound_button.text = "Aktif" if is_on else "Nonaktif"
	UIStyle.apply_pill_action(_sound_button, is_on)

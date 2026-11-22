extends Control
## Menu utama: 1 tombol "Play" besar di tengah (mode acak infinite lewat
## `GameFlow`) + tombol sekunder "Pilih Game" (grid manual, tersembunyi
## default) + Settings. Lihat obsidian-vault/Decisions Log.md 2026-11-20
## untuk alasan desain ini (sebelumnya langsung tampilkan grid 6 tile).

const ParentalGateDialogScene := preload("res://core/scenes/ParentalGateDialog.tscn")

var _grid: GridContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	add_child(GameBackground.new())

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var title := Label.new()
	title.text = "Wawa"
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", AppColors.INK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# size_flags_horizontal = SHRINK_CENTER — tanpa ini, VBoxContainer
	# men-stretch tiap child ke lebar penuh layar (dilaporkan user
	# 2026-11-21, baru kelihatan jelas setelah GameBackground dipasang).
	#
	# Update 2026-11-22 (redesain ke-2, atas permintaan user): "Play"
	# BUKAN pil bertuliskan "▶ Play" lagi — jadi LINGKARAN besar isinya
	# cuma tanda "▶" tanpa teks sama sekali (ikon = aksi, sesuai prinsip
	# anak belum baca). Pakai `StyleBoxFlat` solid (bukan gambar pil
	# `button_primary.png` yang sekarang nganggur di repo — rasionya 3:1,
	# tidak cocok dipotong jadi lingkaran tanpa gambar baru) supaya tetap
	# tajam di ukuran berapa pun & konsisten sama pola `BigRoundButton`.
	var play_button := Button.new()
	const PLAY_DIAMETER := 220.0
	play_button.custom_minimum_size = Vector2(PLAY_DIAMETER, PLAY_DIAMETER)
	play_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	play_button.text = "▶"
	play_button.add_theme_font_size_override("font_size", 80)
	play_button.add_theme_color_override("font_color", AppColors.INK)
	play_button.add_theme_color_override("font_hover_color", AppColors.INK)
	play_button.add_theme_color_override("font_pressed_color", AppColors.INK)
	play_button.add_theme_color_override("font_focus_color", AppColors.INK)
	var play_style := StyleBoxFlat.new()
	play_style.bg_color = AppColors.SUNSHINE
	play_style.border_color = AppColors.INK
	play_style.set_border_width_all(4)
	play_style.set_corner_radius_all(int(PLAY_DIAMETER / 2.0))
	for state in ["normal", "hover", "pressed", "focus"]:
		play_button.add_theme_stylebox_override(state, play_style)
	play_button.pressed.connect(_on_play_pressed)
	vbox.add_child(play_button)

	var choose_button := Button.new()
	choose_button.text = "Pilih Game"
	choose_button.custom_minimum_size = Vector2(342, 114)  # rasio 3:1, sama persis gambar sumber
	choose_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	choose_button.add_theme_font_size_override("font_size", 26)
	UIStyle.apply_ink_text_color(choose_button)
	_apply_texture_button_style(choose_button, "res://core/assets/images/button_secondary.png")
	choose_button.pressed.connect(_on_toggle_grid)
	vbox.add_child(choose_button)

	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 24)
	_grid.add_theme_constant_override("v_separation", 24)
	_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_grid.visible = false
	vbox.add_child(_grid)

	for game in GameFlow.GAMES:
		_grid.add_child(_make_tile(game))

	# Update 2026-11-22 (redesain ke-2): gear Settings pindah dari pojok
	# kanan atas ke BAWAH tengah layar (atas permintaan user) — "agak
	# besar cuman jangan terlalu besar" → 96x96 (naik dari 88, bukan
	# lompat ke ukuran Play yang 220).
	var settings_button := Button.new()
	UIStyle.apply_icon_frame(settings_button, 96.0)
	var settings_icon_path := "res://core/assets/images/ui/settings.png"
	if FileAccess.file_exists(settings_icon_path):
		settings_button.icon = load(settings_icon_path)
		settings_button.expand_icon = true
		settings_button.add_theme_constant_override("icon_max_width", 52)
	else:
		settings_button.text = "⚙"
	# Pojok kanan BAWAH (bukan tengah bawah) — supaya tidak ketiban grid
	# "Pilih Game" (3x2 kartu 340x220) begitu grid itu dibuka, karena
	# `vbox` isinya center-aligned vertikal (bisa melebar ke bawah).
	settings_button.anchor_left = 1.0
	settings_button.anchor_right = 1.0
	settings_button.anchor_top = 1.0
	settings_button.anchor_bottom = 1.0
	settings_button.offset_left = -104.0
	settings_button.offset_right = -8.0
	settings_button.offset_top = -104.0
	settings_button.offset_bottom = -8.0
	settings_button.pressed.connect(_open_settings)
	add_child(settings_button)


## Pasang gambar pil (`button_primary.png`/`button_secondary.png`) jadi
## background tombol via `StyleBoxTexture` — teksnya tetap dirender
## Godot (`Button.text`) di atasnya, BUKAN ter-bake di gambar, supaya 1
## gambar bisa dipakai ulang untuk teks apa pun & ukuran berapa pun
## (lihat docs/STYLE_GUIDE_ILUSTRASI.md 5.7b).
##
## Update 2026-11-22 (fix bug): percobaan pertama pakai `texture_margin_*`
## (9-slice) dengan angka dikira-kira — hasilnya tombol gepeng oval +
## ada "lipatan" kelihatan (salah hitung margin vs ukuran tombol,
## dilaporkan user). Diganti jadi stretch utuh TANPA margin sama sekali
## — aman selama `custom_minimum_size` tombol dibuat SAMA RASIO dengan
## gambar sumber (2172x724 = rasio 3:1), jadi ikut di-set di pemanggil.
## Update 2026-11-22: helper fix font_hover_color (dulu di sini) dipindah
## ke `core/scripts/ui_style.gd` (`UIStyle.apply_ink_text_color`) supaya
## dipakai ulang semua tombol pil di modul lain, bukan cuma 2 tombol Home.
func _apply_texture_button_style(button: Button, texture_path: String) -> void:
	var style := StyleBoxTexture.new()
	style.texture = load(texture_path)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)


## Update 2026-11-22: redesain kartu modul mengikuti mockup
## `previews/02_pilih_game.png` paket Wawa_GUI_HUD_Pack.zip — dari kotak
## kecil warna solid (120x120) jadi kartu krem besar (340x220) dengan
## border warna aksen + ikon modul besar + nama modul di dalam "chip"
## pil warna aksen (bukan teks putih polos di atas kotak warna lagi).
func _make_tile(game: Dictionary) -> Button:
	var accent := _accent_for(game["kind"])
	var button := Button.new()
	button.custom_minimum_size = Vector2(340, 220)
	button.pressed.connect(_on_tile_pressed.bind(game["scene"]))

	var style := StyleBoxFlat.new()
	style.bg_color = AppColors.CREAM
	style.border_color = accent
	style.set_border_width_all(4)
	style.set_corner_radius_all(20)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)

	var tile_box := VBoxContainer.new()
	tile_box.anchor_right = 1.0
	tile_box.anchor_bottom = 1.0
	tile_box.alignment = BoxContainer.ALIGNMENT_CENTER
	tile_box.add_theme_constant_override("separation", 14)
	tile_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(tile_box)

	var icon := ModuleIcon.new()
	icon.kind = game["kind"]
	icon.custom_minimum_size = Vector2(96, 96)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	tile_box.add_child(icon)

	var label_chip := PanelContainer.new()
	label_chip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var chip_style := StyleBoxFlat.new()
	chip_style.bg_color = accent
	chip_style.set_corner_radius_all(999)
	chip_style.content_margin_left = 28
	chip_style.content_margin_right = 28
	chip_style.content_margin_top = 10
	chip_style.content_margin_bottom = 10
	label_chip.add_theme_stylebox_override("panel", chip_style)
	tile_box.add_child(label_chip)

	var label := Label.new()
	label.text = game["name"]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", AppColors.INK)
	label.add_theme_font_size_override("font_size", 30)
	label_chip.add_child(label)

	return button


## Warna aksen per modul, sinkron dengan docs/UI_UX_DESIGN.md.
static func _accent_for(kind: String) -> Color:
	match kind:
		"angka": return AppColors.ACCENT_ANGKA
		"warna": return AppColors.ACCENT_WARNA
		"hewan": return AppColors.ACCENT_HEWAN
		"musik": return AppColors.ACCENT_MUSIK
		"mewarnai": return AppColors.ACCENT_MEWARNAI
		"puzzle": return AppColors.ACCENT_PUZZLE
		_: return AppColors.SUNSHINE


func _on_play_pressed() -> void:
	GameFlow.start_random_game()


func _on_toggle_grid() -> void:
	_grid.visible = not _grid.visible


func _on_tile_pressed(scene_path: String) -> void:
	GameFlow.start_specific_game(scene_path)


func _open_settings() -> void:
	var gate := ParentalGateDialogScene.instantiate()
	add_child(gate)
	gate.passed.connect(func():
		gate.queue_free()
		GameFlow.infinite_mode = false
		GameFlow.goto_scene("res://scenes/Settings.tscn")
	)
	gate.cancelled.connect(func(): gate.queue_free())

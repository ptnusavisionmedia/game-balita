extends Control
## "Mode Permainan" — pengganti grid "Pilih Game" lama. 4 kartu vertikal,
## tiap kartu 1 TEMA cara main (bukan 1 modul), supaya anak & orang tua
## punya beberapa cara masuk ke 6 mini-game yang sama, bukan cuma acak
## (tombol Play di Home) atau pilih manual.
##
## Dasar tiap tema (lihat juga obsidian-vault/Decisions Log.md 2026-11-26):
## - "Main Sendiri": otonomi memilih — usia 3-5 tahun mulai butuh rasa
##   kontrol atas pilihannya sendiri, bukan cuma didikte/diacak (self-
##   directed play, ala Montessori).
## - "Bareng Orang Tua": scaffolding Vygotsky (Zone of Proximal Development)
##   — anak belajar lebih cepat lewat interaksi aktif orang dewasa
##   (nama/suara/konsep) daripada main sendirian. Ini cuma jalan pintas ke
##   `ParentGuide.tscn` yang sudah ada (kartu per modul + "Mulai Main
##   Bareng" ke mekanik Bareng Orang Tua `feature_hewan`), BUKAN modul baru.
## - "Jelajah Kreatif": main terbuka tanpa benar/salah (Mewarnai/Puzzle) —
##   pentingnya unstructured/open-ended play buat ekspresi & motorik halus,
##   beda dari 2 mode di atas yang berbasis "pilihan".
## - "Tantangan Harian": 1 modul yang SAMA sepanjang hari ini (bukan acak
##   tiap tap seperti Play) — rutinitas yang konsisten/terprediksi penting
##   buat anak kecil (predictability & routine di tumbuh kembang usia dini).

const ParentGuideScenePath := "res://scenes/ParentGuide.tscn"

var _module_grid: GridContainer
var _module_grid_wrapper: Control


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

	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(720, 620)
	center.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(700, 0)
	vbox.add_theme_constant_override("separation", 20)
	scroll.add_child(vbox)

	var title := Label.new()
	title.text = "Mode Permainan"
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", AppColors.INK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	vbox.add_child(_make_mode_card(
		"🧒", AppColors.SUNSHINE,
		"Main Sendiri",
		"Anak pilih sendiri mau main apa dari 6 permainan.",
		_on_main_sendiri_pressed
	))

	vbox.add_child(_make_mode_card(
		"🤝", AppColors.LEAF,
		"Bareng Orang Tua",
		"Orang tua ajak anak nebak suara & gambar sambil ngobrol bareng.",
		_on_bareng_orang_tua_pressed
	))

	vbox.add_child(_make_mode_card(
		"🎨", AppColors.ACCENT_MEWARNAI,
		"Jelajah Kreatif",
		"Mewarnai & puzzle bebas — nggak ada benar/salah, cuma eksplor.",
		_on_jelajah_kreatif_pressed
	))

	vbox.add_child(_make_mode_card(
		"⭐", AppColors.ACCENT_MUSIK,
		"Tantangan Harian",
		"1 permainan pilihan hari ini — sama sepanjang hari, ganti besok.",
		_on_tantangan_harian_pressed
	))

	_module_grid_wrapper = VBoxContainer.new()
	_module_grid_wrapper.visible = false
	_module_grid_wrapper.add_theme_constant_override("separation", 12)
	vbox.add_child(_module_grid_wrapper)

	var grid_label := Label.new()
	grid_label.text = "Pilih permainan:"
	grid_label.add_theme_font_size_override("font_size", 24)
	grid_label.add_theme_color_override("font_color", AppColors.INK)
	grid_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_module_grid_wrapper.add_child(grid_label)

	_module_grid = GridContainer.new()
	_module_grid.columns = 3
	_module_grid.add_theme_constant_override("h_separation", 24)
	_module_grid.add_theme_constant_override("v_separation", 24)
	_module_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_module_grid_wrapper.add_child(_module_grid)

	for game in GameFlow.GAMES:
		_module_grid.add_child(_make_module_tile(game))


## 1 kartu tema: badge emoji bulat warna aksen di kiri + judul & 1 baris
## deskripsi di kanan, seluruh kartu jadi 1 tombol. Pola "kartu lebar" ini
## beda dari `_make_tile` di home.gd (kartu persegi per modul) — supaya
## 4 tema kelihatan beda level dari 6 modul di dalamnya.
func _make_mode_card(emoji: String, accent: Color, title_text: String, subtitle_text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 140)
	button.pressed.connect(callback)

	var style := StyleBoxFlat.new()
	style.bg_color = AppColors.CREAM
	style.border_color = accent
	style.set_border_width_all(4)
	style.border_width_left = 14
	style.set_corner_radius_all(20)
	style.set_content_margin_all(20)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)

	var row := HBoxContainer.new()
	row.anchor_right = 1.0
	row.anchor_bottom = 1.0
	row.add_theme_constant_override("separation", 24)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(row)

	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(88, 88)
	badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var badge_style := StyleBoxFlat.new()
	badge_style.bg_color = accent
	badge_style.set_corner_radius_all(999)
	badge.add_theme_stylebox_override("panel", badge_style)
	row.add_child(badge)

	var badge_label := Label.new()
	badge_label.text = emoji
	badge_label.add_theme_font_size_override("font_size", 42)
	badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_child(badge_label)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	text_box.add_theme_constant_override("separation", 6)
	row.add_child(text_box)

	var title_label := Label.new()
	title_label.text = title_text
	title_label.add_theme_font_size_override("font_size", 30)
	title_label.add_theme_color_override("font_color", AppColors.INK)
	text_box.add_child(title_label)

	var subtitle_label := Label.new()
	subtitle_label.text = subtitle_text
	subtitle_label.add_theme_font_size_override("font_size", 20)
	subtitle_label.add_theme_color_override("font_color", AppColors.INK)
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_box.add_child(subtitle_label)

	return button


## Kartu modul 340x220 — identik `_make_tile` di home.gd (mockup
## `previews/02_pilih_game.png`), dipindah ke sini karena grid pilih manual
## sekarang isi dalam "Main Sendiri", bukan lagi langsung di Home.
func _make_module_tile(game: Dictionary) -> Button:
	var accent := _accent_for(game["kind"])
	var button := Button.new()
	button.custom_minimum_size = Vector2(340, 220)
	button.pressed.connect(func(): GameFlow.start_specific_game(game["scene"]))

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


static func _accent_for(kind: String) -> Color:
	match kind:
		"angka": return AppColors.ACCENT_ANGKA
		"warna": return AppColors.ACCENT_WARNA
		"hewan": return AppColors.ACCENT_HEWAN
		"musik": return AppColors.ACCENT_MUSIK
		"mewarnai": return AppColors.ACCENT_MEWARNAI
		"puzzle": return AppColors.ACCENT_PUZZLE
		_: return AppColors.SUNSHINE


func _on_main_sendiri_pressed() -> void:
	_module_grid_wrapper.visible = not _module_grid_wrapper.visible


## Jalan pintas ke `ParentGuide.tscn` yang sudah ada — isinya kartu per
## modul (kalimat scaffolding + "Mulai Main Bareng" ke mekanik Bareng Orang
## Tua `feature_hewan`, nebak suara/gambar). Sengaja TANPA
## `ParentalGateDialog` di sini: gate itu buat lindungi Settings dari anak
## klak-klik sendiri, bukan buat lindungi konten ini — di mode ini
## orang tua memang diasumsikan sedang duduk bareng anak.
func _on_bareng_orang_tua_pressed() -> void:
	GameFlow.goto_scene(ParentGuideScenePath)


## Pilih acak di antara 2 modul "tanpa benar/salah" (Mewarnai, Puzzle) —
## beda dari Play di Home yang acak dari SEMUA 6 modul, supaya "Jelajah
## Kreatif" konsisten cuma isi main bebas/sensorik, bukan modul kuis
## (Angka/Warna/Hewan) yang punya jawaban benar-salah.
func _on_jelajah_kreatif_pressed() -> void:
	const CREATIVE_KINDS := ["mewarnai", "puzzle"]
	var pool: Array = GameFlow.GAMES.filter(func(g): return g["implemented"] and CREATIVE_KINDS.has(g["kind"]))
	if pool.is_empty():
		return
	randomize()
	var pick: Dictionary = pool[randi() % pool.size()]
	GameFlow.start_specific_game(pick["scene"])


## Deterministik per hari (bukan `randi()`) — pakai hari-ke-berapa dalam
## tahun sebagai index, supaya tap berkali-kali hari yang sama selalu
## kebuka modul yang SAMA (beda dari Play acak di Home), baru ganti besok.
func _on_tantangan_harian_pressed() -> void:
	var pool: Array = GameFlow.GAMES.filter(func(g): return g["implemented"])
	if pool.is_empty():
		return
	var day_of_year: int = Time.get_date_dict_from_system()["day"] + Time.get_date_dict_from_system()["month"] * 31
	var pick: Dictionary = pool[day_of_year % pool.size()]
	GameFlow.start_specific_game(pick["scene"])

extends Control
## Susun puzzle — lihat obsidian-vault/Specs/feature_puzzle.md.
##
## Update 2026-11-21 (ke-3): mekanik diganti dari drag asli
## (`Control._get_drag_data`/`_can_drop_data`/`_drop_data`) jadi
## **tap pilih, lalu tap taruh**. Drag asli Godot ternyata tidak
## reliable di setup canvas-stretch project ini — 3 percobaan beda
## (Control+child Panel, Control+`_draw()` manual, ColorRect/Panel)
## semuanya dilaporkan user area klik/drop-nya tidak sinkron sama yang
## kelihatan. Tap-pilih-lalu-taruh pakai `Button` biasa (TERBUKTI jalan
## konsisten di semua modul lain), dan sebenarnya lebih gampang buat
## motorik anak 1-5 tahun dibanding drag gesture asli — bukan cuma
## workaround teknis. Lihat Decisions Log 2026-11-21.

const DATA_PATH := "res://features/feature_puzzle/data/puzzle_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

var _pieces_data: Array = []
var _filled_count: int = 0
var _piece_buttons: Dictionary = {}  # id -> {"button": Button, "color": Color}
var _slot_buttons: Dictionary = {}   # id -> Button
var _slot_filled: Dictionary = {}    # id -> bool
var _selected_piece_id: String = ""
var _has_shape_images: bool = false


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	var puzzles := _load_puzzles()
	if puzzles.is_empty():
		push_warning("feature_puzzle: puzzle_data.json kosong/gagal dibaca — modul tidak bisa jalan.")
		return
	var puzzle: Dictionary = puzzles[0]
	_pieces_data = puzzle.get("pieces", [])
	_has_shape_images = not _pieces_data.is_empty() \
		and FileAccess.file_exists(str(_pieces_data[0].get("shape_image", "")))

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var title := Label.new()
	title.text = "Susun %s" % str(puzzle.get("picture_name", "Gambar"))
	title.add_theme_font_size_override("font_size", 34)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var hint := Label.new()
	hint.text = "Tap keping warnanya, lalu tap kotak yang cocok."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(hint)

	# Slot target (outline kosong) — urutan TIDAK sama dengan urutan
	# keping di bawah supaya anak benar-benar mencocokkan.
	var slots_box := HBoxContainer.new()
	slots_box.alignment = BoxContainer.ALIGNMENT_CENTER
	slots_box.add_theme_constant_override("separation", 12)
	vbox.add_child(slots_box)

	for piece in _pieces_data:
		var id: String = str(piece.get("id", ""))
		var slot_button := Button.new()
		slot_button.custom_minimum_size = Vector2(120, 120)
		_style_slot_empty(slot_button)
		_set_button_shape_icon(slot_button, piece.get("slot_image", ""), "")
		slot_button.pressed.connect(_on_slot_pressed.bind(id))
		slots_box.add_child(slot_button)
		_slot_buttons[id] = slot_button
		_slot_filled[id] = false

	var pieces_box := HBoxContainer.new()
	pieces_box.alignment = BoxContainer.ALIGNMENT_CENTER
	pieces_box.add_theme_constant_override("separation", 16)
	vbox.add_child(pieces_box)

	randomize()
	var shuffled: Array = _pieces_data.duplicate()
	shuffled.shuffle()
	for piece in shuffled:
		var id: String = str(piece.get("id", ""))
		var color := Color(str(piece.get("color_hex", "#FFFFFF")))
		var piece_button := Button.new()
		piece_button.custom_minimum_size = Vector2(110, 110)
		_style_piece(piece_button, color, false)
		_set_button_shape_icon(piece_button, piece.get("shape_image", ""), str(piece.get("name", "")))
		piece_button.pressed.connect(_on_piece_pressed.bind(id))
		pieces_box.add_child(piece_button)
		_piece_buttons[id] = {"button": piece_button, "color": color, "shape_image": piece.get("shape_image", "")}

	_add_home_button()


func _load_puzzles() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return parsed if parsed is Array else []


## Fallback kalau gambar shape-sorter asli belum ada: kotak warna polos
## (gaya lama). Dengan gambar, warna cuma kepake di border seleksi.
func _style_piece(button: Button, color: Color, selected: bool) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color if not _has_shape_images else Color(0, 0, 0, 0)
	style.set_corner_radius_all(12)
	if selected:
		style.border_color = AppColors.GOLD
		style.set_border_width_all(6)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)


func _style_slot_empty(button: Button) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = AppColors.INK
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)


func _style_slot_filled(button: Button, color: Color) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color if not _has_shape_images else Color(0, 0, 0, 0)
	style.border_color = AppColors.LEAF
	style.set_border_width_all(4)
	style.set_corner_radius_all(12)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)


## Pasang ilustrasi shape-sorter asli (lihat docs/ASSET_LIST.md #6) kalau
## filenya ada; kalau belum, biarkan kotak warna polos (gaya lama) yang
## dipasang `_style_piece`/`_style_slot_empty`.
func _set_button_shape_icon(button: Button, image_path, fallback_text: String) -> void:
	var path := str(image_path)
	if path != "" and FileAccess.file_exists(path):
		button.icon = load(path)
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 88)
	elif fallback_text != "":
		button.text = fallback_text


## Tap keping = "pilih" (toggle — tap lagi buat batal pilih). Pilih
## keping lain otomatis ganti pilihan sebelumnya.
func _on_piece_pressed(piece_id: String) -> void:
	_selected_piece_id = "" if _selected_piece_id == piece_id else piece_id
	for id in _piece_buttons.keys():
		var entry: Dictionary = _piece_buttons[id]
		_style_piece(entry["button"], entry["color"], id == _selected_piece_id)


## Tap slot = "taruh" keping yang sedang dipilih. Keping yang tidak
## cocok cuma diam saja (tidak ada suara/animasi "salah", lihat spek
## bagian Feedback). Tap slot tanpa keping terpilih juga tidak
## ngapa-ngapain.
func _on_slot_pressed(slot_id: String) -> void:
	if _selected_piece_id == "" or _slot_filled.get(slot_id, true):
		return
	if _selected_piece_id != slot_id:
		return

	var entry: Dictionary = _piece_buttons[_selected_piece_id]
	var slot_button: Button = _slot_buttons[slot_id]
	_style_slot_filled(slot_button, entry["color"])
	_set_button_shape_icon(slot_button, entry.get("shape_image", ""), "")
	entry["button"].visible = false
	_slot_filled[slot_id] = true
	SfxService.play(load("res://core/assets/audio/sfx_correct.wav"))
	_selected_piece_id = ""

	_filled_count += 1
	if _filled_count >= _pieces_data.size():
		_show_reward()


## Tombol darurat, selalu terlihat — PENTING khusus modul ini karena 1
## sesi puzzle bisa makan waktu lebih lama dari modul lain.
func _add_home_button() -> void:
	var home_button := Button.new()
	_apply_home_icon(home_button)
	home_button.custom_minimum_size = Vector2(88, 88)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 96.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 100.0
	home_button.pressed.connect(func(): GameFlow.go_home())
	add_child(home_button)


## Ikon rumah asli (lihat docs/ASSET_LIST.md #11) — fallback emoji kalau
## file belum ada. Dipakai 6 modul feature_* (duplikasi disengaja, pola
## sama `_add_home_button`, lihat komentarnya).
func _apply_home_icon(button: Button) -> void:
	UIStyle.apply_icon_frame(button)
	var path := "res://core/assets/images/ui/home.png"
	if FileAccess.file_exists(path):
		button.icon = load(path)
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 48)
	else:
		button.text = "🏠"


func _show_reward() -> void:
	var overlay := StarRewardOverlayScene.instantiate()
	overlay.stars_earned = _pieces_data.size()
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_puzzle", _pieces_data.size())
		GameFlow.finish_game_session()
	)

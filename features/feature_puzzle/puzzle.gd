extends Control
## Susun puzzle — lihat obsidian-vault/Specs/feature_puzzle.md.
##
## Update 2026-11-26 (ke-4): BALIK ke drag-and-drop asli, atas permintaan
## user ("gak bisa ditekan dan digeser, hanya bisa diklik ... padahal kan
## seperti balok"). 3 percobaan sebelumnya (2026-11-21, lihat Decisions
## Log) pakai API drag BAWAAN Godot (`Control._get_drag_data`/
## `_can_drop_data`/`_drop_data`) — API itu render "drag preview" lewat
## `Viewport`/layer terpisah yang posisinya di-drive dari koordinat OS
## MENTAH, TIDAK otomatis ikut transform stretch `canvas_items` proyek
## ini, jadi preview & area drop gampang meleset begitu window/device
## beda rasio dari kanvas desain 1280x720 — itu yang bikin 3 percobaan
## sebelumnya gagal terus.
##
## Pendekatan kali ini TIDAK pakai API itu sama sekali: keping (`Button`
## biasa) digerakkan manual lewat `_input()` level root, set
## `global_position` dari `event.position` langsung — koordinat event
## mouse/touch Godot SUDAH otomatis dalam ruang kanvas yang sama dengan
## `global_position` Control (bukan pixel layar OS mentah), jadi tetap
## akurat berapa pun stretch/device-nya. Pola geometri (freed dari
## container, pakai `global_position`) sama kayak `scenes/touch_and_listen.gd`
## yang terbukti akurat di semua ukuran.

const DATA_PATH := "res://features/feature_puzzle/data/puzzle_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

## Jarak pusat-ke-pusat keping↔slot dianggap "cocok" saat dilepas —
## longgar (bukan butuh presisi penuh) karena motorik drag anak 1-5
## tahun belum presisi, lihat prinsip sama di docs/UI_UX_DESIGN.md.
const DROP_MATCH_RADIUS := 80.0

var _pieces_data: Array = []
var _filled_count: int = 0
var _piece_buttons: Dictionary = {}  # id -> {"button": Button, "color": Color, "shape_image": String}
var _slot_buttons: Dictionary = {}   # id -> Button
var _slot_filled: Dictionary = {}    # id -> bool
var _piece_home_pos: Dictionary = {}  # id -> Vector2 (global_position awal, buat "pegas balik" kalau salah taruh)
var _has_shape_images: bool = false

var _dragging_id: String = ""
var _drag_grab_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	var bg := GameBackground.new()
	bg.tint_color = AppColors.ACCENT_PUZZLE
	add_child(bg)

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
	hint.text = "Geser keping warnanya ke kotak yang cocok."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(hint)

	# Slot target (outline kosong) — urutan TIDAK sama dengan urutan
	# keping di bawah supaya anak benar-benar mencocokkan. Slot TETAP di
	# dalam container (tidak di-drag), cuma jadi target geometri.
	var slots_box := HBoxContainer.new()
	slots_box.alignment = BoxContainer.ALIGNMENT_CENTER
	slots_box.add_theme_constant_override("separation", 12)
	vbox.add_child(slots_box)

	for piece in _pieces_data:
		var id: String = str(piece.get("id", ""))
		var slot_button := Button.new()
		slot_button.custom_minimum_size = Vector2(120, 120)
		slot_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_style_slot_empty(slot_button)
		_set_button_shape_icon(slot_button, piece.get("slot_image", ""), "")
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
		piece_button.mouse_filter = Control.MOUSE_FILTER_IGNORE  # digerakkan manual lewat _input, bukan klik Button
		_style_piece(piece_button, color, false)
		_set_button_shape_icon(piece_button, piece.get("shape_image", ""), str(piece.get("name", "")))
		pieces_box.add_child(piece_button)
		_piece_buttons[id] = {"button": piece_button, "color": color, "shape_image": piece.get("shape_image", "")}

	_add_home_button()

	# Tunggu 1 frame supaya `pieces_box` (HBoxContainer) selesai hitung
	# posisi awal tiap keping (rapi berjajar-tengah), BARU dilepas dari
	# container jadi child langsung `self` — supaya setelahnya bebas
	# digeser ke mana saja tanpa dipaksa container balik ke posisi rapinya.
	await get_tree().process_frame
	_free_pieces_from_container()


func _free_pieces_from_container() -> void:
	for id in _piece_buttons.keys():
		var btn: Button = _piece_buttons[id]["button"]
		var gpos: Vector2 = btn.global_position
		btn.get_parent().remove_child(btn)
		add_child(btn)
		btn.global_position = gpos
		_piece_home_pos[id] = gpos


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


## Drag manual — lihat catatan panjang di kepala file kenapa BUKAN pakai
## `_get_drag_data`/`_drop_data` bawaan Godot. `_input` (bukan
## `_gui_input`/`_unhandled_input`) dipakai supaya tetap kebaca walau
## jari/kursor ada di atas keping/slot Button lain (semua Button di sini
## `mouse_filter = IGNORE`, jadi tidak ada yang "menelan" event duluan,
## tapi `_input` dipilih juga biar konsisten pola sama `touch_and_listen.gd`).
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_try_start_drag(event.position)
		else:
			_end_drag()
	elif event is InputEventScreenDrag:
		if _dragging_id != "":
			_update_drag(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_try_start_drag(event.position)
		else:
			_end_drag()
	elif event is InputEventMouseMotion:
		if _dragging_id != "":
			_update_drag(event.position)


func _try_start_drag(pos: Vector2) -> void:
	for id in _piece_buttons.keys():
		if _slot_filled.get(id, false):
			continue  # sudah terpasang, tidak bisa digeser lagi
		var btn: Button = _piece_buttons[id]["button"]
		if btn.get_global_rect().has_point(pos):
			_dragging_id = id
			_drag_grab_offset = pos - btn.global_position
			move_child(btn, get_child_count() - 1)  # naikkan ke paling depan selagi digeser
			_style_piece(btn, _piece_buttons[id]["color"], true)
			return


func _update_drag(pos: Vector2) -> void:
	var btn: Button = _piece_buttons[_dragging_id]["button"]
	btn.global_position = pos - _drag_grab_offset


func _end_drag() -> void:
	if _dragging_id == "":
		return
	var id := _dragging_id
	_dragging_id = ""

	var entry: Dictionary = _piece_buttons[id]
	var btn: Button = entry["button"]
	var slot_button: Button = _slot_buttons[id]
	var piece_center: Vector2 = btn.global_position + btn.size / 2.0
	var slot_center: Vector2 = slot_button.global_position + slot_button.size / 2.0

	if not _slot_filled.get(id, false) and piece_center.distance_to(slot_center) <= DROP_MATCH_RADIUS:
		_place_piece(id)
	else:
		_style_piece(btn, entry["color"], false)
		var tween := create_tween()
		tween.tween_property(btn, "global_position", _piece_home_pos[id], 0.25) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Keping "nempel" ke slot yang cocok — animasi geser cepat ke posisi
## slot, baru disembunyikan & slot ditandai terisi. Tidak ada suara/
## animasi "salah" buat keping yang tidak cocok (lihat spek bagian
## Feedback) — itu sudah ditangani di `_end_drag` (diam, pegas balik).
func _place_piece(id: String) -> void:
	var entry: Dictionary = _piece_buttons[id]
	var btn: Button = entry["button"]
	var slot_button: Button = _slot_buttons[id]

	_style_piece(btn, entry["color"], false)
	_slot_filled[id] = true

	var tween := create_tween()
	tween.tween_property(btn, "global_position", slot_button.global_position, 0.15)
	tween.tween_callback(func():
		_style_slot_filled(slot_button, entry["color"])
		_set_button_shape_icon(slot_button, entry.get("shape_image", ""), "")
		btn.visible = false
	)

	SfxService.play(load("res://core/assets/audio/sfx_correct.wav"))

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

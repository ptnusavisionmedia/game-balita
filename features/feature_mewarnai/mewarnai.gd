extends Control
## Isi area dengan warna pilihan — lihat obsidian-vault/Specs/feature_mewarnai.md.
## SENGAJA tanpa benar/salah — ini ekspresi bebas, bukan kuis. Bukan
## freehand drawing piksel (di luar scope base model, lihat spek).
##
## Palet warna sengaja pakai AppColors (bukan data file terpisah) supaya
## konsisten dengan feature_warna tanpa feature_* saling depend satu sama
## lain (lihat docs/ARCHITECTURE.md "Aturan dependensi").

const DATA_PATH := "res://features/feature_mewarnai/data/mewarnai_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")
const UNFILLED_COLOR := Color("#E0E0E0")

var _palette: Array = [
	AppColors.SUNSHINE, AppColors.LEAF, AppColors.CORAL,
	AppColors.ACCENT_MUSIK, AppColors.ACCENT_MEWARNAI, AppColors.GOLD,
]

var _areas: Array = []
var _filled_ids: Dictionary = {}
var _active_color: Color
var _area_buttons: Dictionary = {}


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	var pictures := _load_pictures()
	if pictures.is_empty():
		push_warning("feature_mewarnai: mewarnai_data.json kosong/gagal dibaca — modul tidak bisa jalan.")
		return
	var picture: Dictionary = pictures[0]
	_areas = picture.get("areas", [])
	_active_color = _palette[0]

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var title := Label.new()
	title.text = "Warnai %s" % picture.get("picture_name", "Gambar")
	title.add_theme_font_size_override("font_size", 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var canvas_size: Dictionary = picture.get("canvas_size", {"w": 360, "h": 360})
	var canvas := Control.new()
	canvas.custom_minimum_size = Vector2(canvas_size.get("w", 360), canvas_size.get("h", 360))
	# SHRINK_CENTER — tanpa ini VBoxContainer men-stretch canvas ke lebar
	# penuh layar, geser semua area (posisi absolut relatif ke pojok kiri
	# atas canvas) jadi menempel kiri, bukan di tengah (bug yang sama
	# dilaporkan user di scenes/home.gd 2026-11-21).
	canvas.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(canvas)

	for area in _areas:
		var button := _make_area_button(area)
		canvas.add_child(button)
		_area_buttons[area.get("id", "")] = button

	var palette_box := HBoxContainer.new()
	palette_box.alignment = BoxContainer.ALIGNMENT_CENTER
	palette_box.add_theme_constant_override("separation", 12)
	vbox.add_child(palette_box)

	for color in _palette:
		palette_box.add_child(_make_palette_swatch(color))

	_add_home_button()


func _load_pictures() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return parsed if parsed is Array else []


func _make_area_button(area: Dictionary) -> Button:
	var rect: Dictionary = area.get("rect", {})
	var button := Button.new()
	button.position = Vector2(rect.get("x", 0), rect.get("y", 0))
	button.size = Vector2(rect.get("w", 50), rect.get("h", 50))
	_set_button_color(button, UNFILLED_COLOR)
	button.pressed.connect(_on_area_pressed.bind(area.get("id", "")))
	return button


func _make_palette_swatch(color: Color) -> Button:
	var swatch := Button.new()
	swatch.custom_minimum_size = Vector2(56, 56)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(999)
	for state in ["normal", "hover", "pressed", "focus"]:
		swatch.add_theme_stylebox_override(state, style)
	swatch.pressed.connect(func(): _active_color = color)
	return swatch


func _set_button_color(button: Button, color: Color) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(16)
	for state in ["normal", "hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(state, style)


## Tidak ada "benar/salah" — tap area mana pun, warna apa pun, selalu
## valid. Cuma dihitung "sudah pernah diisi" buat tahu sesi selesai.
func _on_area_pressed(area_id: String) -> void:
	var button: Button = _area_buttons.get(area_id)
	if button == null:
		return
	_set_button_color(button, _active_color)
	SfxService.play(null)  # TODO Farel: sfx_tap netral

	if not _filled_ids.has(area_id):
		_filled_ids[area_id] = true
		if _filled_ids.size() >= _areas.size():
			_show_reward()


## Tombol darurat, selalu terlihat — pola wajib dari feature_angka.
func _add_home_button() -> void:
	var home_button := Button.new()
	home_button.text = "🏠"
	home_button.custom_minimum_size = Vector2(56, 56)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 64.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 68.0
	home_button.pressed.connect(func(): GameFlow.go_home())
	add_child(home_button)


func _show_reward() -> void:
	var overlay := StarRewardOverlayScene.instantiate()
	# stars_earned TIDAK berarti "benar/salah" — cuma jumlah area yang
	# sudah pernah diwarnai (pola sama feature_musik).
	overlay.stars_earned = _filled_ids.size()
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_mewarnai", _filled_ids.size())
		GameFlow.finish_game_session()
	)

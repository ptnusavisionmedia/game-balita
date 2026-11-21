extends Control
## Susun puzzle (drag, snap longgar) — lihat obsidian-vault/Specs/feature_puzzle.md.
## 3-4 keping untuk level 1 (bukan langsung 6).

const DATA_PATH := "res://features/feature_puzzle/data/puzzle_data.json"
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")
const PuzzlePieceScript := preload("res://features/feature_puzzle/puzzle_piece.gd")
const PuzzleSlotScript := preload("res://features/feature_puzzle/puzzle_slot.gd")

var _pieces_data: Array = []
var _filled_count: int = 0
var _pieces: Dictionary = {}


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var puzzles := _load_puzzles()
	if puzzles.is_empty():
		push_warning("feature_puzzle: puzzle_data.json kosong/gagal dibaca — modul tidak bisa jalan.")
		return
	var puzzle: Dictionary = puzzles[0]
	_pieces_data = puzzle.get("pieces", [])

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var title := Label.new()
	title.text = "Susun %s" % str(puzzle.get("picture_name", "Gambar"))
	title.add_theme_font_size_override("font_size", 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Slot target (outline kosong), urutan TIDAK sama dengan urutan keping
	# di bawah supaya anak benar-benar mencocokkan, bukan asal urut.
	var slots_box := HBoxContainer.new()
	slots_box.alignment = BoxContainer.ALIGNMENT_CENTER
	slots_box.add_theme_constant_override("separation", 12)
	vbox.add_child(slots_box)

	for piece in _pieces_data:
		var slot := PuzzleSlotScript.new()
		slot.custom_minimum_size = Vector2(90, 90)
		slot.expected_piece_id = str(piece.get("id", ""))
		slot.expected_color = Color(str(piece.get("color_hex", "#FFFFFF")))
		slot.piece_dropped.connect(_on_piece_dropped)
		slots_box.add_child(slot)

	var pieces_box := HBoxContainer.new()
	pieces_box.alignment = BoxContainer.ALIGNMENT_CENTER
	pieces_box.add_theme_constant_override("separation", 16)
	vbox.add_child(pieces_box)

	randomize()
	var shuffled: Array = _pieces_data.duplicate()
	shuffled.shuffle()
	for piece in shuffled:
		var piece_node := PuzzlePieceScript.new()
		piece_node.custom_minimum_size = Vector2(80, 80)
		piece_node.piece_id = str(piece.get("id", ""))
		piece_node.piece_color = Color(str(piece.get("color_hex", "#FFFFFF")))
		pieces_box.add_child(piece_node)
		_pieces[str(piece.get("id", ""))] = piece_node

	_add_home_button()


func _load_puzzles() -> Array:
	if not FileAccess.file_exists(DATA_PATH):
		return []
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return parsed if parsed is Array else []


func _on_piece_dropped(piece_id: String) -> void:
	SfxService.play(null)  # TODO Farel: sfx_correct
	var piece_node: Control = _pieces.get(piece_id)
	if piece_node:
		piece_node.visible = false

	_filled_count += 1
	if _filled_count >= _pieces_data.size():
		_show_reward()


## Tombol darurat, selalu terlihat — PENTING khusus modul ini karena 1
## sesi puzzle bisa makan waktu lebih lama dari modul lain (lihat spek).
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
	overlay.stars_earned = _pieces_data.size()
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_puzzle", _pieces_data.size())
		GameFlow.finish_game_session()
	)

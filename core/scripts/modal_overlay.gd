extends Control
class_name ModalOverlay
## Pop-up modal generik — dibuat 2026-11-28 supaya tombol seperti "Main
## Sendiri" (lihat scenes/game_modes.gd) membuka konten TAMBAHAN sebagai
## layer di ATAS layar, bukan toggle `visible` INLINE di dalam layout yang
## sama. Toggle inline bikin container pembungkus (biasanya VBoxContainer
## center-aligned) berubah tinggi total-nya begitu konten baru muncul,
## jadi SELURUH isi layar di atasnya ikut bergeser posisi — persis
## komplain user ("tombol function malah mengeser UI-nya, bukan page
## pop up/page baru"). Modal ini berdiri di layer terpisah: apa pun yang
## terjadi di dalamnya TIDAK PERNAH menggeser konten di baliknya.
##
## Pola backdrop+CenterContainer+PanelContainer dipakai ulang dari
## `core/scripts/parental_gate_dialog.gd` (sudah terbukti jalan) —
## bedanya di sini ditambah animasi masuk/keluar + tap-backdrop-untuk-tutup
## + API generik `show_content()` (dialog gate khusus soal tambah, modal
## ini untuk konten apa saja).

signal closed

var _backdrop: ColorRect
var _card: PanelContainer
var _content_slot: VBoxContainer


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	_backdrop = ColorRect.new()
	_backdrop.color = Color(0, 0, 0, 0.0)
	_backdrop.anchor_right = 1.0
	_backdrop.anchor_bottom = 1.0
	_backdrop.gui_input.connect(_on_backdrop_input)
	add_child(_backdrop)

	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	_card = PanelContainer.new()
	_card.scale = Vector2(0.85, 0.85)
	_card.pivot_offset = Vector2.ZERO  # diperbaiki setelah ukuran kartu diketahui, lihat _ready animasi di bawah
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = AppColors.CREAM
	card_style.border_color = AppColors.INK
	card_style.set_border_width_all(3)
	card_style.set_corner_radius_all(28)
	card_style.set_content_margin_all(28)
	card_style.shadow_size = 18
	card_style.shadow_color = Color(0, 0, 0, 0.25)
	card_style.shadow_offset = Vector2(0, 8)
	_card.add_theme_stylebox_override("panel", card_style)
	center.add_child(_card)

	var outer_column := VBoxContainer.new()
	outer_column.add_theme_constant_override("separation", 12)
	_card.add_child(outer_column)

	var close_button := Button.new()
	UIStyle.apply_icon_frame(close_button, 64.0)
	var close_icon_path := "res://core/assets/images/ui/close_x.png"
	if FileAccess.file_exists(close_icon_path):
		close_button.icon = load(close_icon_path)
		close_button.expand_icon = true
		close_button.add_theme_constant_override("icon_max_width", 32)
	else:
		close_button.text = "✕"
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	close_button.pressed.connect(close)
	outer_column.add_child(close_button)

	_content_slot = VBoxContainer.new()
	_content_slot.add_theme_constant_override("separation", 16)
	outer_column.add_child(_content_slot)

	# call_deferred: tunggu 1 frame supaya layout (CenterContainer dkk)
	# selesai hitung ukuran kartu sungguhan sebelum animasi masuk jalan —
	# pola sama `game_background.gd`/`touch_and_listen.gd` session ini.
	_play_enter_animation.call_deferred()


## Isi modal dengan node apa saja (grid modul, dll) — dipanggil tepat
## setelah `add_child(ModalOverlay.new())` oleh pemanggil.
func show_content(content: Control) -> void:
	for child in _content_slot.get_children():
		child.queue_free()
	_content_slot.add_child(content)


func _play_enter_animation() -> void:
	_card.pivot_offset = _card.size / 2.0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_backdrop, "color:a", 0.45, 0.15)
	tween.tween_property(_card, "scale", Vector2.ONE, 0.2) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func close() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_backdrop, "color:a", 0.0, 0.12)
	tween.tween_property(_card, "scale", Vector2(0.85, 0.85), 0.12)
	tween.chain().tween_callback(func():
		closed.emit()
		queue_free()
	)


func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close()
	elif event is InputEventScreenTouch and event.pressed:
		close()

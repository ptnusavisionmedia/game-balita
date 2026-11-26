extends Control
## Mode "Sentuh & Dengar" — tier khusus usia 1-2 tahun (lihat
## obsidian-vault/Decisions Log.md 2026-11-26). BUKAN mini-game dengan
## aturan/menu/navigasi seperti `feature_*` — full-layar, NOL navigasi, NOL
## kemungkinan "salah": tap di mana saja, langsung muncul gambar + bunyi.
##
## Kenapa beda dari 6 modul lain: usia 1-2 tahun belum punya kontrol
## motorik buat navigasi menu/grid atau paham instruksi — satu-satunya
## "mekanik" yang pas di usia ini adalah sebab-akibat sederhana (tap →
## reaksi instan), bukan pilihan/kuis. Asetnya DAUR ULANG dari modul yang
## sudah ada (hewan + musik, gambar+suara berpasangan) — bukan aset baru.
##
## Satu-satunya jalan keluar: gear kecil transparan pojok kanan bawah,
## sengaja DIBUAT KECIL & SAMAR (bukan mencolok kayak tombol lain) supaya
## tidak mengundang tap balita, tapi tetap ada buat orang tua — tetap di
## belakang `ParentalGateDialog` yang sama kayak jalur Settings biasa.

const ParentalGateDialogScene := preload("res://core/scenes/ParentalGateDialog.tscn")

const SPAWN_SIZE := 180.0
const CELEBRATE_EVERY_N_TAPS := 5

## Pasangan gambar+suara didaur ulang dari feature_hewan (suara hewan) +
## feature_musik (nada xylophone) — 2 keluarga aset yang sudah "gambar
## muncul + bunyi" secara alami, pas buat sebab-akibat sederhana.
const POOL := [
	{"image": "res://features/feature_hewan/assets/images/anjing.png", "sound": "res://features/feature_hewan/assets/audio/anjing.wav"},
	{"image": "res://features/feature_hewan/assets/images/ayam.png", "sound": "res://features/feature_hewan/assets/audio/ayam.wav"},
	{"image": "res://features/feature_hewan/assets/images/bebek.png", "sound": "res://features/feature_hewan/assets/audio/bebek.wav"},
	{"image": "res://features/feature_hewan/assets/images/kambing.png", "sound": "res://features/feature_hewan/assets/audio/kambing.wav"},
	{"image": "res://features/feature_hewan/assets/images/kucing.png", "sound": "res://features/feature_hewan/assets/audio/kucing.wav"},
	{"image": "res://features/feature_hewan/assets/images/sapi.png", "sound": "res://features/feature_hewan/assets/audio/sapi.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_01_do.png", "sound": "res://features/feature_musik/assets/audio/nada_01_do.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_02_re.png", "sound": "res://features/feature_musik/assets/audio/nada_02_re.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_03_mi.png", "sound": "res://features/feature_musik/assets/audio/nada_03_mi.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_04_fa.png", "sound": "res://features/feature_musik/assets/audio/nada_04_fa.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_05_sol.png", "sound": "res://features/feature_musik/assets/audio/nada_05_sol.wav"},
	{"image": "res://features/feature_musik/assets/images/bilah_06_la.png", "sound": "res://features/feature_musik/assets/audio/nada_06_la.wav"},
]

var _spawn_layer: Control
var _tap_count: int = 0


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	_spawn_layer = Control.new()
	_spawn_layer.anchor_right = 1.0
	_spawn_layer.anchor_bottom = 1.0
	_spawn_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_spawn_layer)

	_add_parent_exit_button()


## Sengaja `_unhandled_input` (bukan `_gui_input`/`_input`) — tombol
## keluar orang tua (Button biasa) otomatis "accept" klik-nya sendiri
## duluan, jadi tap di gear itu TIDAK akan nyasar jadi spawn gambar juga.
## Tap di mana pun SISANYA (99% layar) jatuh ke sini.
func _unhandled_input(event: InputEvent) -> void:
	var pos: Vector2
	if event is InputEventScreenTouch and event.pressed:
		pos = event.position
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pos = event.position
	else:
		return
	_spawn_at(pos)


func _spawn_at(pos: Vector2) -> void:
	var item: Dictionary = POOL[randi() % POOL.size()]

	if FileAccess.file_exists(item["sound"]):
		SfxService.play(load(item["sound"]))

	if FileAccess.file_exists(item["image"]):
		var pic := TextureRect.new()
		pic.texture = load(item["image"])
		pic.custom_minimum_size = Vector2(SPAWN_SIZE, SPAWN_SIZE)
		pic.size = Vector2(SPAWN_SIZE, SPAWN_SIZE)
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pic.position = pos - Vector2(SPAWN_SIZE, SPAWN_SIZE) / 2.0
		pic.pivot_offset = Vector2(SPAWN_SIZE, SPAWN_SIZE) / 2.0
		pic.scale = Vector2(0.2, 0.2)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_spawn_layer.add_child(pic)

		var tween := create_tween()
		tween.tween_property(pic, "scale", Vector2(1.15, 1.15), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(pic, "scale", Vector2(1.0, 1.0), 0.12)
		tween.tween_interval(1.0)
		tween.tween_property(pic, "modulate:a", 0.0, 0.4)
		tween.tween_callback(pic.queue_free)

	_tap_count += 1
	if _tap_count % CELEBRATE_EVERY_N_TAPS == 0:
		_celebrate()


## Reaksi hangat berkala — BUKAN reward/skor (anak tidak pernah lihat
## angka/bintang di mode ini), cuma maskot ikut senang supaya tap terasa
## "disambut", konsisten prinsip no-score app ini.
func _celebrate() -> void:
	var mascot_path := "res://core/assets/images/mascot/wawa_merayakan.png"
	if not FileAccess.file_exists(mascot_path):
		return
	var mascot := TextureRect.new()
	mascot.texture = load(mascot_path)
	var size := Vector2(220, 220)
	mascot.custom_minimum_size = size
	mascot.size = size
	mascot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mascot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mascot.anchor_left = 0.5
	mascot.anchor_right = 0.5
	mascot.anchor_top = 0.5
	mascot.anchor_bottom = 0.5
	mascot.position = -size / 2.0
	mascot.pivot_offset = size / 2.0
	mascot.scale = Vector2(0.3, 0.3)
	mascot.modulate.a = 0.0
	mascot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_spawn_layer.add_child(mascot)

	if FileAccess.file_exists("res://core/assets/audio/sfx_correct.wav"):
		SfxService.play(load("res://core/assets/audio/sfx_correct.wav"))

	var tween := create_tween()
	tween.tween_property(mascot, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(mascot, "modulate:a", 1.0, 0.2)
	tween.tween_interval(1.0)
	tween.tween_property(mascot, "modulate:a", 0.0, 0.5)
	tween.tween_callback(mascot.queue_free)


## Gear kecil & SAMAR (opacity rendah, ukuran lebih kecil dari token
## `icon.s` 88px) — sengaja biar tidak jadi target tap favorit balita,
## beda dari gear Settings normal di Home yang memang dibuat jelas
## kelihatan buat anak 3-5 tahun. Tetap lewat PIN (`ParentalGateDialog`)
## yang sama kayak jalur Settings biasa.
func _add_parent_exit_button() -> void:
	var button := Button.new()
	UIStyle.apply_icon_frame(button, 56.0)
	button.modulate.a = 0.35
	var settings_icon_path := "res://core/assets/images/ui/settings.png"
	if FileAccess.file_exists(settings_icon_path):
		button.icon = load(settings_icon_path)
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 30)
	else:
		button.text = "⚙"
	button.anchor_left = 1.0
	button.anchor_right = 1.0
	button.anchor_top = 1.0
	button.anchor_bottom = 1.0
	button.offset_left = -72.0
	button.offset_right = -8.0
	button.offset_top = -72.0
	button.offset_bottom = -8.0
	button.pressed.connect(_open_settings)
	add_child(button)


func _open_settings() -> void:
	var gate := ParentalGateDialogScene.instantiate()
	add_child(gate)
	gate.passed.connect(func():
		gate.queue_free()
		GameFlow.goto_scene("res://scenes/Settings.tscn")
	)
	gate.cancelled.connect(func(): gate.queue_free())

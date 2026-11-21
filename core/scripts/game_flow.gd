extends Node
## Pusat navigasi antar scene + katalog game + mode "Play acak infinite".
## Autoload singleton — satu sumber kebenaran untuk daftar game (sebelumnya
## duplikat di home.gd). Lihat obsidian-vault/Decisions Log.md 2026-11-20.
##
## Semua navigasi scene (Home, Settings, mini-game) WAJIB lewat `goto_scene`
## di sini, bukan `get_tree().change_scene_to_file()` langsung — supaya
## transisi fade & debounce anti-klik-ganda konsisten di seluruh app.

## `implemented: false` = belum ada logic game sungguhan (masih placeholder),
## jadi tidak masuk pool "Play acak". Ganti jadi true begitu modulnya selesai.
const GAMES := [
	{"name": "Angka", "kind": "angka", "scene": "res://features/feature_angka/Angka.tscn", "implemented": true},
	{"name": "Warna", "kind": "warna", "scene": "res://features/feature_warna/Warna.tscn", "implemented": true},
	{"name": "Hewan", "kind": "hewan", "scene": "res://features/feature_hewan/Hewan.tscn", "implemented": true},
	{"name": "Musik", "kind": "musik", "scene": "res://features/feature_musik/Musik.tscn", "implemented": true},
	{"name": "Mewarnai", "kind": "mewarnai", "scene": "res://features/feature_mewarnai/Mewarnai.tscn", "implemented": true},
	{"name": "Puzzle", "kind": "puzzle", "scene": "res://features/feature_puzzle/Puzzle.tscn", "implemented": true},
]

## true kalau sesi main sekarang dimulai lewat tombol Play (acak) — dipakai
## `finish_game_session()` untuk tahu harus lempar ke game acak lain atau
## balik ke Home.
var infinite_mode: bool = false

## true kalau sesi main sekarang dimulai lewat "Mulai main bareng" di
## `ParentGuide` (Settings, di belakang `ParentalGateDialog`) — dibaca modul
## yang punya 2 mekanik (sekarang cuma `feature_hewan`) buat pilih render
## mode Mandiri vs Bareng Orang Tua. Lihat obsidian-vault/Specs/feature_hewan.md.
var guided_mode: bool = false

const _NAV_DEBOUNCE_MS := 600
var _last_nav_time: int = -_NAV_DEBOUNCE_MS
var _busy: bool = false

var _fade_rect: ColorRect


func _ready() -> void:
	var fade_layer := CanvasLayer.new()
	fade_layer.layer = 100
	_fade_rect = ColorRect.new()
	_fade_rect.color = Color(0, 0, 0, 0)
	_fade_rect.anchor_right = 1.0
	_fade_rect.anchor_bottom = 1.0
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_layer.add_child(_fade_rect)
	# call_deferred: saat autoload _ready() jalan, tree root masih "busy
	# setting up children" (main scene sedang diinstansiasi bersamaan) —
	# add_child langsung gagal. Lihat obsidian-vault/Decisions Log.md 2026-11-20.
	get_tree().root.add_child.call_deferred(fade_layer)


## Pindah scene dengan fade hitam singkat. Debounce: panggilan beulang dalam
## 600ms diabaikan (cegah klik ganda cepat bikin navigasi dobel/nyasar).
func goto_scene(scene_path: String) -> void:
	var now := Time.get_ticks_msec()
	if _busy or now - _last_nav_time < _NAV_DEBOUNCE_MS:
		return
	_last_nav_time = now
	_busy = true

	var tree := get_tree()
	var tween := create_tween()
	tween.tween_property(_fade_rect, "color:a", 1.0, 0.15)
	tween.tween_callback(func(): tree.change_scene_to_file(scene_path))
	tween.tween_property(_fade_rect, "color:a", 0.0, 0.15)
	tween.tween_callback(func(): _busy = false)


func start_random_game() -> void:
	infinite_mode = true
	guided_mode = false
	_goto_random_game()


func start_specific_game(scene_path: String) -> void:
	infinite_mode = false
	guided_mode = false
	goto_scene(scene_path)


## Dipanggil dari tombol "Mulai main bareng" di `ParentGuide` — beda dari
## `start_specific_game` cuma soal `guided_mode`, supaya modul tujuan tahu
## harus render mekanik Bareng Orang Tua, bukan Mandiri.
func start_guided_game(scene_path: String) -> void:
	infinite_mode = false
	guided_mode = true
	goto_scene(scene_path)


func go_home() -> void:
	infinite_mode = false
	guided_mode = false
	goto_scene("res://scenes/Home.tscn")


## Dipanggil dari tombol "Lanjut" di StarRewardOverlay tiap mini-game,
## bukan langsung `go_home()` — supaya mode infinite bisa lempar ke game
## acak lain tanpa mampir ke Home dulu.
func finish_game_session() -> void:
	if infinite_mode:
		_goto_random_game()
	else:
		go_home()


func _goto_random_game() -> void:
	var pool: Array = GAMES.filter(func(g): return g["implemented"])
	if pool.is_empty():
		go_home()
		return
	var pick: Dictionary = pool[randi() % pool.size()]
	goto_scene(pick["scene"])

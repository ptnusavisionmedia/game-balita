extends Control
## Tap bebas nada — lihat obsidian-vault/Specs/feature_musik.md.
## SENGAJA tanpa soal benar/salah (beda dari modul lain) — musik usia 1-5
## tahun paling pas buat eksplorasi bebas, bukan dinilai tepat/tidaknya.

const TOTAL_TAPS_TO_FINISH := 8
const StarRewardOverlayScene := preload("res://core/scenes/StarRewardOverlay.tscn")

const _NOTE_COLORS := [
	Color("#B39DDB"), Color("#9575CD"), Color("#7E57C2"),
	Color("#D1C4E9"), Color("#8E7CC3"), Color("#A48AD4"),
]

## Bilah xilofon + nada asli (lihat docs/ASSET_LIST.md #10) — urutan
## do-re-mi-fa-sol-la, pasangan gambar/audio 1:1 sesuai README paket aset.
const _NOTE_IMAGES := [
	"res://features/feature_musik/assets/images/bilah_01_do.png",
	"res://features/feature_musik/assets/images/bilah_02_re.png",
	"res://features/feature_musik/assets/images/bilah_03_mi.png",
	"res://features/feature_musik/assets/images/bilah_04_fa.png",
	"res://features/feature_musik/assets/images/bilah_05_sol.png",
	"res://features/feature_musik/assets/images/bilah_06_la.png",
]
const _NOTE_SOUNDS := [
	"res://features/feature_musik/assets/audio/nada_01_do.wav",
	"res://features/feature_musik/assets/audio/nada_02_re.wav",
	"res://features/feature_musik/assets/audio/nada_03_mi.wav",
	"res://features/feature_musik/assets/audio/nada_04_fa.wav",
	"res://features/feature_musik/assets/audio/nada_05_sol.wav",
	"res://features/feature_musik/assets/audio/nada_06_la.wav",
]

var _tap_count: int = 0


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	add_child(GameBackground.new())

	var vbox := VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var title := Label.new()
	title.text = "Main Musik"
	title.add_theme_font_size_override("font_size", 34)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var notes_box := HBoxContainer.new()
	notes_box.alignment = BoxContainer.ALIGNMENT_CENTER
	notes_box.add_theme_constant_override("separation", 12)
	vbox.add_child(notes_box)

	for i in range(_NOTE_COLORS.size()):
		var button := BigRoundButton.new()
		button.accent_color = _NOTE_COLORS[i]
		if FileAccess.file_exists(_NOTE_IMAGES[i]):
			button.icon = load(_NOTE_IMAGES[i])
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 84)
		else:
			button.text = "♪"
		button.pressed.connect(_on_note_pressed.bind(i))
		notes_box.add_child(button)

	_add_home_button()


## Tombol darurat, selalu terlihat — pola wajib dari feature_angka.
func _add_home_button() -> void:
	var home_button := Button.new()
	_apply_home_icon(home_button)
	home_button.custom_minimum_size = Vector2(72, 72)
	home_button.anchor_left = 0.0
	home_button.anchor_right = 0.0
	home_button.offset_left = 8.0
	home_button.offset_right = 80.0
	home_button.offset_top = 12.0
	home_button.offset_bottom = 84.0
	home_button.pressed.connect(func(): GameFlow.go_home())
	add_child(home_button)


## Ikon rumah asli (lihat docs/ASSET_LIST.md #11) — fallback emoji kalau
## file belum ada. Dipakai 6 modul feature_* (duplikasi disengaja, pola
## sama `_add_home_button`, lihat komentarnya).
func _apply_home_icon(button: Button) -> void:
	var path := "res://core/assets/images/ui/home.png"
	if FileAccess.file_exists(path):
		button.icon = load(path)
		button.expand_icon = true
	else:
		button.text = "🏠"


## Tidak ada "benar/salah" di sini — tap mana pun selalu valid, cuma
## keluar nada + animasi. Lihat obsidian-vault/Specs/feature_musik.md.
func _on_note_pressed(note_index: int) -> void:
	var path: String = _NOTE_SOUNDS[note_index]
	SfxService.play(load(path) if FileAccess.file_exists(path) else null)
	_tap_count += 1
	if _tap_count >= TOTAL_TAPS_TO_FINISH:
		_show_reward()


func _show_reward() -> void:
	var overlay := StarRewardOverlayScene.instantiate()
	# stars_earned di sini TIDAK berarti "benar/salah" — cuma dipakai
	# ProgressRepository buat catat jumlah ketukan eksplorasi.
	overlay.stars_earned = _tap_count
	add_child(overlay)
	overlay.continued.connect(func():
		ProgressRepository.record_result("feature_musik", _tap_count)
		GameFlow.finish_game_session()
	)

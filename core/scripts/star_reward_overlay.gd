extends Control
class_name StarRewardOverlay
## Overlay perayaan singkat di akhir sesi mini-game: confetti + 1 ikon
## keberhasilan, lalu **otomatis** lanjut (tidak perlu tombol "Lanjut",
## tidak ada jumlah bintang/skor ditampilkan).
##
## Update 2026-11-20: sebelumnya ada baris bintang (★☆☆) + tombol "Lanjut"
## — user minta dihapus total, karena menampilkan "dapet berapa" tetap
## terasa seperti skor/grading (bentuk lain dari menang/kalah). Sekarang
## cuma perayaan + transisi otomatis, konsisten dengan prinsip #4
## docs/UI_UX_DESIGN.md ("tidak ada game over yang menghukum" — dan versi
## sebaliknya, tidak ada "menang" yang dikuantifikasi juga).
##
## `stars_earned` TETAP diterima lewat parameter (dipakai `ProgressRepository`
## buat data progres internal, calon fitur dashboard orang tua nanti) tapi
## **tidak pernah ditampilkan ke anak** di overlay ini.
##
## Confetti pakai `CPUParticles2D` bawaan Godot (particle system teruji),
## bukan animasi partikel buatan sendiri — lihat docs/LIBRARIES.md.

signal continued

const AUTO_CONTINUE_DELAY_SEC := 1.8

@export var stars_earned: int = 0


func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.4)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	add_child(backdrop)

	_spawn_confetti()

	# CenterContainer (bukan anchor 1-titik tanpa offset) supaya ikonnya
	# tidak kolaps ke size (0,0) — lihat bug yang sama di
	# parental_gate_dialog.gd, Decisions Log 2026-11-20.
	var center := CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	add_child(center)

	# Update 2026-11-22: pakai maskot "Wawa" pose merayakan (lihat
	# docs/ASSET_LIST.md #8) kalau filenya ada — fallback tanda ✓ polos
	# kalau belum. TETAP bukan skor/bintang, cuma ganti ikon perayaan.
	var mascot_path := "res://core/assets/images/mascot/wawa_merayakan.png"
	var icon: Control
	if FileAccess.file_exists(mascot_path):
		var mascot_icon := TextureRect.new()
		mascot_icon.texture = load(mascot_path)
		mascot_icon.custom_minimum_size = Vector2(220, 220)
		mascot_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		mascot_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		center.add_child(mascot_icon)
		icon = mascot_icon
	else:
		var checkmark := Label.new()
		checkmark.text = "✓"
		checkmark.add_theme_font_size_override("font_size", 96)
		checkmark.add_theme_color_override("font_color", AppColors.GOLD)
		center.add_child(checkmark)
		icon = checkmark

	var tween := create_tween()
	icon.scale = Vector2.ZERO
	tween.tween_property(icon, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(AUTO_CONTINUE_DELAY_SEC).timeout
	continued.emit()


func _spawn_confetti() -> void:
	var confetti := CPUParticles2D.new()
	add_child(confetti)
	confetti.position = Vector2(get_viewport_rect().size.x / 2.0, 0)
	confetti.amount = 60
	confetti.lifetime = 2.0
	confetti.one_shot = true
	confetti.explosiveness = 0.8
	confetti.direction = Vector2(0, 1)
	confetti.spread = 180
	confetti.gravity = Vector2(0, 300)
	confetti.initial_velocity_min = 100
	confetti.initial_velocity_max = 300
	confetti.color = AppColors.GOLD
	confetti.emitting = true

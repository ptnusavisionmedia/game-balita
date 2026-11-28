class_name UIStyle
extends RefCounted
## Helper styling untuk komponen GUI/HUD dari paket `Wawa_GUI_HUD_Pack.zip`
## (2026-11-22) — lihat docs/STYLE_GUIDE_GUI_HUD.md §2 untuk token ukuran
## (`icon.s`, `pill.action`) dan docs/ASSET_LIST.md untuk lokasi file.
##
## Ditaruh di `core/scripts/` (bukan `feature_*`) supaya aman dipakai
## lintas modul tanpa melanggar aturan "feature tidak boleh depend
## feature lain" di docs/ARCHITECTURE.md — sama posisinya dengan
## `AppColors`/`BigRoundButton`/`GameBackground`.

const PILL_ACTION_CREAM := "res://core/assets/images/gui/pill_action_cream.png"
const PILL_ACTION_ACCENT := "res://core/assets/images/gui/pill_action_accent.png"
const PILL_ACTION_SIZE := Vector2(280, 93)  # token `pill.action`, rasio 3:1

const CIRCLE_FRAME := "res://core/assets/images/gui/button_circle_neutral.png"
const ICON_S_SIZE := 88.0  # token `icon.s`


## Fix bug 2026-11-22: kalau cuma "font_color" yang di-override, tema
## default Godot tetap pakai font_hover_color sendiri (seringnya putih)
## — teks hilang begitu di-hover di atas background terang. Set semua
## state sekaligus. Dipindah dari `scenes/home.gd` (dulu method privat
## di sana) supaya dipakai ulang semua tombol pil, bukan cuma 2 tombol
## Home.
static func apply_ink_text_color(button: Button) -> void:
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, AppColors.INK)


## Pasang gaya "pill.action" (token 280x93, rasio 3:1) — pengganti
## tombol default Godot yang generik di "Kembali"/"Dengar Suaranya"/
## "Lihat Jawaban"/dll. `accent = true` pakai varian kuning (buat aksi
## yang perlu lebih menonjol). Fallback: kalau file belum ada, tombol
## tetap jalan normal (gaya default Godot), cuma tanpa gambar pil.
static func apply_pill_action(button: Button, accent: bool = false) -> void:
	button.custom_minimum_size = PILL_ACTION_SIZE
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	apply_ink_text_color(button)
	var texture_path := PILL_ACTION_ACCENT if accent else PILL_ACTION_CREAM
	if FileAccess.file_exists(texture_path):
		var style := StyleBoxTexture.new()
		style.texture = load(texture_path)
		for state in ["normal", "hover", "pressed", "focus"]:
			button.add_theme_stylebox_override(state, style)


## Pasang bingkai bulat netral (token `icon.s`, 88x88) di belakang tombol
## ikon (home darurat, gear settings, panah kembali, tutup dialog).
## Dipanggil SEBELUM set `button.icon`/`expand_icon` sendiri oleh caller
## (fungsi ini cuma urus background + ukuran, bukan ikonnya).
##
## Fix bug 2026-11-26 (dilaporkan user, screenshot GameModes): ikon panah
## kembali kelihatan "keluar dari lingkaran" — bukan `expand_icon`/
## `icon_max_width` (sudah benar), tapi default `Button.icon_alignment`
## Godot 4 adalah LEFT (bukan CENTER kayak teks), jadi tombol ikon-saja
## (tanpa teks) kegeser ikonnya ke sisi kiri area konten, bukan di
## tengah lingkaran — kelihatan jelas di ikon panjang (panah), nyaris
## tak kelihatan di ikon simetris (rumah/gear/centang) jadi lolos tanpa
## dilaporkan sebelumnya. Paksa CENTER di sini supaya semua tombol ikon
## bulat yang pakai helper ini otomatis kena fix-nya, bukan cuma panah.
static func apply_icon_frame(button: Button, diameter: float = ICON_S_SIZE) -> void:
	button.custom_minimum_size = Vector2(diameter, diameter)
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	if FileAccess.file_exists(CIRCLE_FRAME):
		var style := StyleBoxTexture.new()
		style.texture = load(CIRCLE_FRAME)
		for state in ["normal", "hover", "pressed", "focus"]:
			button.add_theme_stylebox_override(state, style)


## Fix bug class 2026-11-28 (dilaporkan user: "hitbox kadang sangat kecil,
## tidak pas"): child Control dekoratif (PanelContainer badge, TextureRect
## ikon, ModuleIcon custom-draw, dll) di DALAM sebuah Button composite
## punya `mouse_filter` default STOP — itu "menelan" klik SEBELUM event
## sempat jatuh ke Button induknya, bikin sebagian area visual kartu mati
## (tidak merespons tap), padahal ukuran tombolnya sendiri sudah benar.
## Panggil 1x di akhir tiap `_make_*_card`/`_make_*_tile` supaya SELURUH
## permukaan visual kartu ikut jadi hitbox, bukan cuma bagian yang
## kebetulan tidak tertutup child dekoratif.
static func make_fully_clickable(root: Control) -> void:
	for child in root.get_children():
		if child is Control and not child is BaseButton:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
			make_fully_clickable(child)


## Feedback tekan "juicy" ala game (bukan cuma ganti warna StyleBox
## seperti tombol web) — kartu/tombol mengecil sedikit saat ditekan,
## lalu lenting balik begitu dilepas. `pivot_offset` WAJIB di tengah
## supaya scale-nya memusat, bukan menarik dari pojok kiri-atas (kelihatan
## aneh/miring). Dipanggil setelah `custom_minimum_size` tombol fix.
static func add_press_bounce(button: Button) -> void:
	button.pivot_offset = button.custom_minimum_size / 2.0
	button.button_down.connect(func():
		var tween := button.create_tween()
		tween.tween_property(button, "scale", Vector2(0.94, 0.94), 0.08)
	)
	var _release := func():
		var tween := button.create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.12) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	button.button_up.connect(_release)
	button.mouse_exited.connect(_release)

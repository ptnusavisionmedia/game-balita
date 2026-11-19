extends Node
## Satu-satunya tempat baca/simpan progres anak (hasil tiap mini-game) dan
## setting suara. Autoload singleton (lihat [autoload] di project.godot),
## jadi bisa dipanggil `ProgressRepository.xxx()` dari script mana pun.
##
## Pakai `ConfigFile` bawaan Godot — tidak perlu plugin pihak ketiga, lihat
## docs/LIBRARIES.md.

const SAVE_PATH := "user://progress.cfg"

var sound_enabled: bool = true
var _results: Array = []  # Array[Dictionary]: {game_id, completed_at, stars_earned}


func _ready() -> void:
	_load()


func _load() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err != OK:
		return  # belum ada save sebelumnya, pakai default
	sound_enabled = cfg.get_value("settings", "sound_enabled", true)
	_results = cfg.get_value("results", "list", [])


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("settings", "sound_enabled", sound_enabled)
	cfg.set_value("results", "list", _results)
	cfg.save(SAVE_PATH)


func set_sound_enabled(value: bool) -> void:
	sound_enabled = value
	_save()


func record_result(game_id: String, stars_earned: int) -> void:
	_results.append({
		"game_id": game_id,
		"completed_at": Time.get_datetime_string_from_system(),
		"stars_earned": stars_earned,
	})
	_save()


## Hasil terakhir untuk 1 modul (misal "feature_angka"), dictionary kosong
## kalau modul itu belum pernah dimainkan.
func latest_result_for(game_id: String) -> Dictionary:
	for i in range(_results.size() - 1, -1, -1):
		if _results[i].get("game_id") == game_id:
			return _results[i]
	return {}

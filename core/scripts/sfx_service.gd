extends Node
## Efek suara pendek yang sering dipicu (tap/benar/coba-lagi). Autoload
## singleton. `AudioStreamPlayer` bawaan Godot sudah latensi rendah secara
## default — tidak perlu library pihak ketiga seperti `soundpool` di Flutter
## (lihat docs/LIBRARIES.md).
##
## Untuk musik/VO panjang, pakai [AudioService] (node terpisah), bukan ini.

var muted: bool = false

var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)


## `stream` boleh `null` kalau asset audio belum diproduksi Asset creator —
## otomatis no-op, tidak crash. Base model harus tetap bisa ditest tanpa
## audio final.
func play(stream: AudioStream) -> void:
	if muted or stream == null:
		return
	_player.stream = stream
	_player.play()

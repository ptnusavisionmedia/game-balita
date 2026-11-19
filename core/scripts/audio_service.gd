extends Node
## Musik latar / voice-over panjang. Autoload singleton, node terpisah dari
## [SfxService] supaya SFX pendek yang sering dipicu tidak motong musik yang
## sedang main.

var muted: bool = false

var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)


## Catatan: pengaturan loop musik tergantung format file (diatur di properti
## import asset-nya di Godot Editor, bukan di sini) — lihat dokumentasi Godot
## untuk AudioStreamWAV/OggVorbis loop mode kalau musik latar perlu diulang.
func play(stream: AudioStream) -> void:
	if muted or stream == null:
		return
	_player.stream = stream
	_player.play()


func stop() -> void:
	_player.stop()

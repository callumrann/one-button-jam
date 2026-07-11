extends Node

@onready var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()

'''
const SFX := {
    "deflect": preload("res://assets/audio/deflect.mp3"),
    "jump": preload("res://assets/audio/jump.wav"),
    "land": preload("res://assets/audio/land.wav"),
    "death": preload("res://assets/audio/death.wav"),
}
'''

const MUSIC := {
	#"menu": preload("res://assets/audio/terrible.wav"),
	"in_game": preload("res://assets/audio/Gaming_Song_1.wav"),
}

func _ready() -> void:
	add_child(bgm_player)
	bgm_player.bus = "Music"
	
	play_music(MUSIC["in_game"])

func play_music(audio_stream: AudioStream, volume: float = 0.0) -> void:
	
	bgm_player.stream = audio_stream
	bgm_player.volume_db = volume
	bgm_player.play()

func stop_music() -> void:
	bgm_player.stop()

func play_sfx(audio_stream: AudioStream, volume: float = 0.0) -> void:
	if not audio_stream:
		return
	
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = audio_stream
	sfx_player.volume_db = volume
	sfx_player.bus = "SFX"
	
	add_child(sfx_player)
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)

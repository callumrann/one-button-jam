extends Node2D

const ROCK_SCENE: PackedScene = preload("res://scenes/objects/falling_rock.tscn")
const SCREEN_WIDTH: float = 320 # remember to change if change screen size
const SCREEN_HEIGHT: float = 180

var spawn_timer: float = 0.0
var next_spawn_time: float = 0.0

var theme: String = "ffffff"

func _ready() -> void:
	_reset_timer()

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer > next_spawn_time:
		spawn_timer = 0.0
		_spawn_rock()
		_reset_timer()

func set_theme(hex: String) -> void:
	theme = hex

func _reset_timer() -> void:
	next_spawn_time = randf_range(0.5, 5.0)

func _spawn_rock() -> void:
	var rock: Sprite2D = ROCK_SCENE.instantiate()
	rock.position = Vector2(randf_range(-SCREEN_WIDTH/2, SCREEN_WIDTH/2), -SCREEN_HEIGHT/2 - 30)
	rock.modulate = Color(theme)
	add_child(rock)

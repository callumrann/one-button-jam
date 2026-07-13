extends Area2D

const SCREEN_WIDTH: float = 320 # remember to change if change screen size
const SCREEN_HEIGHT: float = 180

var tween: Tween

@export var moves: bool = false
@export var start_size: int
@export var end_size: int
@export var move_duration: float = 1.5

@export var wait_time: float = 5.0
@export var loop: bool = false

func _ready() -> void:
	if moves:
		_start_moving()

func _start_moving() -> void:
	tween = create_tween()
	tween.tween_interval(wait_time)
	var mid_size: float = lerp(float(start_size), float(end_size), 0.40) # percent through speed up
	tween.tween_property(self, "scale:y", mid_size, move_duration * 0.6)
	tween.tween_property(self, "scale:y", end_size, move_duration * 0.4)

func reset_state() -> void:
	if tween:
		tween.kill()
	scale.y = start_size
	if moves:
		_start_moving()

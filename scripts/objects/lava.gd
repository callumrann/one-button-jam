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
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(wait_time)
	tween.tween_property(self, "scale:y", end_size, move_duration)
	if loop:
		tween.tween_interval(wait_time)
		tween.tween_property(self, "scale:y", start_size, move_duration)
		tween.tween_interval(wait_time)
		tween.set_loops()

func reset_state() -> void:
	if tween:
		tween.kill()
	scale.y = start_size
	if moves:
		_start_moving()

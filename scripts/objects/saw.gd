extends Area2D

var tween: Tween

@export var moves: bool = false
@export var point_a: Vector2
@export var point_b: Vector2
@export var move_duration: float = 1.5
@export var delay: float = 0.0

func _ready() -> void:
	point_a = position + point_a
	point_b = position + point_b
	if moves:
		await get_tree().create_timer(delay).timeout
		_start_moving()

func _start_moving() -> void:
	tween = create_tween()
	
	tween.set_loops()  # loop forever
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "position", point_b, move_duration)
	tween.tween_property(self, "position", point_a, move_duration)

func reset_state() -> void:
	if tween:
		tween.kill()
	position = point_a
	if moves:
		await get_tree().create_timer(delay).timeout
		_start_moving()

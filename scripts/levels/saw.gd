extends Area2D

@export var moves: bool = false
@export var point_a: Vector2
@export var point_b: Vector2
@export var move_duration: float = 1.5

func _ready() -> void:
	point_a = position + point_a
	point_b = position + point_b
	if moves:
		_start_moving()

func _start_moving() -> void:
	var tween := create_tween()
	tween.set_loops()  # loop forever
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", point_b, move_duration)
	tween.tween_property(self, "position", point_a, move_duration)

# first tween from center of path  might act differently? no trans sine applied?

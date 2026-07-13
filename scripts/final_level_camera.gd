extends Camera2D

@export var delay: float = 4.0
@export var speed: float = 10.0
@export var final_height: float = 0.0

var timer: float = 0.0
var original_position: Vector2

func _ready() -> void:
	timer = delay
	original_position = position

func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		if position.y > final_height:
			position.y -= speed * delta
		else:
			position.y = final_height

func reset_state() -> void:
	timer = delay
	position = original_position

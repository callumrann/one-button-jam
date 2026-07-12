extends Sprite2D

var fall_speed: float
var rotate_speed: float

func _ready() -> void:
	fall_speed = randf_range(10, 50)
	rotate_speed = randf_range(-15, 15)

func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	if randi_range(0, 2): # 2/3 pass
		rotation += rotate_speed * delta

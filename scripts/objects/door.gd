extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $"CollisionShape2D"
@onready var sprite: Sprite2D = $"Sprite2D"

var dim: Color = Color(1,1,1,0)

func open() -> void:
	collision_shape.set_deferred("disabled", true)
	sprite.modulate = dim

func reset_state() -> void:
	collision_shape.set_deferred("disabled", false)
	sprite.modulate = Color(1,1,1,1)

extends Area2D

@export var target_door: Node2D

@onready var animation: AnimatedSprite2D = $"AnimatedSprite2D"
	
func reset_state() -> void:
	animation.play("up")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("check")
		target_door.open()
		animation.play("down")

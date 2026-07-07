extends CharacterBody2D


const MOVEMENT_SPEED = 300.0
const JUMP_VELOCITY = -400.0

const LEFT: int = -1
const RIGHT: int = 1

var direction: int = RIGHT


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # gravity changed in project settings

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = direction * MOVEMENT_SPEED

	move_and_slide()

extends CharacterBody2D

signal kill_player
signal endzone_reached

const MOVEMENT_SPEED: float = 100.0
const JUMP_VELOCITY: float = -225.0
const JUMP_CUT_MULTIPLIER: float = 0.5
const SPEEDFALL_VELOCITY: float = 200.0

const LEFT: int = -1
const RIGHT: int = 1

const ENEMY_LAYER: int = 2
const ENDZONE_LAYER: int = 3

var direction: int = RIGHT

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # gravity changed in project settings

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		elif is_on_wall(): # consider no else
			var wall_normal_x: float = get_wall_normal().x
			if wall_normal_x < 0 and direction == RIGHT: # == RIGHT avoids double detection <- not necessary?
				direction = LEFT
			if wall_normal_x > 0 and direction == LEFT:
				direction = RIGHT
			velocity.y = JUMP_VELOCITY
		
		else:
			velocity.y = SPEEDFALL_VELOCITY
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	velocity.x = direction * MOVEMENT_SPEED

	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer & (1 << (ENEMY_LAYER - 1)):
		kill_player.emit()
	elif area.collision_layer & (1 << (ENDZONE_LAYER - 1)):
		endzone_reached.emit()

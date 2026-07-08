extends CharacterBody2D

@onready var spawn: Marker2D = $"../Spawn"

const MOVEMENT_SPEED = 300.0
const JUMP_VELOCITY = -400.0

const LEFT: int = -1
const RIGHT: int = 1

const ENEMY_LAYER: int = 2
const ENDZONE_LAYER: int = 3

var direction: int = RIGHT

func _ready() -> void:
	position = spawn.position

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

	velocity.x = direction * MOVEMENT_SPEED

	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer & (1 << (ENEMY_LAYER - 1)):
		position = spawn.position
	elif area.collision_layer & (1 << (ENDZONE_LAYER - 1)):
		print("endzone")

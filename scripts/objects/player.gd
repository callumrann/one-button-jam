extends CharacterBody2D

'''
====== Movement ======
'''
const MOVEMENT_SPEED: float = 100.0
const JUMP_VELOCITY: float = -250.0
const JUMP_CUT_MULTIPLIER: float = 0.5
const SPEEDFALL_VELOCITY: float = 200.0

const JUMP_BUFFER_TIME: float = 0.05
var jump_buffer_timer: float = 0.0

const LEFT: int = -1
const RIGHT: int = 1

const ENEMY_LAYER: int = 2
const ENDZONE_LAYER: int = 3

var direction: int = RIGHT

var movement_multiplier: float = 0.5
const WATER_MAX_FALL_SPEED: float = 100.0
var in_water: bool = false

func _physics_process(delta: float) -> void:
	if respawning:
		velocity.y = -100
		move_and_slide()
		return
	
	if in_water:
		movement_multiplier = 0.5
	else:
		movement_multiplier = 1.0
	
	if not is_on_floor():
		velocity += get_gravity() * delta * movement_multiplier
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	if Input.is_action_just_pressed("jump"):		
		if is_on_floor() or (in_water and not is_on_wall()):
			AudioManager.play_sfx("jump", -5)
			velocity.y = JUMP_VELOCITY * movement_multiplier

		elif is_on_wall(): # consider no else
			var wall_normal_x: float = get_wall_normal().x
			if wall_normal_x < 0 and direction == RIGHT: # == RIGHT avoids double detection <- not necessary?
				direction = LEFT
			if wall_normal_x > 0 and direction == LEFT:
				direction = RIGHT
			velocity.y = JUMP_VELOCITY * movement_multiplier
			AudioManager.play_sfx("wall_jump", -15)
		
		else:
			velocity.y = SPEEDFALL_VELOCITY
			jump_buffer_timer = JUMP_BUFFER_TIME
	
	if is_on_floor() and jump_buffer_timer > 0.0:
		velocity.y = JUMP_VELOCITY * movement_multiplier
		jump_buffer_timer = 0.0
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER
	
	velocity.x = direction * MOVEMENT_SPEED * movement_multiplier
	
	if in_water and velocity.y > WATER_MAX_FALL_SPEED:
		velocity.y = WATER_MAX_FALL_SPEED
	move_and_slide()

'''
====== Animations ======
'''
@onready var animationBody: AnimatedSprite2D = $"AnimatedBody"
@onready var animationEyes: AnimatedSprite2D = $"AnimatedEyes"

var in_air: bool = false

func _ready() -> void:
	animationBody.animation_finished.connect(_on_animation_finished)
	velocity.y = -80 # match respawn jump (number hardcoded)

func _play_animation(name: String) -> void:
	animationBody.play(name)
	animationEyes.play(name)

func _on_animation_finished():
	if animationBody.animation == "hit_ground_1":
		_play_animation("hit_ground_2")
	
	elif animationBody.animation == "hit_ground_2":
		_play_animation("run")

func _process(_delta: float) -> void:
	if velocity.x < 0:
		animationBody.flip_h = true
		animationEyes.flip_h = true
	elif velocity.x > 0:
		animationBody.flip_h = false
		animationEyes.flip_h = false
	
	if is_on_floor():
		if in_air:
			in_air = false
			_play_animation("hit_ground_1")
			AudioManager.play_sfx("land", -8)
		
	else:
		in_air = true
		if is_on_wall():
			_play_animation("hit_wall")
		elif velocity.y < 0:
			_play_animation("jump")
		elif velocity.y > 0:
			_play_animation("fall")
		

'''
====== Hurtbox Collision ======
'''
signal kill_player
signal endzone_reached

var respawning: bool = false
@onready var wall_collider: CollisionShape2D = $"WallCollider"
@onready var area: Area2D = $"Hurtbox"

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer & (1 << (ENEMY_LAYER - 1)):
		kill_player.emit()
	elif area.collision_layer & (1 << (ENDZONE_LAYER - 1)):
		endzone_reached.emit()
	
	if area.name == "PlayerCheck" and is_on_floor():
			print("check")
			move_and_slide()

# join above down if find a way to access tilemap collision layer
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_class() == "TileMapLayer":
		if body.name == "Foreground":
			kill_player.emit()
		if body.name == "Water":
			in_water = true

func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.get_class() == "TileMapLayer":
		if body.name == "Water":
			in_water = false

func await_respawn() -> void:
	respawning = true
	wall_collider.set_deferred("disabled", true)
	area.set_deferred("monitoring", false) # no double death
	velocity = Vector2.ZERO

func respawned() -> void:
	wall_collider.disabled = false
	area.monitoring = true
	respawning = false
	

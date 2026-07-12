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

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta # gravity changed in project settings
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			AudioManager.play_sfx("jump", -5)
			velocity.y = JUMP_VELOCITY

		elif is_on_wall(): # consider no else
			var wall_normal_x: float = get_wall_normal().x
			if wall_normal_x < 0 and direction == RIGHT: # == RIGHT avoids double detection <- not necessary?
				direction = LEFT
			if wall_normal_x > 0 and direction == LEFT:
				direction = RIGHT
			velocity.y = JUMP_VELOCITY
			AudioManager.play_sfx("wall_jump", -15)
		
		else:
			velocity.y = SPEEDFALL_VELOCITY
			jump_buffer_timer = JUMP_BUFFER_TIME
	
	if is_on_floor() and jump_buffer_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	velocity.x = direction * MOVEMENT_SPEED

	move_and_slide()

'''
====== Animations ======
'''
@onready var animationBody: AnimatedSprite2D = $"AnimatedBody"
@onready var animationEyes: AnimatedSprite2D = $"AnimatedEyes"

var in_air: bool = false
var first_ground_hit: bool = true # for removing spawn ground hit issues

func _ready() -> void:
	animationBody.animation_finished.connect(_on_animation_finished)

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
		if first_ground_hit:
			first_ground_hit = false
			in_air = false
			_play_animation("run")
		elif in_air:
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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer & (1 << (ENEMY_LAYER - 1)):
		kill_player.emit()
	elif area.collision_layer & (1 << (ENDZONE_LAYER - 1)):
		endzone_reached.emit()

# join above down if find a way to access tilemap collision layer
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_class() == "TileMapLayer":
		kill_player.emit()

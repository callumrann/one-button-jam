extends Node2D

@onready var solid_shape: CollisionShape2D = $"Fallable/StaticBody2D/CollisionShape2D"
@onready var detection: CollisionShape2D = $"Fallable/Area2D/CollisionShape2D"
@onready var player_check: CollisionShape2D = $"PlayerCheck/CollisionShape2D"

@onready var fallable: Node2D = $"Fallable"
@onready var animation: AnimatedSprite2D = $"Fallable/AnimatedSprite2D"

const FALL_SPEED: float = 100.0
const DELAY_TIME: float = 1.0
const FALL_TIME: float = 0.5

var triggered: bool = false
var falling: bool = false

var shake_intensity: float = 1.0

var original_position: Vector2
var original_colour: Color # set in level manager

var current_tween: Tween

func _ready() -> void:
	original_position = fallable.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if triggered:
		return
	
	if body.name == "Player":
		triggered = true
		animation.play("broken")
		await _shake()
		falling = true
		solid_shape.disabled = true
		detection.disabled = true
		_start_falling()

func _shake():
	current_tween = create_tween()
	var steps: int = 6
	var step_time := DELAY_TIME / steps / 2.0
	current_tween.set_loops(steps)
	current_tween.tween_property(fallable, "position", original_position + Vector2(shake_intensity, 0), step_time)
	current_tween.tween_property(fallable, "position", original_position - Vector2(shake_intensity, 0), step_time)
	await current_tween.finished

func _start_falling() -> void:
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate", Color(1,1,1,0), FALL_TIME)
	current_tween.finished.connect(_fall_finished)

func _physics_process(delta: float) -> void:
	if falling:
		fallable.position.y += FALL_SPEED * delta

func _fall_finished() -> void:
	falling = false
	animation.play("together")
	fallable.position = original_position
	
	while player_inside:
		await get_tree().physics_frame
	
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate", original_colour, FALL_TIME)
	
	solid_shape.disabled = false
	detection.disabled = false
	triggered = false

var player_inside: bool = false
func _on_player_check_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = true
	

func _on_player_check_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = false

func reset_state() -> void:
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	falling = false
	animation.play("together")
	fallable.position = original_position
	
	modulate = original_colour
	
	solid_shape.disabled = false
	detection.disabled = false
	triggered = false

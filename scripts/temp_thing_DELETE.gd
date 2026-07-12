extends TileMapLayer

var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	if player == null:
		player = $"../../Player"
	else:
		position.x += player.velocity.normalized().x * delta

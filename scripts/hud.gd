extends CanvasLayer

@onready var timer_label: Label = $"TimeLabel"
@onready var death_label: Label = $"DeathsLabel"

func _process(_delta: float) -> void:
	timer_label.text = "Time: %.2f" % LevelManager.level_time
	death_label.text = "Deaths: %d" % LevelManager.level_deaths

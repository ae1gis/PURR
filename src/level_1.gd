extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_name = self.name
	$LevelDebug/LevelName.text = level_name

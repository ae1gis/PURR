extends Area2D

@export var level_number = 1
var level_name := "res://scenes/level_" + str(level_number + 1) + ".tscn"

func _on_body_entered(body: Node2D) -> void:
	var current_level := get_parent().name
	
	if body.name == "PlayerKitty":
		print("Level checkpoint reached\n")
		$CanvasLayer.show()
		$CanvasLayer/TimeUntilTransition.start()

func transition_to_level(level_name: String) -> void:
	if get_tree().change_scene_to_file(level_name) != ERR_CANT_OPEN:
		pass
	else:
		print("Error: " + level_name + " does not exist\n")

func _on_time_until_transition_timeout() -> void:
	if get_tree().change_scene_to_file(level_name) != ERR_CANT_OPEN:
		pass
	else:
		$CanvasLayer.hide()
		print("Error: " + level_name + " does not exist\n")

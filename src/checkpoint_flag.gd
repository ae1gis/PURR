extends Area2D

@export var level_number = 1

func _on_body_entered(body: Node2D) -> void:
	var current_level := get_parent().name
	
	if body.name == "PlayerKitty":
		print("Level checkpoint reached\n")
		get_tree().change_scene_to_file("res://scenes/level_" + str(level_number + 1) + ".tscn")

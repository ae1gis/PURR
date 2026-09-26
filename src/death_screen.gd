extends Control

func _on_respawn_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

extends Control

func _on_level_intermission_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")

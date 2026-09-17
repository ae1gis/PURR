extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("kill zone triggered by " + str(body))
		get_tree().change_scene_to_file("res://scenes/dead.tscn")

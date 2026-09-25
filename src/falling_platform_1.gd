extends RigidBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(str(body.name, body))
	if body.name == "PlayerKitty":
		$TimeUntilFall.start()

func _on_time_until_fall_timeout() -> void:
	freeze = false

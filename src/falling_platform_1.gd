extends RigidBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "PlayerKitty":
		print("Player made contact with " + self.name + "\n")
		$TimeUntilFall.start()

func _on_time_until_fall_timeout() -> void:
	freeze = false

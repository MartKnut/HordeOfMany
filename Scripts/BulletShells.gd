extends AnimatedSprite2D



func initialize(start_position):
	position.x = start_position


func _on_animation_finished():
	queue_free()

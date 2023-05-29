extends Area2D

func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(global_position)
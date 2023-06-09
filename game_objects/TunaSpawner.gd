extends Node

var objectScene = preload("res://characters/Yokotuna.tscn") 
var tunas = 1

func _on_timer_timeout():
	for i in range(round(tunas)):
		spawn_tuna()
	tunas += 0.25

func spawn_tuna():
	print("Spawn Tuna")
	var spawnPosition = Vector2(randf_range(-180,180), randf_range(-180,180))

	var objectInstance = objectScene.instantiate()

	# Set the position of the object
	objectInstance.global_position = spawnPosition
	objectInstance.tar_group = "Yoko"
	objectInstance.get_node("Slash").attack_damage = 5
	objectInstance.get_node("Slash").knockback_force = 10000
	objectInstance.get_node("Slash").attack_time = 5
	objectInstance.verbosity = false
	
	var nodesToFree = ["Teleport", "RockThrow", "Dash"]
	for nodeName in nodesToFree:
		if objectInstance.has_node(nodeName):
			var node = objectInstance.get_node(nodeName)
			node.queue_free()


	objectInstance.modulate = Color(1, 0, 0)

	# Set Group
	objectInstance.add_to_group("Chest")

	# Add the object to the scene
	get_parent().add_child(objectInstance)

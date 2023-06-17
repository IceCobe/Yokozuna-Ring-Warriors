extends Node

var parent_node: Node = null # Initializing parent_node

var teleport_range:= 50
var teleport_ready:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_node = get_parent() # Setting the parent_node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if parent_node.target_is_enemy and parent_node.get_node("Slash").slash_ready:
		teleport()

func _on_timer_timeout():
	teleport_ready = true
	if parent_node.verbosity:
		print("Ready to teleport")

func teleport():
	if $Timer.is_stopped():
		create_particle($StartParticles)
		
		var maxTeleportDistance = min(teleport_range, parent_node.distance_to_target)
		var teleportVector = parent_node.target_direction * maxTeleportDistance
		parent_node.global_position += teleportVector
		parent_node.apply_central_impulse(25000*parent_node.target_direction)
	
		create_particle($EndParticles)
		
		teleport_ready = false
		$Timer.start()

func teleport_away():
	if $Timer.is_stopped():
		create_particle($StartParticles)

		var teleport_direction = (Vector2(0, 0) - parent_node.global_position).normalized()
		var distance_to_center = parent_node.global_position.distance_to(Vector2(0, 0))
		var max_teleport_distance = min(teleport_range, distance_to_center)
		var teleport_position = parent_node.global_position + teleport_direction * max_teleport_distance
		parent_node.global_position = teleport_position
		
		parent_node.apply_central_impulse(25000 * teleport_direction)
	
		create_particle($EndParticles)
		
		teleport_ready = false
		$Timer.start()

func create_particle(particle):
	particle.global_position = parent_node.global_position
	particle.emitting = true

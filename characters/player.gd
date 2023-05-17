extends CharacterBody2D

@export var move_speed : float = 100
@export var start_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(start_direction)

func _physics_process(_delta):
	# get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	update_animation_parameters(input_direction)

	# update velocity
	velocity = input_direction * move_speed
	
	# Flip the sprite horizontally
	if input_direction.x < 0:
		$Sprite2D.scale.x = -1
	elif input_direction.x > 0:
		$Sprite2D.scale.x = 1
		
	# move and slide function uses velocity of hcaracter bodyto move character on map
	move_and_slide()
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	# Don't change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walking/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walking")
	else:
		state_machine.travel("idle")

extends State

export(NodePath) var moving_state_path
export(NodePath) var air_state_path
export(NodePath) var attack_state_path

onready var moving_state = get_node(moving_state_path)
onready var air_state = get_node(air_state_path)
onready var attack_state = get_node(attack_state_path)

func on_enter():
	if character.jump_buffered:
		character.jump()
		next_state = air_state

	animation_node.travel("idle")

func state_process(delta):
	if character.velocity.x != 0: #maybe move this block of code to a "slowing_down" state
		character.desaccelerate(delta)
	
	if (character.direction.x != 0):
		next_state = moving_state

func state_input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		character.jump()
		next_state = air_state
		
	if event.is_action_pressed("ui_up"):
		print("up")
		next_state = attack_state

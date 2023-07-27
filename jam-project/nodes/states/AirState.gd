extends State

export(NodePath) var moving_state_path
export(NodePath) var idle_state_path
export(int) var max_air_jumps = 1

onready var moving_state = get_node(moving_state_path)
onready var idle_state = get_node(idle_state_path)

var extra_jumps_made = 0
var exiting_message

func on_enter():
	extra_jumps_made = 0
	character.jump_buffered = false
	animation_node.travel("jumping")

func buffer_jump():
	character.jump_buffered = true
	
func state_process(delta):
	# add custom speeds for air movements
	if character.direction.x != 0:
		character.accelerate(delta)
		
	elif character.direction.x == 0:
		character.desaccelerate(delta)

	if character.is_on_floor():
		next_state = idle_state if character.direction.x == 0 else moving_state

func state_input(event : InputEvent):
	if event.is_action_pressed("ui_accept") and extra_jumps_made < max_air_jumps:
		extra_jumps_made += 1
		animation_node.travel("air_spin")
		character.jump()
	
	elif event.is_action_pressed("ui_accept") and extra_jumps_made == max_air_jumps:
		character.buffer_jump()

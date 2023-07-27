extends State

### State NodePaths ###
export(NodePath) var idle_state_path
export(NodePath) var air_state_path

onready var idle_state = get_node(idle_state_path)
onready var air_state = get_node(air_state_path)

### State Variables ###

export(float) var coyote_time = 0.1

var on_coyote_time = false
var was_in_coyote = false

func on_enter():
	if character.jump_buffered:
		character.jump()
		next_state = air_state
	animation_node.travel("running")
	was_in_coyote = false

func run_coyote_time():
	if !on_coyote_time and !was_in_coyote:
		on_coyote_time = true
		yield(get_tree().create_timer(coyote_time), "timeout")
		on_coyote_time = false
		was_in_coyote = true
		
func state_process(delta):
	if character.direction.x == 0:
		next_state = idle_state
	
	if !character.is_on_floor():
		run_coyote_time()
	
	if !character.is_on_floor() and was_in_coyote:
		next_state = air_state
		
		# add jump state
	else:
		character.accelerate(delta)
		
# set gravity on player, evaluate which other variable should be alocated outside this state
func state_input(event : InputEvent):
	
	if event.is_action_pressed("ui_accept"):
		
		if character.is_on_floor() or on_coyote_time:
			character.jump()
			next_state = air_state


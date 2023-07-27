extends Node
class_name CharacterStateMachine

export(NodePath) var character_path
export(NodePath) var animation_tree_path

var states = []
onready var current_state : State = $Idle

func _ready():
	var character = get_node(character_path)
	var animation_tree = get_node(animation_tree_path)
	
	for child in get_children():
		print(child)
		if child is State:
			child.character = character
			child.animation_tree = animation_tree
			child.animation_node = animation_tree.get("parameters/playback")
			states.append(child)
			
		else:
			push_warning("%s is not a State Object!" % child)

func switch_states(new_state : State):
	var message
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		current_state = new_state
		current_state.on_enter()
		

func _physics_process(delta): #update
	if (current_state.next_state != null):
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)
		# otherwise if we executed _physics 
	# process indepently in each state we would 
	# have multiple update functions running at the same 
	# time since the nodes are instanced since the begining
	
func _input(event):
	current_state.state_input(event)


extends KinematicBody2D

var direction : Vector2 = Vector2(0, 1)
var velocity : Vector2 = Vector2.ZERO
var last_direction : int

export(int) var max_speed = 500
export(float) var t_max_speed = 0.5
export(float) var t_stop = 0.1
export(int) var max_jump_height = 175
export(float) var t_max_height = 0.5

onready var h_acceleration : float = (max_speed / t_max_speed)
onready var h_friction : float = (max_speed/ t_stop)
onready var jump_velocity = (2 * max_jump_height) / t_max_height * -1
onready var jump_gravity = (2 * max_jump_height) / pow(t_max_height, 2)
var current_gravity : float = 0
var jump_buffered = false

func _ready():
	$AnimationTree.get("parameters/playback").start("idle")
	current_gravity = jump_gravity

func buffer_jump():
	jump_buffered = true
	yield(get_tree().create_timer(0.25), "timeout")
	jump_buffered = false
	
func update_input():
	direction.x = (
		Input.get_action_strength("ui_right") 
		- Input.get_action_strength("ui_left")
	)

func update_sprite_flip():
	#var h_flip = $Sprite.get("flip_h")
	$Sprite.flip_h = false if last_direction > 0 else true
	
func accelerate(delta):
	# reduce speed for faster turning
	if sign(velocity.x) != direction.x:
		velocity.x /= 2
		
	velocity.x += h_acceleration * direction.x * delta
	
	if abs(velocity.x) >= max_speed:
		velocity.x = max_speed * direction.x

func desaccelerate(delta):
	velocity.x -= (velocity.x / t_stop) * delta

	if abs(velocity.x) < 5:
		velocity.x = 0
		
func jump():
	velocity.y = jump_velocity
	
func apply_gravity(delta):
	velocity.y += current_gravity * delta
	velocity.y = min(velocity.y, 1500) # avoid gaining masive speed when falling
	
func _physics_process(delta):
	update_input()
	if direction.x != 0:
		last_direction = direction.x
	apply_gravity(delta)
	update_sprite_flip()
	velocity = move_and_slide(velocity, Vector2.UP) # reassign to remove excess velocity.

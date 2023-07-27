extends Node
class_name State

export var can_move : bool = true
export var can_turn : bool = true

var character : KinematicBody2D
var animation_tree : AnimationTree # used for changing blend positions
var animation_node : AnimationNodeStateMachinePlayback
var next_state : State

func state_process(_delta): #update
	pass

func state_input(_event : InputEvent): #hadle input
	pass

func on_enter():
	pass

func on_exit():
	pass

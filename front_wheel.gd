extends RigidBody2D

@export var max_speed: int = 500
var speed: int = max_speed
#
#func _process(_delta):
	##if Input.is_action_pressed("turn_left"):
		##rotation -= 1
		##
	##if Input.is_action_pressed("turn_right"):
		##rotation += 1

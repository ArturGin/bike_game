extends Node2D

@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var player = $gamer
@onready var outer_car = $outer_car

func get_path_direction(pos):
	#var offset = path.curve.get_closest_offset(pos)
	#path_follow.h_offset = offset
	
	return player.position

extends Node

@export var max_hearts = 5
var current_hearts = 3

func reduce_heart():
	current_hearts -= 1
	if current_hearts<=0:
		print("game over Game manager sc")

extends Path2D

@export var timer = 0
@export var spawn_time = 3
@onready var path_follow = $PathFollow2D2

var enemy_slime_prefab = preload("res://prefabs/Enemies/enemy_wolf.tscn")

func _process(delta):
	timer += delta
	
	if timer >= spawn_time: 
		spawn_enemy()
		timer = 0.0
		

func spawn_enemy():
	var new_enemy = enemy_slime_prefab.instantiate() 
	add_child(new_enemy) #add new enemy to path with pathfollow2D

extends Path2D

@export var timer = 0
@export var spawnTime = 3

var enemy_slime_prefab = preload("res://prefabs/level1_enemyPath.tscn")

func _process(delta):
	timer += delta
	
	if timer >= spawnTime: 
		var new_enemy = enemy_slime_prefab.instantiate() 
		add_child(new_enemy) #add new enemy to path with pathfollow2D
		timer = 0.0 #rest timer
		

extends Path2D


@export var timer = 0
@export var spawnTime = 3

var enemyPrefab = preload("res://level1_enemyPath.tscn")

func _process(delta):
	timer += delta
	
	if timer >= spawnTime: 
		var newEnemy = enemyPrefab.instantiate() 
		add_child(newEnemy) #add new enemy to path 
		timer = 0.0
		

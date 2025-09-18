extends Path2D
class_name SpawnManager
# --------------Spawner Stats----------------
@export var timer = 0
@export var spawn_time = 3

# --------------Node References----------------
@onready var path_follow = $PathFollow2D2

# --------------Prefabs----------------
var enemy_slime_prefab = preload("res://prefabs/Enemies/enemy_wolf.tscn")

# --------------Core Loop----------------
func _process(delta):
	timer += delta
	
	if timer >= spawn_time: 
		spawn_enemy()
		timer = 0.0

# --------------Enemy Spawn Logic----------------
func spawn_enemy():
	var new_enemy = enemy_slime_prefab.instantiate() 
	add_child(new_enemy) #add new enemy to path with pathfollow2D

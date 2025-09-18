extends Node2D
class_name ArrowManager

@onready var arrow_sprite: Sprite2D = get_node_or_null("Arrow_sprite")

var direction
var speed = 1300 #arrow speed 
var damage

func arrowSetup(dir, dam) -> void: 
	direction = dir
	damage = dam
	rotation = direction.angle() - PI/2 #apply rotation to the arrow 
	
func _process(delta: float) -> void:
	position += direction * delta * speed

func _on_area_2d_enemy_hit_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy.has_method("takeDamage"): #check if the parent of area2D has the enemy script
			enemy.takeDamage(damage) #damage enemy 
		queue_free() #delete arrow prefab after

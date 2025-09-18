extends Node2D
class_name ArrowManager
# --------------Arrow Stats----------------
var target = null
var speed = 1300 #arrow speed 
var damage

# --------------Node References----------------
@onready var arrow_sprite: Sprite2D = get_node_or_null("Arrow_sprite")

# --------------Arrow Setup----------------
func arrowSetup(enemy, dam) -> void: 
	target = enemy
	damage = dam

# --------------Core Loop----------------
func _process(delta: float) -> void:
	distance_rotation_calc(delta)

# --------------Movement / Rotation----------------
func distance_rotation_calc(delta):
	if target and target.is_inside_tree() and not target.is_queued_for_deletion(): #make sure the arrow has a valid enemy to follow
		var direc_vec = (target.global_position - global_position).normalized()
		position += direc_vec * speed * delta
		rotation = direc_vec.angle() - PI/2 # apply rotation so the arrow matches enemy

# --------------Collision / Damage----------------
func _on_area_2d_enemy_hit_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and target:
		var enemy = area.get_parent()
		if enemy.has_method("takeDamage"): #check if the parent of area2D has the enemy script
			enemy.takeDamage(damage) #damage enemy using their method
		queue_free() #delete arrow prefab after

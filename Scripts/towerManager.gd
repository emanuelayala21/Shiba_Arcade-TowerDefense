class_name TowerManager
extends Node2D

# --------------Tower Stats----------------
@export var cadence: float = 2
@export var damage: float = 20.0
@export var range: float = 30.0
@export var current_tower_level: int = 0
@export var next_price: int = 10

# --------------Runtime Variables----------------
var time_cadence = 0.0
var enemies_in_range: Array = []
var pending_shot_targe = null 
var arrow_prefab = preload("res://prefabs/arrow.tscn")

# -------------Node References-----------------
@onready var upgrade_button: Button = get_node_or_null("ClickArea/Button")
@onready var tower_sprite: Sprite2D = get_node_or_null("towerSprite2D")
@onready var unit_sprite: AnimatedSprite2D = get_node_or_null("towerSprite2D/towerUnit")
@onready var label_message: Label = get_node_or_null("message")

# -------------Tower Upgrade Stats-----------------
var upgrades_stats := [
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/1.png"),
		"cadence": 2, "damage": 20.0, "range": 30.0, "next_cost": 15
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/2.png"),
		"cadence": 1.75, "damage": 25.0, "range": 35.0, "next_cost": 30
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/3.png"),
		"cadence": 1.5, "damage": 30.0, "range": 40.0, "next_cost": 45
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/4.png"),
		"cadence": 1.5, "damage": 30.0, "range": 40.0, "next_cost": 60
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/5.png"),
		"cadence": 1.25, "damage": 35.0, "range": 45.0, "next_cost": 80
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/6.png"),
		"cadence": 1.1, "damage": 40.0, "range": 50.0, "next_cost": 100
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/7.png"),
		"cadence": 0.9, "damage": 50.0, "range": 55.0, "next_cost": 120
	}
]

# -------------Core Loop-----------------
func _process(delta: float) -> void:
	if current_tower_level != 0: #ensure there's a tower in place 
		if enemies_in_range.size() > 0 and time_cadence >= cadence: # enemies on range and cadence time is met
			towerShot(enemies_in_range[0]) #always shoots the first target 
			time_cadence = 0
	time_cadence += delta 

# -------------Tower Upgrade Logic----------------- 
func tryTowerUpgrade() -> void: #method to see if the tower upgrade can take place 
	if current_tower_level >= upgrades_stats.size() - 1: #tower already on max level 
		showLabelMessage("Max upgrade apply")
		return
	
	if GameManager.coin_amount >= next_price: #check if player has enough money to purchase an upgrade
		GameManager.add_coins(-next_price) # decrease coins amount 
		current_tower_level += 1 
		applyTowerUpgrade()
	else:
		showLabelMessage("Not enough coins")

func applyTowerUpgrade() -> void: #method to apply upgrade to this tower 
	if current_tower_level == 1: # make the archer visible on the first upgrade 
		unit_sprite.visible = true
		unit_sprite.play("idle")
	var data = upgrades_stats[current_tower_level]
	tower_sprite.texture = data["sprite"]
	cadence = data["cadence"]
	damage = data["damage"]
	range = data["range"]
	next_price = data["next_cost"]
	showLabelMessage("Level up!")
	unit_sprite.position.y -= 5
	# TODO: update collision shape size with new range

	
# --------------Enemy Detection----------------
func _on_attack_area_enemy_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"): 
		var enemy = area.get_parent() #get the parent node for shoting direction improvement  
		if enemy not in enemies_in_range:
			enemies_in_range.append(enemy)
		
func _on_attack_area_enemy_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemies_in_range.erase(enemy)
# --------------Combat / Shooting----------------
func towerShot(target):
	if not target or not target.is_inside_tree() or target.is_queued_for_deletion(): #ensure valid enemy is on range
		return
	
	var dir_vec = (target.global_position - global_position).normalized() # Calculate direction vector from tower to enemy
	
	# Determine the direction (up, down, left, right)
	var abs_x = abs(dir_vec.x)
	var abs_y = abs(dir_vec.y)
	
	var anim_name = ""
	if abs_x > abs_y:
		# Horizontal dominant
		if dir_vec.x > 0:
			anim_name = "attack_right"
		else:
			anim_name = "attack_left"
	else:
		# Vertical dominant
		if dir_vec.y > 0:
			anim_name = "attack_front"
		else:
			anim_name = "attack_behind"

	unit_sprite.play(anim_name) #play archer animation based on the target position 
	pending_shot_targe = target # Store target so we can shoot after animation ends

func _on_tower_unit_animation_finished() -> void:
	#generate arrow prefab and setup atributes 
	var arrow_loc = arrow_prefab.instantiate() #instanciate arrow prefab 
	arrow_loc.global_position = tower_sprite.global_position #apply position same as the tower
	get_tree().current_scene.add_child(arrow_loc) # colocate the arrow on the scene 
	arrow_loc.arrowSetup(pending_shot_targe, damage) 
	unit_sprite.play("idle")
	
# -------------Tower UI / Interaction-----------------
func _on_click_area_tower_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	upgrade_button.visible = true

func _on_click_tower_mouse_entered() -> void:
	upgrade_button.visible = true

func _on_click_tower_mouse_exited() -> void:
	upgrade_button.visible = false

func _on_button_pressed() -> void:
	tryTowerUpgrade()

func showLabelMessage(var_message: String) -> void:
	label_message.text = var_message

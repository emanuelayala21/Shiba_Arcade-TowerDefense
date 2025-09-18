class_name TowerManager
extends Node2D

# Current tower stats 
@export var cadence: float = 2
var time_cadence = 0.0
@export var damage: float = 20.0
@export var range: float = 30.0
@export var current_tower_level: int = 0
@export var next_price: int = 10

# node References 
@onready var upgrade_button: Button = get_node_or_null("ClickArea/Button")
@onready var tower_sprite: Sprite2D = get_node_or_null("towerSprite2D")
@onready var attack_area: CollisionShape2D = get_node_or_null("ClickArea/CollisionShape2D")
@onready var label_message: Label = get_node_or_null("message")

# Runtime enemies data
var enemies_in_range: Array = []

var arrow_prefab = preload("res://prefabs/arrow.tscn")

#Tower Upgrade Stats
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
		"cadence": 1.25, "damage": 35.0, "range": 45.0, "next_cost": 60
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/5.png"),
		"cadence": 1.1, "damage": 40.0, "range": 50.0, "next_cost": 80
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/6.png"),
		"cadence": 1, "damage": 50.0, "range": 55.0, "next_cost": 100
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/7.png"),
		"cadence": 0.8, "damage": 60.0, "range": 60.0, "next_cost": 125
	}
]

func _process(delta: float) -> void:
	if current_tower_level != 0: #ensure there's a tower in place 
		if enemies_in_range.size() > 0 and time_cadence >= cadence: # enemies on range and cadence time is met
			towerShot(enemies_in_range[0]) #always shoots the first target 
			time_cadence = 0
	time_cadence += delta 

# Tower Upgrade Logic
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
	var data = upgrades_stats[current_tower_level]
	tower_sprite.texture = data["sprite"]
	cadence = data["cadence"]
	damage = data["damage"]
	range = data["range"]
	next_price = data["next_cost"]
	showLabelMessage("Level up!")
	# TODO: update collision shape size with new range

func showLabelMessage(var_message: String) -> void:
	label_message.text = var_message

# --- Enemy Detection ---
func _on_attack_area_enemy_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"): 
		var enemy = area.get_parent() #get the parent node for shoting direction improvement  
		if enemy not in enemies_in_range:
			enemies_in_range.append(enemy)
		
func _on_attack_area_enemy_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		enemies_in_range.erase(enemy)

func towerShot(target):
	#generate arrow prefab and setup atributes 
	var arrow_loc = arrow_prefab.instantiate() #instanciate arrow prefab 
	arrow_loc.global_position = tower_sprite.global_position #apply position same as the tower
	get_tree().current_scene.add_child(arrow_loc) # colocate the arrow on the scene 
	arrow_loc.arrowSetup(target, damage) 

# --- Tower UI / Interaction ---
func _on_click_area_tower_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	upgrade_button.visible = true

func _on_click_tower_mouse_entered() -> void:
	upgrade_button.visible = true

func _on_click_tower_mouse_exited() -> void:
	upgrade_button.visible = false

func _on_button_pressed() -> void:
	tryTowerUpgrade()

class_name towerManager
extends Node2D

@onready var upgrade_button = get_node_or_null("ClickArea/Button") 
@onready var tower_sprite = get_node_or_null("towerSprite2D") 
@onready var attack_area = get_node_or_null("ClickArea/CollisionShape2D") 
@onready var label_message = get_node_or_null("message") 

@export var cadence = 1.5
@export var damage = 20.0
@export var range = 30.0
@export var current_tower_level = 0
@export var next_price = 10 

var upgrades_stats = [
	 {
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/1.png"),
		"cadence": 1.5,   # seconds per shot
		"damage": 20.0,
		"range": 30.0,
		"next_cost": 15
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/2.png"),
		"cadence": 1.4,
		"damage": 25.0,
		"range": 35.0,
		"next_cost": 30
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/3.png"),
		"cadence": 1.3,
		"damage": 30.0,
		"range": 40.0,
		"next_cost": 45
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/4.png"),
		"cadence": 1.2,
		"damage": 35.0,
		"range": 45.0,
		"next_cost": 60
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/5.png"),
		"cadence": 1.1,
		"damage": 40.0,
		"range": 50.0,
		"next_cost": 80
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/6.png"),
		"cadence": 1.0,
		"damage": 50.0,
		"range": 55.0,
		"next_cost": 100
	},
	{
		"sprite": preload("res://assets/archer tower pixel art/1 Upgrade/7.png"),
		"cadence": 0.9,
		"damage": 60.0,
		"range": 60.0,
		"next_cost": 125
	}
]

func _ready() -> void:
	pass
	
func tryTowerUpgrade(): 
	if current_tower_level >= upgrades_stats.size() - 1:
		print("max tower level Tower Spot gd")
		#upgrade_button. #disable button since no further upgrades 
		showLabelMessage("Max upgrade apply")
		return
	
	if GameManager.coin_amount >= next_price: #check if user has enough coins to purchase 
		GameManager.add_coins(-next_price)
		showLabelMessage("Not enough coins")
		current_tower_level += 1 
		applyTowerUpgrade()
		
	
func applyTowerUpgrade(): 
	var data = upgrades_stats[current_tower_level]
	
	tower_sprite.texture = data["sprite"]
	cadence = data["cadence"]
	damage = data["damage"]
	range = data["range"]
	next_price = data["next_cost"]
	showLabelMessage("Level up!")
	
	
	
	
func showLabelMessage(var_message):
	label_message.text = var_message


#Tower
func _on_click_tower_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	upgrade_button.visible = true
func _on_click_tower_mouse_exited() -> void:
	upgrade_button.visible = false
func _on_click_tower_mouse_entered() -> void:
	upgrade_button.visible = true


func _on_button_pressed() -> void:
	tryTowerUpgrade()

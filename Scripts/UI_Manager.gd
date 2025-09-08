extends CanvasLayer

@onready var hearts = get_node_or_null("HeartContainer").get_children()
var life_asset = preload("res://assets/img/life.png")
var loseLife_asset = preload("res://assets/img/loseLife.png")

func _process(delta) -> void:
	for i in range(hearts.size()): 
		if i < GameManager.current_hearts:
			hearts[i].texture = life_asset
		else:
			hearts[i].texture = loseLife_asset
			
	

extends CanvasLayer

#lifes
@onready var life_array_asset = get_node_or_null("HeartContainer").get_children()
var life_asset = preload("res://assets/img/life.png")
var loseLife_asset = preload("res://assets/img/loseLife.png")

#coins
@onready var coin_amount_UI = get_node_or_null("CoinContainer/CoinsUI") 

func _ready() -> void:
	GameManager.lifes_changed.connect(_on_lifes_update)
	GameManager.coins_changed.connect(_on_coin_update)


func _process(delta) -> void:
	#life_update() deprecated too much memory used 
	#coin_update()
	pass


func _on_lifes_update():
	for i in range(life_array_asset.size()): 
		if i < GameManager.current_hearts:
			life_array_asset[i].texture = life_asset
		else:
			life_array_asset[i].texture = loseLife_asset
			
func _on_coin_update(coinGM):
	coin_amount_UI.text = str(coinGM)
	

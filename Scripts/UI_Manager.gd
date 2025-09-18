extends CanvasLayer
# --------------Life UI----------------
@onready var life_array_asset = get_node_or_null("HeartContainer").get_children()
var life_asset = preload("res://assets/img/life.png")
var loseLife_asset = preload("res://assets/img/loseLife.png")

# --------------Coins UI----------------
@onready var coin_amount_UI = get_node_or_null("CoinContainer/CoinsUI") 

# --------------Initialization----------------
func _ready() -> void:
	#--- Connection to the signals ---
	GameManager.lifes_changed.connect(_on_lifes_update)
	GameManager.coins_changed.connect(_on_coin_update)

# --------------Life Update Logic----------------
func _on_lifes_update(): #method to show lifes 
	for i in range(life_array_asset.size()): 
		if i < GameManager.current_hearts:
			life_array_asset[i].texture = life_asset
		else:
			life_array_asset[i].texture = loseLife_asset
			
# --------------Coin Update Logic----------------
func _on_coin_update(coinGM): #update coins on UI 
	coin_amount_UI.text = str(coinGM)

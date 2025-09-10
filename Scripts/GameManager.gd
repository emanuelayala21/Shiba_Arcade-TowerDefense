extends Node

@export var max_hearts = 5
var current_hearts = max_hearts
signal	lifes_changed() #signal that communicates w/ UI 

@export var coin_amount = 1000
signal coins_changed(new_coins) #signal that communicates w/ UI 

signal match_flag(value)

func reduce_life():
	current_hearts -= 1
	lifes_changed.emit()
	if current_hearts<=0:
		match_flag.emit()
		print("game over Game manager sc")

func add_coins(coins): 
	coin_amount += coins
	coins_changed.emit(coin_amount) 

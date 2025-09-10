class_name	Level1EnemyPath
extends PathFollow2D

@export var mov_speed = 400.0
@export var coin_drop = 3

func _process(delta): 
	progress += mov_speed * delta
	if progress_ratio >= 1.0:
		enemyReachedEnd()
			
func enemyReachedEnd():
	GameManager.reduce_life()
	enemyDefeat()
	var enemy = get_node_or_null("Enemy")
	if enemy: queue_free()
			
func enemyDefeat(): 
	GameManager.add_coins(coin_drop)

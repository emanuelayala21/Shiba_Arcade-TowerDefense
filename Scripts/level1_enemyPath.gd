class_name	Level1EnemyPath
extends PathFollow2D

@export var mov_speed = 100.0

func _process(delta): 
	progress += mov_speed * delta
	if progress_ratio >= 1.0:
		enemyReachedEnd()
		
func enemyReachedEnd():
	GameManager.reduce_life()
	stopMovement()
	queue_free() #delete the enemy
			
func stopMovement():
	mov_speed = 0.0

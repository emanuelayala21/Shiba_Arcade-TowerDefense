class_name Level1EnemyPath
extends PathFollow2D

# --------------Enemy Movement Stats----------------
@export var mov_speed = 130.0 #apply to every enemy

# --------------Core Loop----------------
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

class_name	Level1EnemyPath
extends PathFollow2D

@export var movSpeed = 100

func _process(delta): 
	progress += movSpeed * delta
	if progress_ratio >= 1.0:
		
		GameManager.reduce_heart()
		var enemy = get_node_or_null("Enemy")
		if enemy:
			queue_free()
			
			#damage player healt

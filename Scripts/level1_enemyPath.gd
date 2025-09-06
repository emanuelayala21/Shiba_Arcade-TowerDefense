class_name	level1_enemyPath
extends PathFollow2D

@export var movSpeed = 80

func _process(delta): 
	progress += movSpeed * delta
	if progress_ratio >= 1.0:
		print("Enemy reaches the end")
		#enemy reaches the end
		#damage player healt

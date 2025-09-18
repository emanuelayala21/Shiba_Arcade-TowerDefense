extends AnimatedSprite2D
class_name enemy
# --------------Enemy Stats----------------
@export var enemy_health = 60.0
@export var coins_drop = 4
var is_dead = false

# --------------Node References----------------
@onready var animated_sprite = $"." 
@onready var health_bar = $HealthBar 

# --------------Initialization----------------
func _ready() -> void:
	health_bar.max_value = enemy_health
	health_bar.value = enemy_health

# --------------Core Loop----------------
func _process(_delta): 
	if !is_dead:
		animated_sprite.play("walk") 
	updateHealth()

# --------------Health Management----------------
func updateHealth(): 
	health_bar.value = enemy_health

func takeDamage(damage): 
	if !is_dead:
		enemy_health -= damage
		if enemy_health <= 0: 
			get_parent().stopMovement()
			GameManager.add_coins(coins_drop)
			animated_sprite.play("death")
			is_dead = true

# --------------Animation Callbacks----------------
func _on_animation_finished() -> void:
	if is_dead and animated_sprite.animation == "death":
		get_parent().queue_free()

extends AnimatedSprite2D

@onready var animated_sprite = $"."
@export var slime_health = 60.0
@export var coins_drop = 4
@onready var health_bar = $HealthBar 
var is_dead = false

func _ready() -> void:
	health_bar.max_value = slime_health
	health_bar.value = slime_health
	
func _process(_delta): 
	if !is_dead:
		animated_sprite.play("walk") 
	updateHealth()
	
func updateHealth(): 
	health_bar.value = slime_health

func takeDamage(damage): 
	if !is_dead:
		slime_health -= damage
		if slime_health <= 0: 
			get_parent().stopMovement()
			GameManager.add_coins(coins_drop)
			animated_sprite.play("death")
			is_dead = true

func _on_animation_finished() -> void:
	if is_dead and animated_sprite.animation == "death":
		get_parent().queue_free()

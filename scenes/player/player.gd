extends Entity

signal player_attack_fired(pos: Vector2, direction: Vector2)
signal player_died()

@export var max_speed: int = 500
var speed: int = max_speed
var can_attack: bool = true
@onready var health_component: HealthComponent = $HealthComponent

func _process(_delta):
	if(health_component.health < 1):
		return
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()
	
	Globals.player_position = global_position
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()

	if (Input.is_action_pressed("Primary Action") and can_attack):
		can_attack = false
		$AttackTimeout.start()
		player_attack_fired.emit($AttackSpawn.global_position, player_direction)

func hit() -> void:
	health_component.hit()

func _on_attack_timeout_timeout():
	can_attack = true

func _on_health_component_hit_zero_health():
	$Explosion.visible = true
	$PlayerSprite.visible = false
	set_deferred("$Hitbox.disabled", true)
	$Explosion.play()
	await $Explosion.animation_finished
	$Explosion.visible = false
	player_died.emit()

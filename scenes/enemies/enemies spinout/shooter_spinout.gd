extends RigidBody2D

@onready var enemy_type: EnemyType = $EnemyType
@onready var health_component: HealthComponent = $HealthComponent

func _on_body_entered(body):
	if(body.is_in_group("NormalEnemy")): 
		health_component.hit()
	if(body.has_method("hit")):
		body.hit()
	if(body.has_method("create_spinout") and body.is_alive()):
		body.create_spinout(global_position)

func _on_sleeping_state_changed():
	Globals.spinout_to_normal.emit(enemy_type.enemy_type, global_position, health_component.health, rotation)
	queue_free()

func set_health(health: int) -> void:
	health_component.health = health

func _on_health_component_hit_zero_health():
	Globals.enemy_died.emit()
	can_sleep = false
	$Explosion.visible = true
	$ShooterSprite.visible = false
	set_deferred("$Hitbox.disabled", true)
	linear_damp = 30
	$Explosion.play()
	$ExplosionSound.play()
	await $Explosion.animation_finished
	queue_free()

func hit() -> void:
	health_component.hit()

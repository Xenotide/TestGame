extends CharacterBody2D
class_name Charger

@export var base_speed: int = 300
var speed: int = base_speed
var movement_direction: Vector2 = Vector2.UP
var rotation_speed: int = 15
@onready var enemy_type: EnemyType = $EnemyType
@onready var health_component: HealthComponent = $HealthComponent
@onready var navigation: NavigationAgent2D = $NavigationAgent2D

func _ready():
	call_deferred("initial_navigation_setup")

func initial_navigation_setup() -> void:
	await get_tree().physics_frame
	navigation.target_position = Globals.player_position

func _physics_process(delta):
	if navigation.is_navigation_finished():
		return

	var direction = (navigation.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	rotate_to_target(navigation.get_next_path_position(), delta)


func create_spinout(collider_position: Vector2) -> void:
	var bounce = collider_position.direction_to(global_position).normalized()
	Globals.normal_to_spinout.emit(enemy_type.enemy_type, bounce, collider_position, global_position, health_component.health, rotation)
	queue_free()

func hit():
	health_component.hit()

func set_health(health: int) -> void:
	health_component.health = health

func is_alive() -> bool:
	return health_component.health > 0

func rotate_to_target(target_position, delta):
	var direction = target_position - global_position
	var angle = transform.x.angle_to(direction)
	rotate(sign(angle) * min(delta * rotation_speed, abs(angle)))

func _on_health_component_hit_zero_health():
	Globals.enemy_died.emit()
	$NavigationUpdate.stop()
	$Explosion.visible = true
	$ChargerSprite.visible = false
	set_deferred("$Hitbox.disabled", true)
	speed = 0
	$Explosion.play()
	$ExplosionSound.play()
	await $Explosion.animation_finished
	queue_free()

func _on_navigation_update_timeout():
	navigation.target_position = Globals.player_position

func _on_hurtbox_body_entered(body):
	body.hit()

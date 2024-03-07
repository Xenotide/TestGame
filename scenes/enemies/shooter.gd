extends CharacterBody2D

signal shooter_attack_fired(pos: Vector2, direction: Vector2)

const minimum_range: int = 600
const maximum_range: int = 900

@export var base_speed: int = 150
var speed: int = base_speed
var movement_direction: Vector2 = Vector2.UP
var shooting_distance: int
var is_shooting: bool = false
var in_range: bool = false

var rotation_speed: int = 10

@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var enemy_type: EnemyType = $EnemyType
@onready var health_component: HealthComponent = $HealthComponent

func _ready():
	call_deferred("initial_navigation_setup")

func initial_navigation_setup() -> void:
	await get_tree().physics_frame
	navigation.target_position = Globals.player_position

func _process(_delta):
	$TargetingRay.target_position = $TargetingRay.to_local(Globals.player_position)
	$TargetingRay.force_raycast_update()
	$TargetingRay2.target_position = $TargetingRay2.to_local(Globals.player_position)
	$TargetingRay2.force_raycast_update()

func _physics_process(delta):
	if is_shooting:
		rotate_to_target(Globals.player_position, delta)
		return
	elif in_range:
		shoot_at_player()
	
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

func shoot_at_player() -> void:
	is_shooting = true
	while in_range and not ($TargetingRay.is_colliding() or $TargetingRay2.is_colliding()):
		var player_position = Globals.player_position
		var attack_direction = (player_position - global_position).normalized()
		shooter_attack_fired.emit($AttackSpawn.global_position, attack_direction)
		await get_tree().create_timer(1.0).timeout
	is_shooting = false

func rotate_to_target(target_position, delta):
	var direction = target_position - global_position
	var angle = transform.x.angle_to(direction)
	rotate(sign(angle) * min(delta * rotation_speed, abs(angle)))

func _on_health_component_hit_zero_health():
	Globals.enemy_died.emit()
	$NavigationUpdate.stop()
	$Explosion.visible = true
	$Sprite2D.visible = false
	set_deferred("$Hitbox.disabled", true)
	speed = 0
	$Explosion.play()
	$ExplosionSound.play()
	await $Explosion.animation_finished
	queue_free()

func _on_attack_radius_body_entered(_body):
	in_range = true

func _on_attack_radius_body_exited(_body):
	in_range = false

func _on_navigation_update_timeout():
	navigation.target_position = Globals.player_position

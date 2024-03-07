extends Node2D

var player_projectile_bouncy_scene: PackedScene = preload("res://scenes/projectiles/player_projectile_bouncy.tscn")
var shooter_projectile_scene: PackedScene = preload("res://scenes/projectiles/shooter_projectile.tscn")

func _ready():
	Globals.normal_to_spinout.connect(_spawn_spinout_enemy)
	Globals.spinout_to_normal.connect(_spawn_normal_enemy)

	$"Enemy Spawn Master".reset_enemy_list({"charger": 20, "shooter": 4})

func _on_player_player_attack_fired(pos, direction):
	var player_projectile = player_projectile_bouncy_scene.instantiate() as RigidBody2D
	player_projectile.position = pos
	player_projectile.rotation = direction.angle()
	player_projectile.apply_impulse(direction * 2000, pos)
	$Projectiles.add_child(player_projectile)

func _on_shooter_shooter_attack_fired(pos, direction):
	var shooter_projectile = shooter_projectile_scene.instantiate()
	shooter_projectile.position = pos
	shooter_projectile.direction = direction
	shooter_projectile.rotation = direction.angle()
	shooter_projectile.scale = Vector2(0.8, 0.8)
	$Projectiles.add_child(shooter_projectile)

func _spawn_normal_enemy(enemy_type, pos, health, initial_rotation):
	call_deferred("spawn_normal_enemy_deferred", enemy_type, pos, health, initial_rotation)

func spawn_normal_enemy_deferred(enemy_type, pos, health, initial_rotation) -> void:
	var enemy = $"Enemy Collection".get_normal_version_from_spinout(enemy_type).instantiate()
	enemy.global_position = pos
	enemy.rotation = initial_rotation
	if enemy.is_in_group("Shooter"):
		enemy.shooter_attack_fired.connect(_on_shooter_shooter_attack_fired)
	$Enemies.add_child(enemy)
	enemy.set_health(health)

func _spawn_spinout_enemy(enemy_type, direction, collider_position, pos, health, initial_rotation):
	call_deferred("spawn_spinout_enemy_deferred", enemy_type, direction, collider_position, pos, health, initial_rotation)

func spawn_spinout_enemy_deferred(enemy_type, direction, collider_position, pos, health, initial_rotation) -> void:
	var enemy = $"Enemy Collection".get_spinout_version_from_normal(enemy_type).instantiate()
	enemy.global_position = pos
	enemy.apply_impulse(direction * 2000, collider_position)
	enemy.apply_torque(10)
	enemy.rotation = initial_rotation
	$Enemies.add_child(enemy)
	enemy.set_health(health)

func _on_enemy_spawn_master_spawn_new_enemy(enemy_type, pos):
	var enemy = $"Enemy Collection".get_normal_enemy(enemy_type).instantiate()
	enemy.global_position = pos
	enemy.look_at(Globals.player_position)
	if enemy.is_in_group("Shooter"):
		enemy.shooter_attack_fired.connect(_on_shooter_shooter_attack_fired)
	$Enemies.add_child(enemy)


func _on_player_player_died():
	$"Enemy Spawn Master".disable_spawns()
	$UI/GameOverScreen.show_game_over_screen()

func _notification(notif):
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _on_enemy_spawn_master_win_game():
	for enemy in $Enemies.get_children():
		enemy.set_health(0)
	$Player.health_component.health = -1
	$UI/GameOverScreen.show_win_screen()

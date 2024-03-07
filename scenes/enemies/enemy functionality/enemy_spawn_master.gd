extends Node2D

signal spawn_new_enemy(enemy_type, pos)
signal win_game

var enemy_list: Dictionary
var number_of_enemies_to_spawn: int = 0
var number_of_enemies_alive: int = 0:
	set(value):
		number_of_enemies_alive = value
		if ((number_of_enemies_alive == 1 or number_of_enemies_alive == 0) and number_of_enemies_to_spawn == 0):
			win_game.emit()
var rng: RandomNumberGenerator

func _ready():
	rng = Globals.rng
	for spawn_point in get_tree().get_nodes_in_group("Spawn Point"):
		spawn_point.spawn_ready.connect(_on_spawn_ready)
		spawn_point.set_timer(rng.randf_range(3.0, 5.0))
		spawn_point.enable_spawn()
	Globals.enemy_died.connect(decrement_enemy_count)
	call_deferred("spawn_initial_enemies")

func spawn_initial_enemies() -> void:
	await get_tree().physics_frame
	for spawn_point in get_tree().get_nodes_in_group("Spawn Point"):
		_on_spawn_ready(spawn_point.get_spawn_location())
		pass

func reset_enemy_list(enemies: Dictionary):
	enemy_list = enemies
	number_of_enemies_to_spawn = 0
	for enemy in enemy_list:
		number_of_enemies_to_spawn += enemy_list[enemy]

func decrement_enemy_count():
	number_of_enemies_alive -= 1

func disable_spawns():
	for spawn_point in get_tree().get_nodes_in_group("Spawn Point"):
			spawn_point.disable_spawn()

func _on_spawn_ready(pos: Vector2):
	var chosen_number = rng.randi_range(1, number_of_enemies_to_spawn)
	for enemy in enemy_list:
		var number_of_single_enemy = enemy_list[enemy]
		chosen_number -= number_of_single_enemy
		if chosen_number <= 0:
			spawn_new_enemy.emit(enemy, pos)
			enemy_list[enemy] = number_of_single_enemy - 1
			number_of_enemies_to_spawn -= 1
			number_of_enemies_alive += 1
			break
	if (number_of_enemies_to_spawn == 0):
		disable_spawns()

extends Node2D

signal spawn_ready(pos: Vector2)

func get_spawn_location() -> Vector2:
	return $SpawnLocation.global_position

func can_spawn() -> bool:
	return $NoSpawnArea.get_overlapping_bodies().size() == 0

func _on_spawn_timer_timeout():
	if (can_spawn()):
		spawn_ready.emit($SpawnLocation.global_position)

func enable_spawn() -> void:
	$SpawnTimer.start()

func disable_spawn() -> void:
	$SpawnTimer.stop()

func set_timer(time: float) -> void:
	$SpawnTimer.wait_time = time

extends Node2D

@export var charger_normal_scene: PackedScene
@export var charger_spinout_scene: PackedScene

@export var shooter_normal_scene: PackedScene
@export var shooter_spinout_scene: PackedScene
@export var shooter_projectile_scene: PackedScene

func get_normal_enemy(enemy_type: String) -> PackedScene:
	match enemy_type:
		"charger":
			return charger_normal_scene
		"shooter":
			return shooter_normal_scene
		_:
			return charger_normal_scene

func get_spinout_version_from_normal(enemy_type: String) -> PackedScene:
	match enemy_type:
		"charger":
			return charger_spinout_scene
		"shooter":
			return shooter_spinout_scene
		_:
			return charger_spinout_scene

func get_normal_version_from_spinout(enemy_type: String) -> PackedScene:
	match enemy_type:
		"charger spinout":
			return charger_normal_scene
		"shooter spinout":
			return shooter_normal_scene
		_:
			return charger_normal_scene

#func _on_shooter_shooter_attack_fired(pos, direction) -> Area2D:
	#var shooter_projectile = shooter_projectile_scene.instantiate() as Area2D
	#shooter_projectile.position = pos
	#shooter_projectile.direction = direction
	#shooter_projectile.rotation = direction.angle()
	#shooter_projectile.scale = Vector2(0.8, 0.8)
	#return
	#$Projectiles.add_child(shooter_projectile)

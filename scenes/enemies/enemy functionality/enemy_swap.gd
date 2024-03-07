extends Node2D
class_name EnemySwap

@export var enemy_type: String = "default"

signal normal_to_spinout(enemy_type, collision, pos, health)
signal spinout_to_normal(enemy_type, pos, health)

func change_normal_to_spinout(collision, pos, health) -> void:
	normal_to_spinout.emit(enemy_type, collision, pos, health)

func change_spinout_to_normal(pos, health) -> void:
	spinout_to_normal.emit(enemy_type, pos, health)
	print("spinout to normal")

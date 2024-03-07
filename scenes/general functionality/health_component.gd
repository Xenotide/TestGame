extends Node2D
class_name HealthComponent

signal hit_zero_health

@export var starting_health: int = 1
var health: int:
	set(value):
		health = value
		if health == 0:
			hit_zero_health.emit()

func _ready():
	health = starting_health

func hit():
	health -= 1

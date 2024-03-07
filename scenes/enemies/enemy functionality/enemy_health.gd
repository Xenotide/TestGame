extends Node2D
#class_name HealthComponent

signal hit_zero_health

@export var starting_health: int = 1
var health: int

func _ready():
	health = starting_health

func hit():
	health -= 1
	if health <= 0:
		hit_zero_health.emit()

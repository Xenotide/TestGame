extends Node

signal normal_to_spinout(enemy_type, direction, collider_position, pos, health, initial_rotation)
signal spinout_to_normal(enemy_type, pos, health, initial_rotation)
signal enemy_died()

var player_position: Vector2
var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

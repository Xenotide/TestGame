extends RigidBody2D
class_name PlayerProjectileBouncy

func _on_player_projectile_lifetime_timeout():
	queue_free()


func _on_body_entered(body):
	if(body.has_method("create_spinout")):
		body.create_spinout(global_position)

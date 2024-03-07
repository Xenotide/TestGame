extends CharacterBody2D

@export var speed: int = 1000
var direction: Vector2 = Vector2.UP

func _process(delta):
	#move_and_collide()
	position += direction * speed * delta
	var collide = move_and_collide(direction * speed * delta)
	if (collide):
		if ("create_spinout" in collide.get_collider()):
			#print("projectile: " + str(collide.get_angle()) + " normal: " + str(collide.get_normal()))
			collide.get_collider().create_spinout(collide)
			#pass
			#collide.get_collider().do_initial_spinout(collide)
		queue_free()

#func _physics_process(delta):
	#var collide = move_and_collide(direction * speed * delta)
	#if (collide):
		#print(collide)
		#queue_free()
#func _on_body_entered(body):
	#if ("hit" in body):
		#body.hit()
	#queue_free()

func _on_player_projectile_lifetime_timeout():
	queue_free()


#func _on_body_entered(body):
	#if ("hit" in body):
		#body.hit()
	#queue_free()

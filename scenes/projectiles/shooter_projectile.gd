extends Area2D

@export var speed: int = 1000
var direction: Vector2 = Vector2.UP

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if(body.is_in_group("Player") and body.has_method("hit")):
		body.hit()
	queue_free()

func _on_lifetime_timeout():
	queue_free()

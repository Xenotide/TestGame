extends Node2D

@export var level: PackedScene

func _on_start_screen_start_game():
	get_tree().change_scene_to_packed(level)

func _notification(notif):
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

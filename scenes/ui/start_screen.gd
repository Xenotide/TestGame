extends Control

signal start_game

func _on_start_game_pressed():
	start_game.emit()


func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

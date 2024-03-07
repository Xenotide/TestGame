extends Control

func _on_retry_pressed():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func show_game_over_screen():
	visible = true
	$GameOver.visible = true

func show_win_screen():
	visible = true
	$Win.visible = true

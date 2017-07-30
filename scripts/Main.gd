extends Node

func _process(delta):
	pass

func _ready():
	if get_tree().is_paused():
		get_tree().set_pause(false)
	set_process(true)


func _on_Restart_button_up():
	globals.setScene("res://scenes/Main.tscn")

func _on_Title_Screen_button_up():
	globals.setScene("res://scenes/MainMenu.tscn")

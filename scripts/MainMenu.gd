extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Start_button_up():
	globals.setScene("res://scenes/Main.tscn")


func _on_Exit_button_up():
	get_tree().quit()

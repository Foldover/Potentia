extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_WinBox_body_enter( body ):
	get_parent().get_node("Hud/PopupWin").popup()
	get_parent().get_node("Animals/UISounds").play("SoGood")

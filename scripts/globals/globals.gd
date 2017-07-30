extends Node

const GRAVITY = 9.8

var currentScene = null

func setScene(scene):
	currentScene.queue_free()
	var s = ResourceLoader.load(scene)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)


func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
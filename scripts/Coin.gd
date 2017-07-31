extends Area2D

export var mScore = 1

func _ready():
	pass

func _on_Coin_body_enter( body ):
	if body.has_method("updateScore"):
		body.updateScore(mScore)
		self.queue_free()

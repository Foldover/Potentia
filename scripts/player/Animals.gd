extends KinematicBody2D

export var mAcceleration = 1.0
export var mDeceleration = 1.0
export var mShockCooldown = 1.0
export var mAggressionIncrement = 1.0
export var mAggressionDecrement = -1.0
export var mPowerIncrement = 1.0
export var mPowerDecrement = -1.0
export var mFriction = 1.0

var mVelocity
var canShock
var mPower
var mAggression
var mScore

var mPowerBar
var mAggressionBar
var mScoreLabel

var mParticles

var loseHasPopped = false

var isWalking

func _process(delta):
	get_node("ShockTimer").set_wait_time(mShockCooldown)
	if(mAggression >= 100 and !loseHasPopped):
		lose()
		
func _fixed_process(delta):
	if (!is_colliding()):
		mVelocity.y += globals.GRAVITY
		mParticles.set_emitting(false)
	else:
		if mVelocity.x > 0:
			mParticles.set_emitting(true)
		mVelocity.y = 0
	
	mVelocity.x *= mFriction
	var motion = mVelocity * delta
	var mx = motion.x
	motion = move(motion)
	if (is_colliding()):
		var body = get_collider()
		var n = get_collision_normal()
		if n.x == -1:
			mVelocity.x = 0
		if (n.y != -1):
			motion.y = n.slide(motion).y
			mVelocity.y = n.slide(mVelocity).y
		
		move(Vector2(0, motion.y))
	
	if mVelocity.x > 0 && !isWalking:
		get_node("Sprite/AnimationPlayer").play("Walk")
		isWalking = true
	elif mVelocity.x == 0 && isWalking:
		get_node("Sprite/AnimationPlayer").stop_all()
		isWalking = false
		
func _input(event):
	if event.is_action_pressed("Shock") and canShock:
		get_node("SamplePlayer2D").play("Bleetz")
		zapp()
	elif event.is_action("Brake"):
		mVelocity.x -= mDeceleration
		if mVelocity.x < 0:
			mVelocity.x = 0

func _ready():
	isWalking = false
	mPower = 100
	mAggression = 0
	mScore = 0
	mPowerBar = get_parent().get_node("Hud/HBoxContainer/Bars/Power")
	mAggressionBar = get_parent().get_node("Hud/HBoxContainer/Bars/Aggression")
	mScoreLabel = get_parent().get_node("Hud/HBoxContainer/Labels/Score")
	mPowerBar.set_value(1)
	canShock = true
	mVelocity = Vector2()
	mParticles = get_node("SnowParticles")
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)

func lose():
	get_tree().set_pause(true)
	loseHasPopped = true
	get_node("UISounds").play("Lose")
	get_parent().get_node("Hud/PopupLose").popup()
	get_parent().get_node("LevelMusic").stop()

func zapp():
	canShock = false
	get_node("ShockTimer").start()
	mVelocity.x += mAcceleration
	updatePower(mPowerDecrement)
	updateAggression(mAggressionIncrement)

func updateAggression(amount):
	mAggression += amount
	if mAggression < 0:
		mAggression = 0
	mAggressionBar.set_value(mAggression)

func updatePower(amount):
	mPower += amount
	if mPower > 100:
		mPower = 100
	elif mPower < 0:
		mPower = 0
	mPowerBar.set_value(mPower)

func updateScore(amount):
	mScore += amount
	mScoreLabel.set_text(str(mScore))
	get_node("UISounds").play("CoinPickUp")

func _on_ShockTimer_timeout():
	canShock = true

func _on_AggressionTimer_timeout():
	updateAggression(mAggressionDecrement)

func _on_PopupLose_confirmed():
	print("reloading scene")
	globals.setScene("res://scenes/Main.tscn")

func _on_PowerTimer_timeout():
	updatePower(mPowerIncrement)

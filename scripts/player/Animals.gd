extends KinematicBody2D

var mVelocity
export var mAcceleration = 1.0
export var mDeceleration = 1.0
export var mShockCooldown = 1.0
export var mPowerDepletion = 10
export var mShockCooldownMultiplier = 1.2
export var mBaseAggressionIncrement = 1.0
export var mAggressionCooldownMultiplier = 0.5
export var mAggressionCooldown = 1.0

var canShock
var mSleigh
var mPower
var mAggression

var mPowerBar
var mAggressionBar

var mParticles
var mSnowPartArea

var loseHasPopped = false

func _process(delta):
	mShockCooldown -= 0.0001
	mAggressionCooldown += 0.0001
	get_node("ShockTimer").set_wait_time(mShockCooldown)
	if(mAggression >= 100 and !loseHasPopped):
		get_tree().set_pause(true)
		loseHasPopped = true
		get_node("UISounds").play("A Finnish Man meets a Brown Bear (MUST SEE!!) render 001")
		get_parent().get_node("Hud/PopupLose").popup()

func _fixed_process(delta):
	if (!is_colliding()):
		mVelocity.y += globals.GRAVITY
		mParticles.set_emitting(false)
	else:
		if mVelocity.x > 0:
			mParticles.set_emitting(true)
		mVelocity.y = 0
	
	var motion = mVelocity * delta
	var mx = motion.x
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		if (n.y != -1):
			motion.y = n.slide(motion).y
			mVelocity.y = n.slide(mVelocity).y
		
		move(Vector2(0, motion.y))
	
func _input(event):
	if event.is_action_pressed("Shock") and canShock:
		get_node("SamplePlayer2D").play("Bleetz")
		canShock = false
		get_node("ShockTimer").start()
		mVelocity.x += mAcceleration
		mPower -= mPowerDepletion
		mAggression = 0
		mPowerBar.set_value(mPower)
		mAggressionBar.set_value(mAggression)
		mShockCooldown *= mShockCooldownMultiplier
		get_node("ShockTimer").set_wait_time(mShockCooldown)
		mAggressionCooldown *= mAggressionCooldownMultiplier
		get_node("AggressionTimer").set_wait_time(mAggressionCooldown)
	elif event.is_action_pressed("Brake"):
		mVelocity.x -= mDeceleration
		if mVelocity.x < 0:
			mVelocity.x = 0

func _ready():
	mPower = 100
	mAggression = 0
	mPowerBar = get_parent().get_node("Hud/HBoxContainer/Bars/Power")
	mAggressionBar = get_parent().get_node("Hud/HBoxContainer/Bars/Aggression")
	canShock = true
	mVelocity = Vector2()
	mSleigh = get_parent().get_node("Sledge")
	mParticles = get_node("SnowParticles")
	mSnowPartArea = get_node("SnowPartArea")
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)

func _on_ShockTimer_timeout():
	canShock = true

func _on_AggressionTimer_timeout():
	mAggression += 1
	mAggressionBar.set_value(mAggression)

func _on_PopupLose_confirmed():
	get_tree().reload_current_scene

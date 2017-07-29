extends KinematicBody2D

var mVelocity
var mAnimals
var mParticles

func set_velocity(x):
	mVelocity.x = x

func _fixed_process(delta):
	if (!is_colliding()):
		mVelocity.y += globals.GRAVITY
	else:
		if (mVelocity.x != 0):
			mParticles.set_amount(mVelocity.x * 0.1)
		else:
			mParticles.set_amount(0)
		mVelocity.y = 0
	
#	if (get_pos().distance_to(mAnimals.get_pos()) > 1):
#		mVelocity.x = mAnimals.mVelocity.x
	
	var motion = mVelocity * delta
	var mx = motion.x
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		if (n.y != -1):
			motion.y = n.slide(motion).y
			mVelocity.y = n.slide(mVelocity).y
		
		move(Vector2(0, motion.y))
	
func _ready():
	mAnimals = get_parent().get_node("Animals")
	mParticles = get_node("Particles2D")
	mVelocity = Vector2()
	set_fixed_process(true)
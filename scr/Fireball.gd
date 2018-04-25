extends RigidBody

func _ready():
	connect('body_entered', self, 'Collision')

func Collision( body ):
	self.queue_free()

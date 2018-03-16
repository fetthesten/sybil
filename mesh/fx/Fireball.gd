extends RigidBody

func _ready():
	pass



func _on_Fireball_body_entered( body ):
	self.queue_free()

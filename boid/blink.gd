extends AnimationPlayer


func _ready():
	randomize()
	self.playback_speed = 0.5 + randf()

extends StaticBody2D


func disable_collision() -> void:
	self.collision_layer = 0
	self.collision_mask = 0

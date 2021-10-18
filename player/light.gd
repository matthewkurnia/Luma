extends Light2D


var target_energy = self.energy
var target_scale = self.texture_scale


func _process(delta):
	self.energy = lerp(self.energy, target_energy, 0.1)
	self.texture_scale = lerp(self.texture_scale, target_scale, 0.1)

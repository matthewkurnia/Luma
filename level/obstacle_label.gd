extends Label


onready var animation_player = $AnimationPlayer


func _ready():
	self.modulate.a = 0.0
	self.rect_rotation = -get_parent().rotation_degrees


func alert() -> void:
	animation_player.play("alert")

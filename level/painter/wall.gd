tool
extends StaticBody2D


export var n := 0

onready var sprites := [$Sprite1, $Sprite2, $Sprite3]


func _ready():
	if not Engine.editor_hint:
		for i in range(sprites.size()):
			sprites[i].visible = i == n


func randomize_properties():
	randomize()
	n = randi() % 3
	self.scale = Vector2.ONE * (1.0 + randf())
	self.rotation = randf() * 2 * PI
	for i in range(sprites.size()):
		sprites[i].visible = i == n

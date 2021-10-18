tool
extends Node2D


export var flower_scene: PackedScene
export var root := NodePath()
export var active := false
export var color := [Color(), Color(), Color()]

var painting := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not Engine.editor_hint:
		return
	if not active:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT) and painting:
		painting = false
		if not root:
			print("Root not set")
		var flower = flower_scene.instance()
		self.add_child(flower)
		flower.set_owner(get_node(root))
		flower.global_position = get_global_mouse_position()
		flower.modulate = color[randi() % 3]
		print("Flower painted")
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		painting = true
	if Input.is_key_pressed(KEY_ESCAPE):
		print("ASDASF")
		active = false

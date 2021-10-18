tool
extends Node2D


export var wall_asset: PackedScene
export var distance := 80.0
export var root = NodePath()
export var nested_root = NodePath()
export var wall_color := Color(0, 0, 0, 1)
export var active := false

var wall_stack := []
var last_position := Vector2.ONE * -5000.0
var undo := false
var parent


func _ready():
	pass


func _process(delta):
	if not Engine.editor_hint:
		return
	if not active:
		return
	if Input.is_key_pressed(KEY_ESCAPE):
		active = false
	if Input.is_key_pressed(KEY_E) and Input.is_key_pressed(KEY_CONTROL):
		wall_stack.front().queue_free()
		wall_stack.pop_front()
	if Input.is_key_pressed(KEY_R) and Input.is_key_pressed(KEY_CONTROL):
		var mouse_pos := get_global_mouse_position()
		if (mouse_pos - last_position).length() > distance:
			last_position = mouse_pos
			var new_wall = wall_asset.instance()
			if not root:
				print("Root not set")
				return
			if not nested_root:
				print("Nested root not set")
				return
#			else:
#				parent = get_node(root)
#				print(parent.name)
			get_node(nested_root).add_child(new_wall)
			new_wall.set_owner(get_node(root))
			new_wall.modulate = wall_color
			new_wall.global_position = mouse_pos
			new_wall.randomize_properties()
			wall_stack.push_front(new_wall)
			print("Wall painted")

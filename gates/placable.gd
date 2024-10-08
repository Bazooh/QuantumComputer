class_name Placable extends Node2D


var ghost := false:
	set(value):
		ghost = value
		modulate.a = 0.5 if ghost else 1.0

var editor: Editor

var grid_pos: Vector2i:
	get: return to_grid_pos(position)

@export var sprite: Sprite2D
@onready var computer: Computer = get_parent().get_parent()


func _ready() -> void:
	computer.grid[grid_pos] = self


func init_ghost(editor_: Editor, pos: Vector2) -> void:
	editor = editor_
	ghost = true
	position = to_world_pos(to_grid_pos(get_parent().to_local(pos)))
	set_color()


func to_grid_pos(pos: Vector2) -> Vector2i:
	return Vector2i(int(pos.x / 64), int(pos.y / 64))


func to_world_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * 64, pos.y * 64)


func move_to(pos: Vector2) -> void:
	position = to_world_pos(to_grid_pos(pos))


func can_be_placed(_pos: Vector2i) -> bool:
	return false


func unplacable_animation() -> void:
	print("Unplacable : ", grid_pos)
	modulate = Color(10.0, 10.0, 10.0)
	await get_tree().create_timer(0.2).timeout
	set_color()


func place_on_grid(_pos: Vector2i) -> void:
	pass


func place() -> void:
	assert(ghost, "Cannot place a gate that is not a ghost")

	if not can_be_placed(grid_pos):
		await unplacable_animation()
		return
	
	ghost = false
	position = to_world_pos(grid_pos)
	editor.placing_placable = false
	editor.placable = null
	
	place_on_grid(grid_pos)


func set_color() -> void:
	if not ghost:
		return
	
	modulate = Color(1.0, 1.0, 1.0, 0.5) if can_be_placed(grid_pos) else Color(1.0, 0.0, 0.0, 0.5)


func is_mouse_inside_sprite(mouse_pos: Vector2) -> bool:
	return sprite.get_rect().has_point(to_local(mouse_pos) / sprite.global_scale)


func click_inside(event: InputEvent, mouse_button: MouseButton = MOUSE_BUTTON_LEFT) -> bool:
	return is_visible_in_tree() and event is InputEventMouseButton and event.button_index == mouse_button and event.pressed and is_mouse_inside_sprite(event.position)


func unplace(_pos: Vector2i) -> void:
	queue_free()


func _input(event: InputEvent) -> void:
	if (not ghost) and click_inside(event, MOUSE_BUTTON_RIGHT):
		unplace(grid_pos)
		return

	if (not ghost) or (not editor.placing_placable) or editor.placable != self:
		return
	
	if event is InputEventMouseMotion:
		move_to(get_parent().to_local(event.position))
		set_color()

	elif event.is_action_pressed("place"):
		place()
	elif event.is_action_pressed("cancel_place"):
		editor.placing_placable = false
		editor.placable = null
		queue_free()
	

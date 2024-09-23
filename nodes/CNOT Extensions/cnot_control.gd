class_name CNOTControl extends Sprite2D


const control_texture: Texture = preload("res://art/CNOT_control.tres")
const control_texture_inverted: Texture = preload("res://art/CNOT_control_inverted.tres")

var height: int = -1


# func _ready() -> void:
# 	update_texture()


func is_mouse_inside_sprite(mouse_pos: Vector2) -> bool:
	return get_rect().has_point(to_local(mouse_pos))


func click_inside(event: InputEvent) -> bool:
	return is_visible_in_tree() and event is InputEventMouseButton and event.pressed and is_mouse_inside_sprite(event.global_position)


func get_condition_idx() -> int:
	for i in range(owner.conditions.size()):
		if owner.conditions[i].height == height:
			return i
	return -1


func get_condition() -> Dictionary:
	return owner.conditions[get_condition_idx()]


func update_texture() -> void:
	texture = control_texture_inverted if get_condition().inverted else control_texture


func _input(event: InputEvent) -> void:
	if click_inside(event):
		print("Clicked on condition")

		if event.button_index == MOUSE_BUTTON_LEFT:
			var condition: Dictionary = get_condition()
			condition.inverted = not condition.inverted
			texture = control_texture_inverted if condition.inverted else control_texture
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			owner.conditions.remove_at(get_condition_idx())
			owner.update()

			# TODO: Remove the condition from the qubit lines
	

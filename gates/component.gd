class_name Component extends Gate


var inside_computer: Computer
var height: int


static func create_from_computer(computer_scene: PackedScene) -> Component:
	var instance: Computer = computer_scene.instantiate()
	var component := Component.new()
	component.add_child(instance)
	component.get_qubit_line = instance
	component.height = instance.qubit_lines_scene.get_child_count()
	instance.inside_computer.hide.call_deferred()
	instance.gates_scene.hide.call_deferred()
	return component


func can_be_placed(pos: Vector2i) -> bool:
	return range(height).all(func(i: int): return super.can_be_placed(pos + Vector2i(0, i)))


func place_on_grid(pos: Vector2i) -> void:
	for i in range(height):
		super.place_on_grid(pos + Vector2i(0, i))
	
	inside_computer.qubit_lines.sort_custom(func(a: QubitLine, b: QubitLine): return a.grid_pos.y > b.grid_pos.y)
	for i in range(inside_computer.qubit_lines.size()):
		inside_computer.qubit_lines[i].qubit = qubit_lines[i].qubit


func _apply() -> void:
	inside_computer.reset(false)
	inside_computer.compute()
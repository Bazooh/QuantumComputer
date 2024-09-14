class_name Editor extends Node2D


@export var computer: Computer

var grid := {} # {Vector2i: Placable}

var qubit_lines_pos := {} # {x: y}


var placable: Placable
var linking_wire := false
var placing_placable := false


func can_edit() -> bool:
	return (not linking_wire) and (not placing_placable)


func _ready() -> void:
	pass


func get_qubit_line(height: int) -> QubitLine:
	return grid[Vector2i(qubit_lines_pos[height], height)]


func add_qubit_line(grid_pos: Vector2i) -> void:
	var qubit_line := QubitLine.new()

	grid[grid_pos] = qubit_line
	qubit_lines_pos[grid_pos.y] = grid_pos.x


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("compute"):
		computer.compute()
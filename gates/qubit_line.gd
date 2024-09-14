class_name QubitLine extends Placable


const types_sprite: Array[AtlasTexture] = [
	preload("res://art/0.tres"),
	preload("res://art/1.tres"),
	preload("res://art/+.tres"),
	preload("res://art/-.tres"),
	preload("res://art/Phi.tres"),
]


var type: Qubit.Type:
	set(value):
		type = value
		qubit = Qubit.from_type(type)
		sprite.texture = types_sprite[type]
		

var qubit: Qubit

var gates: Array[Gate]
var current_gate_idx: int = 0

var is_waiting: bool = false
var is_active: bool:
	get: return current_gate_idx < gates.size()


func _ready() -> void:
	qubit = Qubit.from_type(type)


func get_waiting_gate() -> Gate:
	assert(is_active, "Trying to get waiting gate when qubit line is not active")

	return gates[current_gate_idx]


func active_next_gate() -> void:
	assert(is_active, "Trying to activate next gate when qubit line is not active")
	
	var gate: Gate = gates[current_gate_idx]

	if gate.can_be_applied():
		gate.apply()
	else:
		is_waiting = true


func can_be_placed(pos: Vector2i) -> bool:
	return not editor.qubit_lines_pos.has(pos.y)


func place_on_grid(pos: Vector2i) -> void:
	editor.qubit_lines_pos[pos.y] = pos.x
	editor.grid[pos] = self


func _input(event: InputEvent) -> void:
	if not ghost and click_inside(event) and editor.can_edit():
		type = (type + 1) % Qubit.Type.size() as Qubit.Type
	
	super._input(event)
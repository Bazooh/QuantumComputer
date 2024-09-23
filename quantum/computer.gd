class_name Computer extends Node2D


@export var qubit_lines_scene: Node2D
@export var gates_scene: Node2D

@export var qubit_lines: Array[QubitLine] = []

var grid := {} # {Vector2i: Placable}
@export var qubit_lines_pos := {} # {y: x}

@export var pad_sensibility: float = 8.0


func get_first_non_waiting_qubit_line(lines: Array) -> QubitLine:
	for qubit_line: QubitLine in lines.duplicate():
		if not qubit_line.is_active:
			lines.erase(qubit_line)
			continue

		if not qubit_line.is_waiting:
			return qubit_line
	
	return null


func compute() -> void:
	var active_qubit_lines: Array = qubit_lines.filter(func(qubit_line: QubitLine): return qubit_line.is_active)

	while not active_qubit_lines.is_empty():
		var qubit_line: QubitLine = get_first_non_waiting_qubit_line(active_qubit_lines)

		if qubit_line == null:
			break
		
		qubit_line.active_next_gate()


func reset(reset_qubit := true) -> void:
	for qubit_line: QubitLine in qubit_lines:
		qubit_line.current_gate_idx = 0
		qubit_line.is_waiting = false
		if reset_qubit:
			qubit_line.qubit.reset_from_type(qubit_line.type)


func save(file_name: String) -> void:
	var scene := PackedScene.new()
	scene.pack(self)
	ResourceSaver.save(scene, "res://components/" + file_name + ".tscn")


func get_qubit_line(height: int) -> QubitLine:
	return grid[Vector2i(qubit_lines_pos[height], height)]


func _input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		position -= pad_sensibility * event.delta


func _ready() -> void:
	var a := Complex.new_random()
	var b := Complex.new_random()
	var c := Complex.new_random()
	var d := Complex.new_random()
	var e := Complex.new_random()
	var f := Complex.new_random()
	var g := Complex.new_random()
	var h := Complex.new_random()
	var i := Complex.new_random()
	var j := Complex.new_random()

	var tensor1 := Tensor.new([a, b])
	var tensor3 := Tensor.new([g, h, i, j])
	var tensor2 := Tensor.new([c, d, e, f])

	var tensor: Tensor = tensor1.multiply(tensor2).multiply(tensor3)

	# var result: Tensor = tensor.reorganize_tensor([1, 1, 2], [0, 1, 2], [1, 0, 2])
	var result: Tensor = tensor.reorganize([2, 2, 1], [0, 1, 2], [1, 2, 0])
	var verif: Tensor = tensor2.multiply(tensor3).multiply(tensor1)

	print(result)
	print(verif)

	print(result.equals(verif))

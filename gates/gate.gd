class_name Gate extends Node2D


const gate_scene: PackedScene = preload("res://gates/gate.tscn")


@export var qubit_lines: Array[QubitLine]
var ghost := false:
    set(value):
        ghost = value
        modulate.a = 0.5 if ghost else 1.0


func _apply() -> void:
    pass


func apply() -> void:
    _apply()
    for qubit_line in qubit_lines:
        qubit_line.is_waiting = false
        qubit_line.current_gate_idx += 1


func get_grid_position(pos: Vector2) -> Vector2:
    return Vector2(
        int(pos.x / 64) * 64 + 32,
        int(pos.y / 64) * 64 + 32
    )


func move_to(pos: Vector2) -> void:
    position = get_grid_position(pos)


func _input(event: InputEvent) -> void:
    if not ghost:
        return
    
    if event is InputEventMouseMotion:
        move_to(event.position)
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        ghost = false

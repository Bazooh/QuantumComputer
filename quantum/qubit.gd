class_name Qubit


enum Type {
    Zero,
    One,
    Plus,
    Minus,
    Random,
}

const INV_SQRT2 := 1 / sqrt(2)


var state := State.new()
var idx: int = 0


func _init(alpha_: Complex, beta_: Complex) -> void:
    state.qubits = [self]
    state.amplitudes = Tensor.new([alpha_, beta_])


func observe() -> bool:
    return state.observe(self)


func reset_from_type(type: Type) -> void:
    idx = 0
    state = State.new()
    state.qubits = [self]
    state.amplitudes = Tensor.new(get_amplitude_from_type(type))


static func get_random_amplitude() -> Array[Complex]:
    var length_alpha: float = sqrt(randf())
    var alpha := Complex.new_random(length_alpha)
    var beta := Complex.new_random(sqrt(1 - length_alpha * length_alpha))
    return [alpha, beta]


static func get_amplitude_from_type(type: Type) -> Array[Complex]:
    match type:
        Type.Zero:
            return [Complex.new(1, 0), Complex.new(0, 0)]
        Type.One:
            return [Complex.new(0, 0), Complex.new(1, 0)]
        Type.Plus:
            return [Complex.new(INV_SQRT2, 0), Complex.new(INV_SQRT2, 0)]
        Type.Minus:
            return [Complex.new(INV_SQRT2, 0), Complex.new(-INV_SQRT2, 0)]
        Type.Random:
            return get_random_amplitude()
        _:
            assert(false, "Invalid qubit type: " + str(type))
            return [Complex.new(0, 0), Complex.new(0, 0)]


static func from_type(type: Type) -> Qubit:
    return Qubit.new.callv(get_amplitude_from_type(type))


func _to_string() -> String:
    return "Qubit(" + str(round(100 * state.get_probability(self, 0))) + " % |0> + " + str(round(100 * state.get_probability(self, 1))) + " % |1>)"
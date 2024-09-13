class_name Vector


static func get_first_non_zero_coef(state: State) -> int:
    for i in range(state.amplitudes.size()):
        if not state.amplitudes[i].is_zero_approx():
            return i
    return -1


static func verify_matrix_product(a_times_b: Array[Complex], a: Array[Complex], b: Array[Complex]) -> bool:
    for i in range(a.size()):
        for j in range(b.size()):
            if not a_times_b[i*b.size() + j].is_equal_approx(a[i].multiply(b[j])):
                return false
    return true
            


@warning_ignore("integer_division")
static func decompose(state: State, n: int, m: int) -> void:
    var array_n := []
    var array_m := []

    var first_non_zero_coef: int = get_first_non_zero_coef(state)
    
    assert(first_non_zero_coef != -1, "The state is zero")

    var coef := Complex.new(1, 0).divide(state.amplitudes[first_non_zero_coef])

    for i in range(n):
        array_n.append(Complex.new(1, 0) if i == first_non_zero_coef / m else (state.amplitudes[i*m + (first_non_zero_coef % m)].multiply(coef)))
    
    for i in range(m):
        array_m.append(state.amplitudes[m*(first_non_zero_coef / m) + i])
    
    if not verify_matrix_product(array_n, array_m, state.amplitudes):
        print("The decomposition is incorrect")
        return



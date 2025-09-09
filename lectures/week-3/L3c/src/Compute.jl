"""
     fibonacci(n::Int64) -> Dict{Int64,Int64}

Computes the Fibonacci sequence from 0 to n terms using a for loop.

### Arguments
- `n::Int64`: The number of terms in the Fibonacci sequence to compute.

### Returns
- `Dict{Int64,Int64}`: A dictionary containing the Fibonacci sequence where keys are the term indices and values are the corresponding Fibonacci numbers.
"""
function fibonacci(n::Int64)::Dict{Int64,Int64}

    # implement a fibonacci function that uses a for loop to compute the fibonacci sequence. 
    # The fibonacci sequence is stored in a dictionary. Inside the for loop use an if else to check for the 0, 1 cases

    # check: is n ≥ 1?
    if n < 1
        throw(ArgumentError("n must be greater than or equal to 1"));
    end

    # initialize -
    fibonacci_seq = Dict{Int64, Int64}()

    # main loop -
    for i ∈ 0:n
        
        # conditional logic: hardcode 0, 1 else gets all other cases
        if (i == 0)
            fibonacci_seq[i] = 0; 
        elseif (i == 1)
            fibonacci_seq[i] = 1;
        else
            fibonacci_seq[i] = fibonacci_seq[i-1] + fibonacci_seq[i-2] # use the dictionary to get the previous two terms
        end
    end

    # return -
    return fibonacci_seq
end;

"""
    fibonacci!(n::Int64, series::Dict{Int64,Int64})

Recursively computes the Fibonacci sequence for 0 to n where n >= 1.
Stores the series in the `series::Dict{Int64,Int64}` variable (in place).

### Arguments
- `n::Int64`: The number of terms in the Fibonacci sequence to compute.
- `series::Dict{Int64,Int64}`: A dictionary to store the Fibonacci sequence where keys are the term indices and values are the corresponding Fibonacci numbers.

### Returns
- `Nothing`: The function updates the `series` dictionary in place.
"""
function fibonacci!(n::Int64, series::Dict{Int64,Int64})

    # Base cases and recursive computation (no caching check)
    if (n == 0)  # base case
        series[0] = 0;
    elseif (n == 1) # base case
        series[1] = 1;
    else
        series[n] = fibonacci!(n-1, series) + fibonacci!(n-2, series);
    end
end;

"""
    memoization_fibonacci!(n::Int64, series::Dict{Int64,Int64}) -> Nothing

Recursively computes the Fibonacci sequence for 0 to n where n >= 1.
Stores the series in the `series::Dict{Int64,Int64}` variable (in place).
Uses memoization to speed up the computation.

### Arguments
- `n::Int64`: The number of terms in the Fibonacci sequence to compute.
- `series::Dict{Int64,Int64}`: A dictionary to store the Fibonacci sequence where keys are the term indices and values are the corresponding Fibonacci numbers.

### Returns
- `Nothing`: The function updates the `series` dictionary in place.
"""
function memoization_fibonacci!(n::Int64, series::Dict{Int64,Int64})

    if haskey(series, n)
        return series[n]  # still return for recursion to work, despite mutation
    elseif n == 0
        series[0] = 0
    elseif n == 1
        series[1] = 1
    else
        series[n] = memoization_fibonacci!(n - 1, series) + memoization_fibonacci!(n - 2, series)
    end
    # mutating function, no need to return series[n]
end;
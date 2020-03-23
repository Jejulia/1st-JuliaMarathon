mutable struct Sudoku
    grid::Array{T,2} where T<:Int
    state::Bool
    Sudoku(grid) = new(grid,false)
end

function possible(sudoku::Array{T,2},row::T,column::T,num::T) where{T<:Int}
    num in sudoku[row,1:end] && return false
    num in sudoku[1:end,column] && return false
    rbl = Int(floor((row-1)/3))
    cbl = Int(floor((column-1)/3))
    for r in 1:3, c in 1:3
        sudoku[rbl*3+r,cbl*3+c] == num && return false
    end
    return true
end

function solve_sudoku(sudoku::Sudoku)
        for row in 1:9
                for column in 1:9
                        if sudoku.grid[row,column] == 0
                                for num in 1:9
                                        if possible(sudoku.grid,row,column,num)
                                                sudoku.grid[row,column] = num
                                                solve_sudoku(sudoku)
                                                sudoku.state ? (return ) : sudoku.grid[row,column] = 0
                                        end
                                end
                                return
                        end
                end
        end
        sudoku.state = true
end

solve_sudoku(sudoku::Array{T,2}) where {T<:Int}= begin
        sudoku = Sudoku(copy(sudoku))
        solve_sudoku(sudoku)
        sudoku.grid
end

s1 = [8 0 0 0 0 0 0 0 0;
      0 0 3 6 0 0 0 0 0;
      0 7 0 0 9 0 2 0 0;
      0 5 0 0 0 7 0 0 0;
      0 0 0 0 4 5 7 0 0;
      0 0 0 1 0 0 0 3 0;
      0 0 1 0 0 0 0 6 8;
      0 0 8 5 0 0 0 1 0;
      0 9 0 0 0 0 4 0 0]

@time s2 = solve_sudoku(s1)
f = open("sudoku.txt","a+")
write(f,"\n")
write(f,"julia> s2")
write(f,"\n")
write(f,"9×9 Array{Int64,2}:")
write(f,"\n")
for i in 1:9
        write(f," ")
        for j in 1:9
                write(f,"$(s2[i,j])  ")
        end
        write(f,"\n")
end
close(f)

# coding: utf-8
require "minisat"

solver = MiniSat::Solver.new

# x[i][j][k] i行j列がkである。

x = Array.new(9){Array.new(9){Array.new(9)}}

for i in 0..8
  for j in 0..8
    for k in 0..8
      x[i][j][k] = solver.new_var
    end
  end
end

# 各 x[i][j] には 1 から 9 のいずれかが入る。

for i in 0..8
  for j in 0..8
    ary = []
    for k in 0..8
      ary << x[i][j][k]
    end
    solver << ary
  end
end

for i in 0..8
  for j in 0..8
    for a in 0..8
      for b in (a+1)..8
        solver << [-x[i][j][a], -x[i][j][b]]
      end
    end
  end
end

nines = []

for i in 0..8
  for j in 0..8
    for k in (j+1)..8
      nines << [[i, j], [i, k]]
      nines << [[j, i], [k, i]]
    end
  end
end

for i in 0..2
  for j in 0..2
    square = []
    for k in 0..2
      for l in 0..2
        square << [i*3+k, j*3+l]
      end
    end
    for k in 0..8
      for l in (k+1)..8
        nines << [square[k], square[l]]
      end
    end
  end
end

for a in 0..8
  nines.each{|pair|
    solver << [-x[pair[0][0]][pair[0][1]][a], -x[pair[1][0]][pair[1][1]][a]]
  }
end

field = []

9.times {
  field << gets.chomp.split("")
}

for i in 0..8
  for j in 0..8
    if field[i][j] == '.'
      field[i][j] = nil
    else
      field[i][j] = field[i][j].to_i - 1
      solver << [x[i][j][field[i][j]]]
    end
  end
end

solver.solve

ans = Array.new(9){Array.new(9)}

for i in 0..8
  for j in 0..8
    for a in 0..8
      if solver[x[i][j][a]]
        ans[i][j] = a+1
        break
      end
    end
  end
end

ans.each{|line|
  puts line.join()
}


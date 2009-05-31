require 'rubygems'
require 'matrix'


class Vector
  include Enumerable
  def each
     0.upto(size - 1) do |i|
      yield @elements[i]
    end
  end

  def <<(other)
     @elements += other.instance_variable_get(:@elements)
  end

    def row_vectors
      Matrix.rows(self.to_a).row_vectors
    end
end
class Matrix
  include Enumerable

  def each
    0.upto(row_size - 1) do |i|
      0.upto(column_size - 1) do |i|
        yield(i,j)
      end
    end
  end
  
   def kron_mult(other)
     otherrows =  other.row_vectors

     rows = []
     0.upto(row_size-1) do |i1|
         otherrows.each do |rowi2|
          curline = []
          0.upto(column_size-1) do |j1|
               curline += rowi2.to_a.map{ |elem| elem * self[i1,j1] }
          end
          rows << curline
        end
     end
    Matrix.rows(rows)
  end
end

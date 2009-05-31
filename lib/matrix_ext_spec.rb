require 'rubygems'
require 'matrix_ext'


describe Matrix do
  it "should have working kronecker product" do
     a = Matrix.I(4)
     b = Matrix.I(2).kron_mult(Matrix.I(2))
     a.should == b
  end
end
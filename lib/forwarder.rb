
# This forwards whatever missed method to the arguments with itself as an argument
# A.call(B) gets tranlated to B.call(A)
module Forwarder
  def method_missing(methId, *args)
      args[0].send methId, self
   end
end
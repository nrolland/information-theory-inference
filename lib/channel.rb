require 'forwarder'
require 'matrix'
require 'matrix_ext'



class Symetricnoisychannel
  def initialize(errorrate)
    @errorrate= errorrate
  end

  def transmit(bit)
    rand < @errorrate ? (1 - bit)%2 : bit
  end
end

class Repetition_code
  def initialize(n)
    @n = n
  end

  def code(img)
    message = Message.new({:width => img.width, :height => img.height})
    message.data = Matrix.I(@n).kron_mult(img.pixels.to_vector).row(0)
    message
  end

end

class Majorityvote_decode
  def initialize(n)
    @n = n
  end

  def decode(mes)
    img = ImageVoodoo.from_dim(mes.width, mes.height)
    img.pixels.copy_from(mes.data)
    img
#      mes.data.class
  end
end



module HashInitialized
  def initialize(hash)
   hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)
    end
  end
end



class Message
   include Forwarder
   include HashInitialized

   attr :width, true
   attr :height, true
   attr :data, true

  def transmit(channel)
    res = Message.new({:width =>self.width, :height => self.height})
    res.data = self.data.map{|bit| channel.transmit(bit)}
    res
  end
end

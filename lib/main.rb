require 'rubygems'
require 'image_voodoo'
require 'image_voodoo_ext'
require 'matrix'
require 'channel'





#main program



channel = Symetricnoisychannel.new(0.3)
coder = Repetition_code.new(3)
decoder = Majorityvote_decode.new(3)

ImageVoodoo.with_image("News1_1.jpg") do |img|
  img = img.getbwpicture
  #p   img.pixels.to_a

  received = img.code(coder).transmit(channel).decode(decoder)
  received.preview
  received = img.code(coder).transmit(channel).decode(decoder)
  received.preview
  received = img.code(coder).transmit(channel).decode(decoder)
  received.preview
end





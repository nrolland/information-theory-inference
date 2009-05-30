require 'rubygems'
require 'image_voodoo'
require 'enumerator'


class Pixels
  def initialize(img)
    p img.to_java.class
    @widthPix = img.to_java.getRaster().getWidth()
		@heightPix =img.to_java.getRaster().getHeight()
    @raster =img.to_java.getRaster()
  end

  def [](i,j)
   @raster.getSample(j,i,0)
  end

  def []=(i,j,val)
    @raster.setSample(j,i,0,val)
    @raster.setSample(j,i,1,val)
    @raster.setSample(j,i,2,val)
  end

  def each
      (0..@heightPix- 1).to_a.each{ |i| (0..@widthPix -1).to_a.each{ |j| yield(i,j,self) }}
  end

  def each_line
      (0..@heightPix-1).to_a.each{ |i| yield(i,self) }
  end


  def to_string
    a =[]
    self.each_line do |i,p|
      a << ((0..@widthPix-1).to_a.inject(Array.new){ |arr,j| arr<< self[i,j] })
    end
    a
  end
end

class ImageVoodoo
  def copy()
    ImageVoodoo.new(@src)
  end
  def pixels
    #p self
    pixels = Pixels.new(self)
    block_given? ? pixels.each{ |i,j,p| yield(i,j,p)} : pixels
  end
  def getbwpicture
     target = copy
    target.pixels{ |i,j,p| p[i,j] = p[i,j]> 100 ? 255: 0 }
    block_given? ? yield(target) : target
  end
end

  ImageVoodoo.with_image("News1_1.jpg") do |img|
#    img.greyscale{ |i|  i.preview

  img = img.greyscale
#    puts img.to_java.getData()

# [1,2,3].to_java.each{|p| puts p}
#p img.pixels.each{|i,j,pix| p i,j, pix[i,j]}
#p img.pixels.to_string

  img = img.getbwpicture
  p img.preview #pixels.to_string
    
#p img.to_java.getData().class
#    puts (img.to_java.getData().getSamples(0,0,1,1,0,nil)).first
#    puts img.to_java.getData().getSample(10,10,1)
#    puts img.to_java.getData().getSample(10,10,2)
#    img.cropped_thumbnail(100) { |img2| img2.save "CTH.jpg" }
#    img.with_crop(100, 200, 400, 600) { |img2| img2.save "CR.jpg" }
#    img.thumbnail(50) { |img2| img2.save "TH.jpg" }
#    img.resize(100, 150) do |img2|
#      img2.save "HEH.jpg"
#      img2.save "HEH.png"
    end



require 'rubygems'
require 'image_voodoo'
require 'matrix'
require 'matrix_ext'
require 'forwarder'

class Symbol
     def to_proc
      proc { |obj, *args| obj.send(self, *args) }
    end
end

class Pixels
   include Enumerable
  def initialize(img)
    @raster =img.to_java.getRaster()
    @widthPix = @raster.getWidth()
		@heightPix = @raster.getHeight()
  end
  def [](i,j)
   #p i, j
   @raster.getSample(j,i,0)
  end
  def []=(i,j,val)
    @raster.setSample(j,i,0,val)
    @raster.setSample(j,i,1,val)
    @raster.setSample(j,i,2,val)
  end

  #add checksize etc
  def copy_from(pix)
    if pix.class == Array or pix.class == Vector then
      i = 0
      self.each_slice(@widthPix) do |indexes|
        indexes.each do |index|
           self[i, index - i*@widthPix] = pix[index]
        end
        i +=1
      end
    else if pix.class == Matrix
      pix.each do |ij| i,j = ij
        self[i,j] = pix[i,j]
      end
    end
    end
  end

  def each
      0.upto(@heightPix-1) do  |i|
        0.upto(@widthPix-1) do |j|
            yield(i*(@widthPix)+j)
        end
      end
  end
  def each_rowcol
      0.upto(@heightPix-1) do |i|
        (0..@widthPix -1).each{ |j| yield(i,j) }
      end
  end
  def each_line
      0.upto(@heightPix-1) do
        |i| yield(i) 
      end
  end
  def lines
      a = []
      self.each_line { |i| a << 0.upto(@widthPix-1).inject([]){ |arr,j| arr << self[i,j] }}
      a
  end
  def to_a
    ar= []
    i = 0
    self.each_slice(@widthPix) do |indexes|
       ar << indexes.map{ |index| self[i, index - i*@widthPix] }
       i +=1
    end
    ar
  end
  def to_s
    self.to_a.to_s
  end
  def to_vector
    Vector[self.to_a.flatten]
  end
  def to_matrix
    matrix.rows[ self.lines ]
  end
end

class ImageVoodoo
  include Forwarder

  def self.from_dim(width, height)
      image = ImageVoodoo.new(BufferedImage.new width, height, RGB)
      image && block_given? ? yield(image) : image
  end
  def copy()
    ImageVoodoo.new(@src)
  end
  def pixels
    pixels = Pixels.new(self)
    block_given? ? pixels.each_rowcol{ |i,j| yield(i,j,pixels)} : pixels
  end

  def getbwpicture
    target = copy.greyscale
    target.pixels{ |i,j,p| p[i,j] = p[i,j]> 100 ? 255: 0 }
    block_given? ? yield(target) : target
  end
end

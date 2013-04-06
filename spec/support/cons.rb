class Cons
  attr_reader :hd, :tl

  EMPTY_LIST = :'[MT]'

  def initialize(hd, tl)
    @hd = hd
    @tl = tl
  end

  def ==(other)
    hd == other.hd && tl == other.tl
  end
end

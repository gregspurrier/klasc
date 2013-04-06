class Absvector
  attr_reader :signature

  def initialize(signature)
    @signature = signature
  end

  def ==(other)
    signature == other.signature
  end
end

class ZanoboRails::Crawlable::SimpleMetaTag
  def initialize(name,property)
    @name = name
    @property = property
  end

  attr_accessor :name, :property
end

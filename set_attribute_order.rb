module SetAttributeOrder
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    attr_reader :attribute_ordered_array
    
    def set_attribute_order(*attrs)
      @attribute_ordered_array = attrs
    end
  end
  
  
  def initialize(attrs={})
    attr_setters = extract_ordered_setters(attrs)
    super
    set_ordered_values(attr_setters)
  end
  
  def update_attributes(attrs={})
    attr_setters = extract_ordered_setters(attrs)
    super
    set_ordered_values(attr_setters)
  end
  
  
private  
  
  def extract_ordered_setters(attrs={})
    order = self.class.attribute_ordered_array
    unless order.empty?
      attr_setters = attrs.map{ |k,v| [k, attrs.delete(k)] if order.include?(k.to_sym) }.compact
      attr_setters.sort_by{ |k,v| order.index(k.to_sym) || attr_setters.length}
    end
  end
  
  def set_ordered_values(attr_setters=nil)
    attr_setters.each do |setter, value|
      self.send("#{setter}=", value)
    end
  end
  
end

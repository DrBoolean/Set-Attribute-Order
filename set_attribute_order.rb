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
    order = self.class.attribute_ordered_array
    unless order.empty?
      setters = attrs.inject({}){ |h,(k,v)| h[k]=attrs.delete(k) if order.include?(k.to_sym) ; h }
      setters.sort_by{ |k,v| order.index(k.to_sym) || setters.length}.each{ |k,v| self.send(:"#{k}=", v)}
    end
    super
  end
  
end

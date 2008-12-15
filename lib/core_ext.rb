module Enumerable
  def group_by
    assoc = {}
 
    each do |element|
      key = yield(element)
 
      if assoc.has_key?(key)
        assoc[key] << element
      else
        assoc[key] = [element]
      end
    end
 
    assoc.sort
  end
end

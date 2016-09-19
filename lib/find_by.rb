class Module

 # Return a Product object for the first product in the database that has a
 # matching brand or product name.

  def create_finder_methods(*attributes)
    attributes.each do |find|
      self.send(:define_singleton_method, "find_by_#{find}") do |params|
        all.each { |product| return product if product.send(find) == params}
        end
      end
    end
  end

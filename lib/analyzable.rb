module Analyzable

  # Accept an array of Product objects and return a hash with inventory counts, organized by brand.
  def count_by_brand(products)
    products.group_by{|product| product.brand}.map{|brand, products| [brand, products.count]}.to_h
  end

  # Accept an array of Product objects and return a hash with inventory counts, organized by product name.
  def count_by_name(products)
    products.group_by{|product| product.name}.map{|name, products| [name, products.count]}.to_h
  end

  # Accept an array of Product objects and return the average price.
 def average_price(products)
   average_price = 0
   products.each do |product|
     average_price += (product.price.to_f)/products.size
   end
   average_price.round(2)
 end

  # Accept an array of Product objects and return a summary inventory report
  # containing: average price, counts by brand, and counts by product name.
  def print_report(products)
    report = "Average Price of Products: $#{average_price(products)}\n"
    report += "Brand Counts: #{count_by_brand(products)}\n"
    report += "Product Name Counts: #{count_by_name(products)}"
    report
  end
end

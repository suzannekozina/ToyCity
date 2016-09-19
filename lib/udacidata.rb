require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Decided to use CONSTANT for database and pseudovariable for datasource-file
  CSV_DATA  = File.dirname(__FILE__) + "/../data/data.csv"

  create_finder_methods("brand", "name")

  def self.create(options = {})
    product = new(options)
      unless all.any? { |item| item.id == product.id }
        CSV.open(CSV_DATA, 'a+') { |csv| csv << [product.id, product.brand,
                                  product.name, product.price] }
      end
    product
  end

  # Return an array of Product objects representing all the data in the database
  def self.all
    products = []
    CSV.foreach(CSV_DATA, headers: true) do |arr|
      products << new(id: arr['id'].to_i, brand: arr['brand'],
                      name: arr['product'], price: arr['price'].to_f)
    end
    products
  end

  # Return an array of Product objects for the first n products in the database
  def self.first(n=1)
    n > 1 ? all.take(n) : all.first
  end

  # Return an array of Product objects for the last n products in the database
  def self.last(n=1)
    n > 1 ? all.reverse.take(n) : all.last
  end

  # Return a Product object for the product with a given product id
  # Add a ProductNotFoundError error class to errors.rb and raise the error
  # when the product ID can’t be found
  def self.find(id)
    if found_product = all.find{ |product| product.id == id }
    else raise ProductNotFoundError, "Product id NOT found"
    end
    found_product
  end

  # Delete the product corresponding to the given id from the database, and
  # return a Product object for the product that was deleted.
  # Add a ProductNotFoundError and raise the error when the product can’t be
  # destroyed because the given ID does not exist
  def self.destroy(id)
    product_table = CSV.table(CSV_DATA)

    if found_product = all.find{ |product| product.id == id }
    else raise ProductNotFoundError, "Product id NOT found"
    end
    product_table.delete_if { |row| row[:id] == id }

    File.open(CSV_DATA, "w") { |r_edit| r_edit.write(product_table.to_csv) }

    found_product
  end

  # Change the information for a given Product object, and save to the database
  def update(options = {})
    products = []
    product_data = CSV.table(CSV_DATA)
    product_data.each do |product|
      if product[:id] == self.id
          product[:price] = options[:price] ? options[:price] : product[:price]
          product[:brand] = options[:brand] ? options[:brand] : product[:brand]
          product[:name] = options[:name] ? options[:name] :  product[:name]
          products = Product.new(id: product[:id], brand: product[:brand], name: product[:product], price: product[:price])
      end
    end
    File.open(CSV_DATA, "w") { |r_edit| r_edit.write(product_data.to_csv) }

    products
  end

  # Return an array of Product objects that match a given brand or product name
  def self.where(options = {})
    if options[:brand]
      all.select{|product| product.brand == options [:brand]}
    else
      all.select{|product| product.name == options [:name]}
    end
  end
end

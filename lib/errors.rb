# Your custom error classes will be placed here
# Add a ProductNotFoundError error class to errors.rb and raise the error in the following methods:
# find(n) when the product ID can’t be found
# destroy(n) when the product can’t be destroyed because the given ID does not exist
class ProductNotFoundError < StandardError
end

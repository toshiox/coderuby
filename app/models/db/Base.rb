require 'active_record'

class Base < ActiveRecord::Base
  self.abstract_class = true
<<<<<<< HEAD
  self.primary_key = 'id'
=======
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
end
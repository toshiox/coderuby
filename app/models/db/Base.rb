require 'active_record'

class Base < ActiveRecord::Base
  self.abstract_class = true
  self.primary_key = 'id'
end
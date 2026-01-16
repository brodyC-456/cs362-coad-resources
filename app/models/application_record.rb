# ApplicationRecord is simply a wrapper around ActiveRecord::Base that marks itself as an abstract class. 
# ActiveRecord itself is for objects that need persistent storage in the database. 
# All other models in this project inherit from ApplicationRecord.


class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

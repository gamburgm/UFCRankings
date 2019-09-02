class Fighter < ApplicationRecord
  validates :first_name, presence: true, length: { minimum: 1 }
  validates :last_name, presence: true, length: { minimum: 1 }
  validates :debut, presence: true
end

# validations I care about:
# all of the integers need to be positive
# what **absolutely** needs to be present?
#   first and last name?
# not really sure what else.

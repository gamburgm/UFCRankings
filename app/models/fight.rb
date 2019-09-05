class Fight < ApplicationRecord
  belongs_to :first_fighter, class_name: "Fighter", foreign_key: :first_fighter_id
  belongs_to :second_fighter, class_name: "Fighter", foreign_key: :second_fighter_id
  belongs_to :victor, class_name: "Fighter", foreign_key: :victor_id
  belongs_to :weight_class
  belongs_to :event
end

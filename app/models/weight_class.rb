class WeightClass < ApplicationRecord
  # need a has_one or belongs_to relationship with fighter
  belongs_to :champion, class_name: "Fighter", optional: true
  belongs_to :interim_champion, class_name: "Fighter", optional: true
end

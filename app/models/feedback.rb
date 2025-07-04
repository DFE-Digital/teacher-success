class Feedback < ApplicationRecord
  enum :rating, {
    very_satisfied: 5,
    satisfied: 4,
    neither_satisfied_or_dissatisfied: 3,
    dissatisfied: 2,
    very_dissatisfied: 1
  }

  enum :topic, { site: 0, page: 1 }

  validates :rating, presence: { message: "Select a rating from the list" }
  validates :rating, inclusion: { in: self.ratings.keys, message: "Select a rating from the list" }
  validates :topic, presence: { message: "Select the area of the website relating to your feedback" }
end

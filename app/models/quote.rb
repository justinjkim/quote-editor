class Quote < ApplicationRecord
  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # The signed stream name is generated from the array returned by the lambda
  # that is the first argument of the `broadcasts_to` method. In general:
  # 1. Users who share broadcastings should have the lambda return an array with the same values.
  # 2. Users who shouldn't share broadcastings should have the lambda return an array with different values.
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
end

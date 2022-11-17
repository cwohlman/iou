class Action < ApplicationRecord
  # serialize :action, JSON

  belongs_to :user
  belongs_to :deal
end

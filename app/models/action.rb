class Action < ApplicationRecord
  belongs_to :partyA, :class_name=>'User'
  belongs_to :partyB, :class_name=>'User'
  belongs_to :author, :class_name=>'User'
end

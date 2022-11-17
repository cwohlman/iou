class Deal < ApplicationRecord
  has_many :parties
  has_many :users,    :through => :parties
end

class Parties < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
end
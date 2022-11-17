class Deal < ApplicationRecord
  has_many :parties
  has_many :actions
  has_many :users,    :through => :parties


  def self.find_with_status(id)
      deal = Deal.find(id)
      actions = Action.where(deal_id: id)

      {
        "id" => deal["id"],
        "proposals" => get_proposals(actions),
      }
  end

  def self.get_proposals(actions)
    proposals = []
    # Loop through each action

    for action in actions do
      # Wow that's a lot more action than I expected
      case action["action"]["action"]
      when "create", "propose"
        proposals.push({ "id" => action["id"], "items" => action["action"]["items"], proposedBy: action["user_id"], confirmedBy: [], rejectedBy: [] })
      when "confirm"
        proposal = proposals.find { |a| a["id"] == action["action"]["proposal_id"] }
        proposal["confirmedBy"].push(action["user_id"])
        proposal["rejectedBy"] = proposal["rejectedBy"].select { |a| a != action["user_id"] }
      when "reject"
        proposal = proposals.find { |a| a["id"] == action["action"]["proposal_id"] }
        proposal["rejectedBy"].push(action["user_id"])
        proposal["confirmedBy"] = proposal["confirmedBy"].select { |a| a != action["user_id"] }
      end
    end

    proposals
  end
end

class Party < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
end
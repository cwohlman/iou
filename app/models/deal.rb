class Deal < ApplicationRecord
  has_many :parties
  has_many :actions
  has_many :users,    :through => :parties


  def self.find_with_status(id)
      deal = Deal.find(id)
      actions = Action.where(deal_id: id)

      DealWithProposals.new({
        "id" => deal["id"],
        "comment" => deal["comment"],
        "proposals" => get_proposals(actions),
      })
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
      when "fulfill"
        logger.info action["action"]["item_id"]
        proposal = proposals.find { |a| a["id"].to_s  == action["action"]["proposal_id"].to_s }

        if proposal
          logger.info "hit"
          logger.info proposal["items"]

          item = proposal["items"].find { |a| a["id"].to_s == action["action"]["item_id"].to_s }
          item["fulfilled"] = true
        else
          logger.info "miss"
          logger.info proposals
          logger.info action["action"]["proposal_id"]

        end
      end
    end

    proposals
  end
end

class Party < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user
end


# Do these belong somewhere else?

class DealWithProposals
  include ActiveModel::Model

  attr_accessor :id, :comment, :proposals
end

class FulfillableItem
  include ActiveModel::Model

  attr_accessor :deal_id, :item_id, :proposal_id, :fulfilled
end


class DealWithInitialization
  include ActiveModel::Model

  attr_accessor :author_name, :author_email, :counterparty_name, :counterparty_email, :from_author_item, :to_author_item
end


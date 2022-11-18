class DealsController < ApplicationController
  before_action :set_deal, only: %i[ show edit update destroy ]

  # GET /deals or /deals.json
  def index
    @deals = Deal.all
  end

  # GET /deals/1 or /deals/1.json
  def show
  end

  # GET /deals/new
  def new
    if (@current_user)
      @deal = DealWithInitialization.new( :author_name => @current_user.fullname, :author_email => @current_user.email )
    else
      @deal = DealWithInitialization.new
    end
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals/fulfill
  def fulfill
    fulfill = fulfill_params

    @deal = Deal.find(fulfill.deal_id);
    user = @current_user

    action_params = {
      "action" => "fulfill",
      "item_id" => fulfill.item_id,
      "proposal_id" => fulfill.proposal_id,
    }

    action = Action.new({ deal: @deal, user: user, action: action_params })

    respond_to do |format|
      if action.save
        format.html { redirect_to deal_url(@deal), notice: "Item fulfilled." }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { redirect_to deal_url(@deal), notice: "Error.", status: :unprocessable_entity }
        format.json { render json: @action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /deals or /deals.json
  def create
    init = deal_params

    user = User.find_or_create_by!(email: init.author_email) do |user|
      user.fullname = init.author_name
    end

    set_logged_in_user_id user.id

    counterparty = User.find_or_create_by!(email: init.counterparty_email) do |user|
      user.fullname = init.counterparty_name
    end


    @deal = Deal.create!({ comment: init.author_name + " gives " + init.from_author_item + " to " + init.counterparty_name + " for " + init.to_author_item })
    
    Party.create!({ deal: @deal, user: user })
    Party.create!({ deal: @deal, user: counterparty })

    items = [
      { "id" => "todo1", "to" => user.id, "from" => counterparty.id, "item" => init.to_author_item, "fulfilled" => true },
      { "id" => "todo2", "to" => counterparty.id, "from" => user.id, "item" => init.from_author_item, "fulfilled" => false },
    ]
    action = {
      "action" => "create",
      "items" => items,
    }
    Action.create!({ deal: @deal, user: user, action: action })

    respond_to do |format|
      format.html { redirect_to deal_url(@deal), notice: "Deal was successfully created." }
      format.json { render :show, status: :created, location: @deal }
    end
  end

  def fulfillable_item(deal, item)
    FulfillableItem.new(:deal_id => deal.id, :item_id => item["id"], :proposal_id => deal.proposals[0]["id"], :fulfilled => ! item["fulfilled"])
  end

  helper_method :fulfillable_item


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @deal = Deal.find_with_status(params[:id])
    end

    def deal_params
      DealWithInitialization.new(params.require(:deal).permit(:author_name, :author_email, :counterparty_name, :counterparty_email, :from_author_item, :to_author_item))
    end

    def fulfill_params
      FulfillableItem.new(params.require(:fulfillable_item).permit(:deal_id, :item_id, :proposal_id, :fulfilled))
    end
end


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
    @deal = DealWithInitialization.new
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals or /deals.json
  def create
    init = deal_params

    user = User.find_or_create_by!(email: init.author_email) do |user|
      user.fullname = init.author_name
    end

    counterparty = User.find_or_create_by!(email: init.counterparty_email) do |user|
      user.fullname = init.counterparty_name
    end


    @deal = Deal.create!({ comment: init.author_name + " gives " + init.from_author_item + " to " + init.counterparty_name + " for " + init.from_author_item })
    
    Party.create!({ deal: @deal, user: user })
    Party.create!({ deal: @deal, user: counterparty })

    items = [
      { "id" => "todo1", "to" => user.id, "from" => counterparty.id, "item" => init.to_author_item, "fulfilled" => false },
      { "id" => "todo2", "to" => counterparty.id, "from" => user.id, "item" => init.from_author_item, "fulfilled" => true },
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @deal = Deal.find_with_status(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deal_params
      DealWithInitialization.new(params.require(:deal).permit(:author_name, :author_email, :counterparty_name, :counterparty_email, :from_author_item, :to_author_item))
    end
end


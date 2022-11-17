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
    @deal = Deal.new
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals or /deals.json
  def create
    user = User.find_or_create_by!(email: params[:deal][:email])
    counterparty = User.find_or_create_by!(email: params[:deal][:counterparty])


    @deal = Deal.create!()

    Party.create!({ deal: @deal, user: user })
    Party.create!({ deal: @deal, user: counterparty })

    items = [
      { "id" => "todo1", "to" => user["id"], "from": counterparty["id"], "item": params[:deal][:fromCounterparty]},
      { "id" => "todo2", "to" => counterparty["id"], "from": user["id"], "item": params[:deal][:toCounterparty]},
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
      params.require(:deal).permit(:comment)
    end
end

class Merchant::OrdersController < Merchant::BaseController

  def index
    @merc = User.find(current_user.id)
    @orders = @merc.merchant_orders.uniq
    # add path from here
  end

  def show
    @order = Order.find(params[:id])
  end

  def cancel
    Order.find(params[:order_id]).update(status: :canceled)
    @orders = Order.all
    render :index
  end
end

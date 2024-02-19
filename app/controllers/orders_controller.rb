class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def new
    @order = Order.new
    @order.ordered_lists.build
    @items = Item.all.order(:created_at)
  end

  def create
    #１つの商品を２人のユーザーが同時に5個ずつ注文した際に、その商品の注文数が合計10個になるように悲観的ロックを実装する
    ActiveRecord::Base.transaction do
      @order = Order.lock.find_by(user_id: current_user.id)
      @order = current_user.orders.build(order_params)
      @order.save!
      @order.update_total_quantity
      # update_total_quantityメソッドは、注文された発注量を総量に反映するメソッドであり、Orderモデルに定義されています。
    end
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(ordered_lists_attributes: [:item_id, :quantity])
  end
end

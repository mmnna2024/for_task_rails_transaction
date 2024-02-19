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
      @order = current_user.orders.build(order_params)
      @order.save!
      @order.update_total_quantity
      # update_total_quantityメソッドは、注文された発注量を総量に反映するメソッドであり、Orderモデルに定義されています。
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(ordered_lists_attributes: [:item_id, :quantity])
  end
end

#"order"=>{"ordered_lists_attributes"=>{"0"=>{"quantity"=>"3", "item_id"=>"1"}, "1"=>{"quantity"=>"0", "item_id"=>"2"}, "2"=>{"quantity"=>"0", "item_id"=>"3"}, "3"=>{"quantity"=>"0", "item_id"=>"4"}, "4"=>{"quantity"=>"0", "item_id"=>"5"}, "5"=>{"quantity"=>"0", "item_id"=>"6"}, "6"=>{"quantity"=>"0", "item_id"=>"7"}, "7"=>{"quantity"=>"0", "item_id"=>"8"}, "8"=>{"quantity"=>"0", "item_id"=>"9"}, "9"=>{"quantity"=>"0", "item_id"=>"10"}, "10"=>{"quantity"=>"0", "item_id"=>"11"}}}

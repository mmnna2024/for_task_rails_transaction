class Order < ApplicationRecord
  belongs_to :user
  has_many :ordered_lists
  has_many :items, through: :ordered_lists
  accepts_nested_attributes_for :ordered_lists

  # def create_order_transaction(user, item)
  #   ActiveRecord::Base.transaction do
  #     @order = user.orders.build
  #     @order.save!
  #     @order.ordered_lists.build(item: item, quantity: 5)
  #     @order.save!
  #     @order.update_total_quantity
  #     # update_total_quantityメソッドは、注文された発注量を総量に反映するメソッドであり、Orderモデルに定義されています。
  #   end
  # end

  def update_total_quantity
    ActiveRecord::Base.transaction do
      self.ordered_lists.each do |line_item|
        item = Item.lock.find_by(id: line_item.item_id)
        item.total_quantity += line_item.quantity
        item.save!
      end
    end
  end
end

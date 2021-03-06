require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to have_many(:items).through(:order_items) }
  it { is_expected.to validate_presence_of(:status) }
  it { expect(subject.status).to eq("pending")}

  describe '#highest_order_quantities' do
    let(:orders)   { create_list(:order, 5) }

    before do
      extra_order = create(:order, user: orders[0].user)
      create(:order_item, order: orders[0], fulfilled: true, item_quantity: 17)
      create(:order_item, order: orders[1], fulfilled: true, item_quantity: 10)
      create(:order_item, order: orders[2], fulfilled: true, item_quantity: 9)
      create(:order_item, order: orders[2], fulfilled: true, item_quantity: 9)
      create(:order_item, order: orders[3], fulfilled: true, item_quantity: 3)
      create(:order_item, order: orders[4], fulfilled: true, item_quantity: 1)
      create(:order_item, order: orders[4], fulfilled: false, item_quantity: 10)
    end

    subject(:result) do
      Order.highest_order_quantities.map do |order|
        order.id
      end
    end

    let(:expected) { [orders[2].id, orders[0].id, orders[1].id] }

    it { should eq expected }
  end

  describe 'Instance Methods' do
    before do
      @order = create(:order)
      @items = create_list(:item, 3)
      cart_items = []
      cart_items << CartItem.new(@items[0], 1)
      cart_items << CartItem.new(@items[1], 2)
      cart_items << CartItem.new(@items[2], 3)
      @order.add_cart_items(cart_items)
    end

    describe '.add_order_items(items)' do
      describe 'updates order.items' do
        subject { @order.items }
        it { is_expected.to eq(@items) }
      end
      describe 'updates order.order_items' do
        subject { @order.order_items }
        scenario { expect(subject[0].item_price).to eq(@items[0].price) }
        scenario { expect(subject.count).to eq(@items.count) }
      end
    end
    describe '.grand_total' do
      let(:ruby_total) do
        @order.order_items.inject(0) do |subtotal, item|
          subtotal += item.item_price * item.item_quantity
        end
      end
      subject { @order.grand_total }
      it { is_expected.to eq(ruby_total)}
    end
    describe '.unit_quantity' do
      let(:ruby_unit_quantity) do
        @order.order_items.inject(0) do |count, item|
          count += item.item_quantity
        end
      end
      subject { @order.unit_quantity }
      it { is_expected.to eq(ruby_unit_quantity)}
    end
  end
end

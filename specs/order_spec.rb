require "minitest/autorun"
require "minitest/reporters"
require "minitest/skip_dsl"

require_relative "../lib/customer"
require_relative "../lib/order"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe "Order Wave 1" do
  let(:customer) do
    address = {
      street: "123 Main",
      city: "Seattle",
      state: "WA",
      zip: "98101",
    }
    Customer.new(123, "a@a.co", address)
  end

  describe "#initialize" do
    it "Takes an ID, collection of products, customer, and fulfillment_status" do
      id = 1337
      fulfillment_status = :shipped
      order = Order.new(id, {}, customer, fulfillment_status)

      expect(order).must_respond_to :id
      expect(order.id).must_equal id

      expect(order).must_respond_to :products
      expect(order.products.length).must_equal 0

      expect(order).must_respond_to :customer
      expect(order.customer).must_equal customer

      expect(order).must_respond_to :fulfillment_status
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Accepts all legal statuses" do
      valid_statuses = %i[pending paid processing shipped complete]

      valid_statuses.each do |fulfillment_status|
        order = Order.new(1, {}, customer, fulfillment_status)
        expect(order.fulfillment_status).must_equal fulfillment_status
      end
    end

    it "Uses pending if no fulfillment_status is supplied" do
      order = Order.new(1, {}, customer)
      expect(order.fulfillment_status).must_equal :pending
    end

    it "Raises an ArgumentError for bogus statuses" do
      bogus_statuses = [3, :bogus, "pending", nil]
      bogus_statuses.each do |fulfillment_status|
        expect {
          Order.new(1, {}, customer, fulfillment_status)
        }.must_raise ArgumentError
      end
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      order = Order.new(1337, products, customer)

      expected_total = 5.36

      expect(order.total).must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Order.new(1337, {}, customer)

      expect(order.total).must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      before_count = products.count
      order = Order.new(1337, products, customer)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      expect(order.products.count).must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = {"banana" => 1.99, "cracker" => 3.00}
      order = Order.new(1337, products, customer)

      order.add_product("sandwich", 4.25)
      expect(order.products.include?("sandwich")).must_equal true
    end

    it "Raises an ArgumentError if the product is already present" do
      products = {"banana" => 1.99, "cracker" => 3.00}

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.add_product("banana", 4.25)
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      # TODO: Your test code here!

      orders = Order.all

      expect(orders.length).must_equal 100
      expect(orders).must_be_kind_of Array
      orders.each do |c|
        expect(c).must_be_kind_of Order
      end
    end

    it "Returns accurate information about the first order" do
      id = 1
      products = {
        "Lobster" => 17.18,
        "Annatto seed" => 58.38,
        "Camomile" => 83.21,
      }
      customer_id = 25
      fulfillment_status = :complete

      order = Order.all.first

      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Returns accurate information about the last order" do
      # TODO: Your test code here!
      id = 100
      products = {
        "Amaranth" => 83.81,
        "Smoked Trout" => 70.6,
        "Cheddar" => 5.63,
      }
      customer_id = 20
      fulfillment_status = :pending

      order = Order.all.last
      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      # TODO: Your test code here!
      id = 1
      products = {
        "Lobster" => 17.18,
        "Annatto seed" => 58.38,
        "Camomile" => 83.21,
      }
      customer_id = 25
      fulfillment_status = :complete

      order = Order.find(1)

      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Can find the last order from the CSV" do
      # TODO: Your test code here!
      id = 100
      products = {
        "Amaranth" => 83.81,
        "Smoked Trout" => 70.6,
        "Cheddar" => 5.63,
      }
      customer_id = 20
      fulfillment_status = :pending

      order = Order.find(100)
      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Returns nil for an order that doesn't exist" do
      # TODO: Your test code here!
      expect(Order.find(500)).must_be_nil
    end
  end

  describe "Order.find_by_customer" do
    it "Can find all the orders for a customer" do
      # TODO: Your test code here!
      ##44	Papaya:46.45;Butter:91.32;Coriander Leaves:98.34	4	processing
      ##86	Jasmine rice:73.43;Soy Milk:1.69	4	pending
      ##11	Pinto Beans:68.42	4	pending
      id = 44
      products = {
        "Papaya" => 46.45,
        "Butter" => 91.32,
        "Coriander Leaves" => 98.34,
      }
      customer_id = 4
      fulfillment_status = :processing

      orders = Order.find_by_customer(4)
      # Check that all data was loaded as expected
      expect(orders[1].id).must_equal id
      expect(orders[1].products).must_equal products
      expect(orders[1].customer).must_be_kind_of Customer
      expect(orders[1].customer.id).must_equal customer_id
      expect(orders[1].fulfillment_status).must_equal fulfillment_status
      expect(orders.length).must_equal 3
    end

    it "Returns nil for a customer that doesn't have orders" do
      # TODO: Your test code here!
      expect(Order.find_by_customer(500)).must_be_nil
    end
  end

  describe "#remove_product" do
    let(:customer) do
      address = {
        street: "123 Main",
        city: "Seattle",
        state: "WA",
        zip: "98101",
      }
      Customer.new(123, "a@a.co", address)
    end

    it "Decreases the number of products" do
      products = {"banana" => 1.99, "cracker" => 3.00, "salad" => 4.25}
      before_count = products.count
      order = Order.new(1337, products, customer)

      order.remove_product("cracker")
      expected_count = before_count - 1
      expect(order.products.count).must_equal expected_count
    end

    it "Is removed to the collection of products" do
      products = {"banana" => 1.99, "cracker" => 3.00, "salad" => 4.25}
      order = Order.new(1337, products, customer)

      order.remove_product("cracker")
      expect(order.products.include?("cracker")).must_equal false
    end

    it "Raises an ArgumentError if the product is NOT already present" do
      products = {"banana" => 1.99, "cracker" => 3.00}

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.remove_product("salad")
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end
end

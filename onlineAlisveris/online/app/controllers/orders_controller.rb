class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    if @cart.line_items.empty?
      redirect_to stores_url, notice: "Sepetiniz bos!"
      return
    end
  
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        redirect_to @order, notice: 'Tesekkurler.'
      else
        render action: 'new'
      end
    end

   def update
      if @order.update(order_params)
        redirect_to @order, notice: 'Basariyla guncellendi!'
      else
        render :edit
      end
    end

  def destroy
    @order.destroy
      redirect_to orders_url, notice: 'silme islemi tamamlandi!'
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end
    
end

class Api::ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    def index
        @products = Product.all
        render json: @products.map { |product| product.new_attr}
    end
    def show 
        render json: @product.new_attr
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        render json: { success: true, status: 201, data: @product.new_attr }, status: 201
      else
        render json: { success: false, status: 422, message: @product.errors }, status: 422
      end
    end
    
    def update
        if @product.update(product_params)
          render json: { success: true, status: 200, data: @product.new_attr }, status: 200
        else
          render json: { success: false, status: 422, message: @product.errors }, status: 422
        end
      end

    def destroy
    if @product.destroy
      render json: { success: true, status: 200, message: 'product deleted successfully' }, status: 200
      else
        render json: { success: true, status: 422, message: 'product deleted unsuccessfully' }, status: 422
      end
    end

    private
    
  def set_product
    @product = Product.find(params[:id])
    return unless @product.nil?

    render json: { error: 'product not found' }, status: 404
  end

    def product_params
    params.require(:product).permit(:name, :reward, :terms, :price)
  end
end
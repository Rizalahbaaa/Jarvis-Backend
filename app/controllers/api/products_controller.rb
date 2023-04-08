class Api::ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    def index
        @products = Product.all
        render json: @products.map { |product| product.new_attr}
    end
    def show 
        render json: @product
    end

    def create
        @product = Product.new(product_params)
    
        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

    def update
        if @product.update(product_params)
            render json: @product
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    def destroy
    if @product.destroy
        render json: { message: 'success to delete' }, status: 200
      else
        render json: { message: 'fail to delete' }, status: 422
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
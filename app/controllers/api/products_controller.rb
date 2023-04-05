class Api::ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    def index
        @products = Product.all
        render json: @products
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
        render json: {message: "succes", data: @product.destroy}, status: :ok
    end

    private
    
  def set_product
    @product = Product.find(params[:id])
  end
    def product_params
    params.require(:product).permit(:image, :title, :reward, :sk, :points)
  end
end
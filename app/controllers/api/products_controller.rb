class Api::ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    def index
        @products = Product.all
        render json: { success: true, message: 'product found', status: 200, data: @products.map { |product| product.new_attr} }
    end
    def show
      render json: @product.new_attr
    end
   
    def create
      @product = Product.new(product_params)
      if @product.save
        render json: { success: true, status: 201, message: 'create product successfully', data: @product.new_attr }, status: 201
      else
        render json: { success: false, status: 422, message: 'create account unsuccessfully', data: @product.errors }, status: 422
      end
    end

    def update
        if @product.update(product_params)
          render json: { success: true, status: 200,message: 'update product successfully', data: @product.new_attr }, status: 200
        else
          render json: { success: false, status: 422,message: 'update product unsuccessfully', data: @product.errors }, status: 422
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

    render json: {status: 404, message: 'product not found' }, status: 404
  end

    def product_params
    params.permit(:name, :reward, :terms, :price, :photo_product,:status, :notes_quantity)
  end
end
class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :create]
    def index
        @transactions = Transaction.all
        render json: @transactions.map { |transaction| transaction.new_attr }
      end

      def create
        product = Product.find_by(id: transaction_params[:product_id])
        user = User.find_by(id: transaction_params[:user_id])
      
        if product.nil? || user.nil?
          render json: { success: false, status: 422, message: 'Invalid product/user' }, status: 422
          return
        end
        if transaction_params[:point_type] == 'redeemed' && product.price > user.point
          render json: { message: 'Insufficient points' }, status: 422
          return
        end
        if transaction_params[:point_type] == 'earned'
          earned_point = 100 # Mengambil nilai poin yang diperoleh dari params
          @transaction = user.transactions.build(transaction_params.merge({ point: earned_point }))
        else
          @transaction = user.transactions.build(transaction_params.merge({ point: product.price }))
        end
        if @transaction.save
          if transaction_params[:point_type] == 'redeemed'
            render json: { success: true, status: 201, message: 'Redeemed point successfully', data: @transaction.new_attr }, status: 201
          else
            render json: { success: true, status: 201, message: 'Earned point successfully', data: @transaction.new_attr }, status: 201
          end
        else
          if transaction_params[:point_type] == 'redeemed'
            render json: { success: false, status: 422, message: 'Failed to redeem point', data: @transaction.errors }, status: 422
          else
            render json: { success: false, status: 422, message: 'Failed to earn point', data: @transaction.errors }, status: 422
          end
        end
      end
      def history
        @transactions = Transaction.where(user_id: params[:user_id])
        render json: @transactions.map { |transaction| transaction.new_attr }
      end


      def show
        @transaction = Transaction.find(params[:id])
      end
    
      def destroy
        if @transaction.destroy
            render json: { message: 'success to delete transaction' }, status: 200
          else
            render json: { message: 'fail to delete transaction' }, status: 422
          end
        end

      private

      def set_transaction
        @transaction = Transaction.find_by_id(params[:id])
        return if @transaction.nil?
    
        render json: { status: 404, message: 'transaction not found' }, status: 404
      end

      def transaction_params
        params.require(:transaction).permit(:product_id,:user_id, :user_note_id, :transaction_status,:point , :point_type)
      end
    end

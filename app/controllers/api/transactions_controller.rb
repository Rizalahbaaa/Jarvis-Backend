class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :create]
    def index
        @transactions = Transaction.all
        render json: @transactions.map { |transaction| transaction.new_attr }
      end
      def create
        user = current_user
      
        if user.nil?
          render json: { success: false, status: 422, message: 'Invalid user' }, status: 422
          return
        end
      
        if transaction_params[:point_type] == 'redeemed'
          if transaction_params[:product_id].nil?
            render json: { success: false, status: 422, message: 'Product ID is required for redemption' }, status: 422
            return
          end
      
          product = Product.find_by(id: transaction_params[:product_id])
      
          if product.nil?
            render json: { success: false, status: 422, message: 'Invalid product' }, status: 422
            return
          end
      
          if product.price > user.point
            render json: { message: 'Insufficient points' }, status: 422
            return
          end
      
          @transaction = user.transactions.build(transaction_params.merge({ point: product.price }))
        elsif transaction_params[:point_type] == 'earned'
          user_note = UserNote.find_by(id: transaction_params[:user_note_id])
          note = user_note&.note

          if user_note.nil? || !user_note.completed?
            render json: { success: false, status: 422, message: 'Invalid user_note or user_note/note not completed' }, status: 422
            return
          end
          earned_point = 100 # Jumlah poin yang ingin ditambahkan jika user menyelesaikan note
          @transaction = user.transactions.build(transaction_params.merge({ point: earned_point }))
        else
          render json: { success: false, status: 422, message: 'Invalid point_type' }, status: 422
          return
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
        user = User.find_by(id: params[:id])
        if user.nil?
          render json: { success: false, status: 404, message: 'User not found' }, status: 404
        else
          transactions = user.transactions
          render json: transactions.map { |transaction| transaction.new_attr }
        end
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
          params.require(:transaction).permit(:product_id, :user_id, :user_note_id, :transaction_status, :point, :point_type)
       end
      end
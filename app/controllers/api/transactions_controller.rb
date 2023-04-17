class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]
    def index
        @transactions = Transaction.all
        render json: @transactions.map { |transaction| transaction.new_attr }
      end

    def create
      @transaction = Transaction.new(transaction_params)
  
      if @transaction.save
        render json: { success: true, status: 201, message: 'create transaction successfully', data: @transaction.new_attr }, status: 201
      else
        render json: { success: false, status: 422, message: 'create transaction unsuccessfully', data: @transaction.errors }, status: 422
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
        return unless @transaction.nil?
    
        render json: { status: 404, message: 'transaction not found' }, status: 404
      end

      def transaction_params
        params.require(:transaction).permit(:product_id,:user_id, :user_note_id, :transaction_status)
      end
    end

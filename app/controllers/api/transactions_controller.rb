class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]
    def index
        @transactions = Transaction.all
        render json: @transactions.map { |transaction| transaction.new_attr }
      end

    def create
      @transaction = Transaction.new(transaction_params)
  
      if @transaction.save
        render json: @transaction.new_attr, status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
    
      def show
        @transaction = Transaction.find(params[:id])
      end
    
      def destroy
        if @transaction.destroy
            render json: { message: 'success to delete' }, status: 200
          else
            render json: { message: 'fail to delete' }, status: 422
          end
        end

      private

      def set_transaction
        @transaction = Transaction.find(params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:product_id,:progress_id, :profile_id, :transaction_status)
      end
    end

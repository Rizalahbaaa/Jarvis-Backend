class Api::TransactionsController < ApplicationController
    def index
        @transactions = Transaction.all
        render json: @transactions
      end
    
      def new
        @transaction = Transaction.new
      end
  
    def create
      @transaction = Transaction.new(transaction_params)
  
      if @transaction.save
        render json: @transaction, status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
    
      def show
        @transaction = Transaction.find(params[:id])
      end
    
      private
    
      def transaction_params
        params.require(:transaction).permit(:product_id, :user_id, :status)
      end
    end

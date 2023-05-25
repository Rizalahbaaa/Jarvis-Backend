class Api::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :create]
    def index
        @transactions = Transaction.all
        render json: @transactions.map { |transaction| transaction.new_attr }
      end
      def create
        users = []
        if transaction_params[:user_note_id].present?
          users = User.joins(user_notes: :note).where(user_notes: { note_id: transaction_params[:user_note_id] }, notes: { status: 'completed' }).to_a
        end
      
        if transaction_params[:point_type] == 'earned' && users.empty?
          note = Note.find_by(id: transaction_params[:user_note_id])
          if note.nil? || note.note_type == 'tim'
            render json: { success: false, status: 422, message: 'User_note/note tidak valid' }, status: 422
            return
          end
          user_note = UserNote.find_by(note_id: transaction_params[:user_note_id], user_id: current_user.id)
          if user_note.nil? || !user_note.completed? || !note.completed?
            render json: { success: false, status: 422, message: 'User note/note invalid atau belum completed' }, status: 422
          return
        end
        @transaction = current_user.transactions.build(transaction_params.merge({ point: earned_point }))
    
        elsif transaction_params[:point_type] == 'redeemed'
          if current_user.nil?
            render json: { success: false, status: 422, message: 'Pengguna tidak valid' }, status: 422
            return
          end
      
          product = Product.find_by(id: transaction_params[:product_id])
      
          if product.nil?
            render json: { success: false, status: 422, message: 'ID Produk diperlukan untuk penebusan' }, status: 422
            return
          end
      
          if product.price > current_user.point
            render json: { success: false, status: 422, message: 'Poin tidak mencukupi' }, status: 422
            return
          end
      
          @transaction = current_user.transactions.build(transaction_params.merge({ point: product.price }))
          current_user.add_notes_count(product.notes_quantity)

          unless @transaction.save
            render json: { success: false, status: 422, message: 'Gagal melakukan penebusan poin' }, status: 422
            return
          end

        elsif transaction_params[:point_type] == 'earned'
          earned_point = 100 # Jumlah poin yang ingin ditambahkan jika user menyelesaikan note

          users.each do |user|
            user_note = UserNote.find_by(note_id: transaction_params[:user_note_id], user_id: user.id)
      
            if user_note.role != nil
              @transaction = user.transactions.build(transaction_params.merge({ point: earned_point }))
            else
              @transaction = user.transactions.build(transaction_params.merge({ point: 0 }))
            end
      
            unless @transaction.save
              render json: { success: false, status: 422, message: 'Gagal menambahkan poin untuk pengguna', user: user }, status: 422
              return
            end
          end
        else
          render json: { success: false, status: 422, message: 'Jenis poin tidak valid' }, status: 422
          return
        end
      
        user_points = current_user.reload.point
      
        if transaction_params[:point_type] == 'earned'
          users_data = users.map { |user| { user_id: user.id, username: user.username, earned_point: earned_point, total_point: user.point } }
      
          render json: { success: true, status: 201, message: 'Berhasil menambahkan poin', data: users_data }, status: 201
        elsif transaction_params[:point_type] == 'redeemed'
          render json: { success: true, status: 201, message: 'Berhasil melakukan redeem product', data: @transaction.new_attr, point: user_points }, status: 201
        else
          render json: { success: false, status: 422, message: 'Jenis poin tidak valid' }, status: 422
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
          params.require(:transaction).permit(:product_id,:notes_quantity, :user_id, :user_note_id, :transaction_status, :point, :point_type)
       end
      end
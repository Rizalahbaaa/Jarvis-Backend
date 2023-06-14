class Api::CardsController < ApplicationController
  before_action :authenticate_request
  before_action :set_card, only: %i[update destroy show]

  def index
    @cards = Card.all
    render json: { success: true, status: 200, data: @cards.map { |c| c.new_attr } }, status: 200
  end

  def show
    column = @card.column_id
    check = Card.check_member(column, current_user)
    if check
        render json: { success: true, status: 200, data: @card.new_attr }, status: 200
    else
        render json: { success: false, status: 403, error: 'your not member in team' }, status: 403
    end
  end

  def create
    column = params[:column_id]
    check = Card.check_member(column, current_user)
    if check
      @card = Card.new(card_params)
      if @card.save
        return render json: { success: true, status: 201, data: @card.new_attr, message: 'create card successfully' },
               status: 201
      else
        return render json: { success: false, status: 422, error: @card.errors, message: 'create card unsuccessfully' },
               status: 422
      end
    else
      render json: { success: false, status: 403, error: 'your not member in team' }, status: 403
    end
  end

  def update
    column = @card.column_id
    check = Card.check_member(column, current_user)
    if check
        if @card.update(card_params)
          return render json: { success: true, status: 200, data: @card.new_attr, message: 'update card successfully' },
                 status: 200
        else
          return render json: { success: false, status: 422, data: @card.errors, message: 'update card unsuccessfully' },
                 status: 422
        end
    else
        return render json: { success: false, status: 403, error: 'your not member in team' }, status: 403
    end
  end

  def destroy
    column = @card.column_id
    check = Card.check_member(column, current_user)
    if check
        if @card.destroy
          render json: { message: 'success to delete card' }, status: 200
        else
          render json: { message: 'failed to delete card' }, status: 422
        end
    else
        return render json: { success: false, status: 403, error: 'your not member in team' }, status: 403
    end
  end

  private

  def set_card
    @card = Card.find_by_id(params[:id])
    return unless @card.nil?

    render json: { status: 404, message: 'card not found' }, status: 404
  end

  def card_params
    params.permit(:subject, :description, :label, :column_id)
  end
end

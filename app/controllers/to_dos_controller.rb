# frozen_string_literal: true

class ToDosController < ApplicationController
  before_action :set_to_do, only: %i[show update destroy]

  # GET /to_dos
  def index
    render json: @current_user.to_dos
  end

  # GET /to_dos/1
  def show
    render json: @to_do
  end

  # POST /to_dos
  def create
    @to_do = @current_user.to_dos.new to_do_params

    if @to_do.save
      render json: @to_do, status: :created, location: @to_do
    else
      render json: { errors: @to_do.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /to_dos/1
  def update
    if @to_do.update to_do_params
      render json: @to_do
    else
      render json: { errors: @to_do.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /to_dos/1
  def destroy
    @to_do.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_to_do
    @to_do = ToDo.find_by! id: params[:id], user: @current_user
  end

  # Only allow a trusted parameter "white list" through.
  def to_do_params
    params.require(:to_do).permit(:text, :done)
  end
end

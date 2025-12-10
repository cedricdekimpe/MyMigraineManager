class MigrainesController < ApplicationController
  before_action :set_current_month, only: :index

  def index
    migraines = current_user.migraines.for_month(@current_month)
    @migraines_by_day = migraines.index_by { |migraine| migraine.occurred_on.day }
    @days = (1..31).to_a
    @previous_month = @current_month.prev_month
    @next_month = @current_month.next_month
  end

  def new
    @migraine = current_user.migraines.new(occurred_on: Date.current)
  end

  def create
    @migraine = current_user.migraines.new(migraine_params)

    if @migraine.save
      redirect_to migraines_path(month: @migraine.occurred_on.strftime("%Y-%m")), notice: "Migraine entry saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_current_month
    @current_month = if params[:month].present?
      Date.strptime(params[:month], "%Y-%m").beginning_of_month
    else
      Date.current.beginning_of_month
    end
  rescue Date::Error
    Date.current.beginning_of_month
  end

  def migraine_params
    params.require(:migraine).permit(:occurred_on, :nature, :intensity, :on_period, :medication)
  end
end

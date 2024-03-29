# frozen_string_literal: true
class WidgetsController < ApiController
  before_action :doorkeeper_authorize!, except: [:index]

  def index
    widgets =
      if current_user.present?
        current_user.widgets
      else
        sample_widgets
      end
    render json: widgets.map(&:to_json)
  end

  def show
    render json: current_user.widgets.find(params[:id]).to_json
  end

  def create
    widget = current_user.widgets.new(widget_params)
    if widget.save
      render json: widget.to_json, status: :created
    else
      render json: widget.errors, status: :unprocessable_entity
    end
  end

  def update
    widget = Widget.find(params[:id])
    if widget.user != current_user
      head :unauthorized
      return
    end
    if widget.update(widget_params)
      render json: widget.to_json
    else
      render json: widget.errors, status: :unprocessable_entity
    end
  end

  def destroy
    widget = Widget.find(params[:id])
    if widget.user != current_user
      head :unauthorized
      return
    end
    widget.destroy
  end

  private

  def widget_params
    params.permit(:name)
  end

  def sample_widgets
    [
      Widget.new(id: 1, name: 'Widget 1'),
      Widget.new(id: 2, name: 'Widget 2'),
    ]
  end
end

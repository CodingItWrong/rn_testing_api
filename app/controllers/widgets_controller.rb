# frozen_string_literal: true
class WidgetsController < ApiController
  def index
    render json: sample_widgets
  end

  private

  def sample_widgets
    [
      Widget.new(name: 'Widget 1'),
      Widget.new(name: 'Widget 2'),
    ]
  end
end

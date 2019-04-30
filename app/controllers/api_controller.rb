# frozen_string_literal: true
class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  private

  def current_user
    if doorkeeper_token
      @current_user = User.find(doorkeeper_token.resource_owner_id)
    end
  end
end

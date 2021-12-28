# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'widgets', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:widget) { FactoryBot.create(:widget, user: user) }
  let!(:other_widget) { FactoryBot.create(:widget) }
  let(:token) do
    FactoryBot.create(:access_token, resource_owner_id: user.id).token
  end
  let(:headers) do
    { 'Authorization' => "Bearer #{token}" }
  end

  context 'when authenticated' do
    it "returns user's widgets" do
      get '/widgets', headers: headers

      expect(response).to be_successful

      widgets = JSON.parse(response.body)

      expect(widgets.length).to eq(1)
      expect(widgets[0]['name']).to eq(widget.name)
    end
  end
end

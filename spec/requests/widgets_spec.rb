# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'widgets', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user_widget1) { FactoryBot.create(:widget, user: user) }
  let!(:user_widget2) { FactoryBot.create(:widget, user: user) }
  let!(:other_widget) { FactoryBot.create(:widget) }
  let(:token) do
    FactoryBot.create(:access_token, resource_owner_id: user.id).token
  end
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}",
    }
  end

  describe 'list' do
    context 'when unauthenticated' do
      it 'returns hard-coded sample widgets' do
        get '/widgets'

        expect(response).to be_successful

        widgets = JSON.parse(response.body)

        expect(widgets.length).to eq(2)
        expect(widgets[0]['name']).to eq('Widget 1')
        expect(widgets[1]['name']).to eq('Widget 2')
      end
    end

    context 'when authenticated' do
      it "returns user's widgets" do
        get '/widgets', headers: headers

        expect(response).to be_successful

        widgets = JSON.parse(response.body)

        expect(widgets.length).to eq(2)
        expect(widgets[0]['name']).to eq(user_widget1.name)
        expect(widgets[1]['name']).to eq(user_widget2.name)
      end
    end
  end

  describe 'detail' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        get "/widgets/#{user_widget1.id}"
        expect(response).to be_unauthorized
        expect(response.body).to eq('')
      end
    end

    context 'when authenticated' do
      it "returns user's widget" do
        get "/widgets/#{user_widget1.id}", headers: headers

        expect(response).to be_successful

        widget = JSON.parse(response.body)

        expect(widget['name']).to eq(user_widget1.name)
      end

      it "errors on another user's widget" do
        expect {
          get "/widgets/#{other_widget.id}", headers: headers
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'create' do
    name = 'New Widget'
    body = {name: name}

    context 'when unauthenticated' do
      it 'returns unauthorized' do
        expect {
          post '/widgets',
               headers: {'Content-Type' => 'application/json'},
               params: body.to_json
        }.not_to(change { Widget.count })

        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      it 'saves and returns a new widget' do
        expect {
          post '/widgets', headers: headers, params: body.to_json
        }.to change { Widget.count }.by(1)

        widget = Widget.last
        expect(widget.name).to eq(name)

        expect(response).to be_successful

        widget_body = JSON.parse(response.body)

        expect(widget_body['id']).to eq(widget.id)
        expect(widget_body['name']).to eq(name)
      end

      it 'rejects invalid data' do
        invalid_body = {name: ''}
        expect {
          post '/widgets', headers: headers, params: invalid_body.to_json
        }.not_to(change { Widget.count })

        expect(response.status).to eq(422)
      end
    end
  end
end

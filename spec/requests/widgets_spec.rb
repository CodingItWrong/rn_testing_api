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
  let(:unauth_headers) do
    {
      'Content-Type' => 'application/json',
    }
  end
  let(:auth_headers) do
    unauth_headers.merge(
      'Authorization' => "Bearer #{token}",
    )
  end

  describe '#index' do
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
        get '/widgets', headers: auth_headers

        expect(response).to be_successful

        widgets = JSON.parse(response.body)

        expect(widgets.length).to eq(2)
        expect(widgets[0]['name']).to eq(user_widget1.name)
        expect(widgets[1]['name']).to eq(user_widget2.name)
      end
    end
  end

  describe '#show' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        get "/widgets/#{user_widget1.id}"
        expect(response).to be_unauthorized
        expect(response.body).to eq('')
      end
    end

    context 'when authenticated' do
      it "returns user's widget" do
        get "/widgets/#{user_widget1.id}", headers: auth_headers

        expect(response).to be_successful

        widget = JSON.parse(response.body)

        expect(widget['name']).to eq(user_widget1.name)
      end

      it "errors on another user's widget" do
        expect {
          get "/widgets/#{other_widget.id}", headers: auth_headers
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create' do
    name = 'New Widget'
    body = {name: name}

    context 'when unauthenticated' do
      it 'returns unauthorized' do
        expect {
          post '/widgets',
               headers: unauth_headers,
               params: body.to_json
        }.not_to(change { Widget.count })

        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      it 'saves and returns a new widget' do
        expect {
          post '/widgets', headers: auth_headers, params: body.to_json
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
          post '/widgets', headers: auth_headers, params: invalid_body.to_json
        }.not_to(change { Widget.count })

        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    updated_name = 'Updated Name'
    body = {name: updated_name}

    context 'when unauthenticated' do
      it 'returns unauthorized' do
        patch "/widgets/#{user_widget1.id}",
              headers: unauth_headers,
              params: body.to_json

        expect(response).to be_unauthorized

        user_widget1.reload
        expect(user_widget1.name).not_to eq(updated_name)
      end
    end

    context 'when authenticated' do
      it 'saves changes and returns the updated record' do
        patch "/widgets/#{user_widget1.id}", headers: auth_headers, params: body.to_json

        user_widget1.reload
        expect(user_widget1.name).to eq(updated_name)

        expect(response).to be_successful

        widget_body = JSON.parse(response.body)

        expect(widget_body['id']).to eq(user_widget1.id)
        expect(widget_body['name']).to eq(updated_name)
      end

      it "does not allow updating another user's record" do
        patch "/widgets/#{other_widget.id}", headers: auth_headers, params: body.to_json

        other_widget.reload
        expect(other_widget.name).not_to eq(updated_name)

        expect(response.status).to eq(401)
      end

      it 'rejects invalid data' do
        invalid_body = {name: ''}

        post '/widgets', headers: auth_headers, params: invalid_body.to_json

        expect(response.status).to eq(422)

        user_widget1.reload
        expect(user_widget1.name).not_to eq(updated_name)
      end
    end
  end

  describe '#destroy' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        expect {
          delete "/widgets/#{user_widget1.id}", headers: unauth_headers
        }.not_to(change { Widget.count })

        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      it 'deletes the record' do
        expect {
          delete "/widgets/#{user_widget1.id}", headers: auth_headers
        }.to change { Widget.count }.by(-1)
        expect(response.status).to eq(204)
      end

      it "does not allow deleting another user's record" do
        expect {
          delete "/widgets/#{other_widget.id}", headers: auth_headers
        }.not_to(change { Widget.count })

        expect(response.status).to eq(401)
      end
    end
  end
end

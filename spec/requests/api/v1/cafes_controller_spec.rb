require 'rails_helper'

RSpec.describe 'Api::V1::Cafes', type: :request do
  describe 'GET /index' do
    let!(:cafes) { create_list(:cafe, 3) }
    let!(:matching_cafe) { create(:cafe, title: 'Cafe Latte') }

    it 'returns all cafes if no title is provided' do
      get '/api/v1/cafes'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(4)
    end

    it 'filters cafes by title' do
      get '/api/v1/cafes', params: { title: 'Latte' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['title']).to eq('Cafe Latte')
    end

    it 'returns cafes in descending order of creation' do
      get '/api/v1/cafes'
      response_titles = JSON.parse(response.body).map { |c| c['title'] }
      expect(response_titles).to eq(Cafe.order(created_at: :desc).pluck(:title))
    end
  end

  describe 'POST /create' do
    let(:valid_params) do
      {
        cafe: {
          title: 'New Cafe',
          address: '123 Coffee St',
          hours: { monday: '9am - 5pm' },
          criteria: ['cozy', 'wifi']
        }
      }
    end

    let(:invalid_params) do
      {
        cafe: {
          address: '123 Coffee St'
        }
      }
    end

    it 'creates a cafe with valid parameters' do
      expect {
        post '/api/v1/cafes', params: valid_params
      }.to change(Cafe, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('New Cafe')
    end

    it 'returns errors with invalid parameters' do
      post '/api/v1/cafes', params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to include('title')
    end
  end
end

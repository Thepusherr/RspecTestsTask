require 'rails_helper'

RSpec.describe 'Api::V1::Criteria', type: :request do
  describe 'GET /index' do
    before do
      create(:cafe, criteria: ['cozy', 'wifi'])
      create(:cafe, criteria: ['spacious', 'outdoor seating'])
    end

    it 'returns a list of unique criteria' do
      get '/api/v1/criteria'
      expect(response).to have_http_status(:ok)

      criteria = JSON.parse(response.body)
      expect(criteria).to contain_exactly('cozy', 'wifi', 'spacious', 'outdoor seating')
    end

    it "returns an empty list if no criteria exist" do
      Cafe.destroy_all
      get "/api/v1/criteria"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end
  end
end

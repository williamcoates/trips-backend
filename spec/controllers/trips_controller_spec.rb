# rubocop:disable Metrics/LineLength
require 'rails_helper'

describe TripsController do
  let(:trip) { create(:trip) }
  let(:other_trip) { create(:trip) }
  let(:user) { trip.user }
  let(:other_user) { trip.user }

  context 'when logged in as a regular user' do
    before do
      sign_in user
    end

    it 'lists users trips' do
      get :index, format: :json
      expect(json_response.length).to be(1)
      expect(json_response.first[:destination]).to eql(trip.destination)
    end

    it 'allows creating valid trips' do
      post :create, format: :json, trip: { destination: 'Foo', start_date: '3000-01-01', end_date: '3000-01-01', comment: 'Foo' }
      expect(response).to be_success
      expect(json_response[:id]).to_not be_nil
      new_trip = Trip.find(json_response[:id])
      expect(new_trip.user).to eql(user)
      expect(new_trip.destination).to eql('Foo')
      expect(new_trip.start_date).to eql(Date.civil(3000, 1, 1))
      expect(new_trip.end_date).to eql(Date.civil(3000, 1, 1))
      expect(new_trip.comment).to eql('Foo')
    end

    it 'allows deleting own trips' do
      delete :destroy, format: :json, id: trip.id
      expect(response).to be_success
      expect(Trip.exists?(trip.id)).to be(false)
    end

    it 'wont allow deleting other peoples trips' do
      delete :destroy, format: :json, id: other_trip.id
      expect(response).to have_http_status(:unauthorized)
    end

    it 'allows updating own trips' do
      patch :update, format: :json, id: trip.id, trip: { destination: 'Foo', start_date: '3000-01-01', end_date: '3000-01-01', comment: 'Foo' }
      expect(response).to be_success
      trip.reload
      expect(trip.destination).to eql('Foo')
      expect(trip.start_date).to eql(Date.civil(3000, 1, 1))
      expect(trip.end_date).to eql(Date.civil(3000, 1, 1))
      expect(trip.comment).to eql('Foo')
    end

    it 'wont allow updating other peoples trips' do
      patch :update, format: :json, id: other_trip.id, trip: { destination: 'Foo', start_date: '3000-01-01', end_date: '3000-01-01', comment: 'Foo' }
      expect(response).to have_http_status(:unauthorized)
    end

    context 'validation' do
      it 'wont allow creating trips with illogical dates' do
        post :create, format: :json, trip:
            { destination: 'Foo', start_date: '2000-01-02', end_date: '2000-01-01', comment: 'Foo' }
        expect(response).to have_http_status(:bad_request)
      end

      it 'wont allow updating trips with illogical dates' do
        patch :update, id: trip.id, format: :json, trip: { start_date: trip.end_date + 1 }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'when logged in as an admin' do
    let(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    it 'allows deleting other peoples trips' do
      delete :destroy, format: :json, id: trip.id
      expect(response).to be_success
      expect(Trip.exists?(trip.id)).to be(false)
    end

    it 'allows updating other peoples trips' do
      patch :update, format: :json, id: trip.id, trip: { destination: 'Foo' }
      expect(response).to be_success
      trip.reload
      expect(trip.destination).to eql('Foo')
    end
  end

  context 'when not logged on' do
    it 'wont allow you to list trips' do
      get :index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'wont allow you to create trips' do
      post :create, format: :json, trip: { destination: 'Foo', start_date: '3000-01-01', end_date: '3000-01-01', comment: 'Foo' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'wont allow you to delete trips' do
      delete :destroy, format: :json, id: trip.id
      expect(response).to have_http_status(:unauthorized)
    end

    it 'wont allow you to update trips' do
      patch :update, format: :json, id: trip.id, trip: { destination: 'Foo' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

require 'rails_helper'

describe Trip do

  let(:trip) { create(:trip) }
  let(:other_trip) { create(:trip) }
  let(:user) { trip.user }
  let(:admin) { create(:admin) }

  it 'allows admins to access to any trip' do
    expect(trip.has_access?(admin)).to be(true)
  end

  it 'allows user to access own trips' do
    expect(trip.has_access?(user)).to be(true)
  end

  it 'disallows user access to other trips' do
    expect(other_trip.has_access?(user)).to be(false)
  end

end

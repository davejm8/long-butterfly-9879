require 'rails_helper'

RSpec.describe 'show view' do
  before(:each) do
    @amusement_park = AmusementPark.create!(name: "Six Flags", admission_cost: 100)
    @tower = @amusement_park.rides.create!(name: "Tower of terror", thrill_rating: 7, open: true)
    @spinner = @amusement_park.rides.create!(name: "Spinny Thing", thrill_rating: 7, open: true)
    @twirler = @amusement_park.rides.create!(name: "Twirly Thing", thrill_rating: 10, open: true)
    @coaster = @amusement_park.rides.create!(name: "Rollercoaster", thrill_rating: 1, open: true)
    @steve = Mechanic.create!(name: "Steve", years_experience: 7)
    MechanicRide.create!(ride: @coaster, mechanic: @steve)
    MechanicRide.create!(ride: @tower, mechanic: @steve)

    visit "/mechanics/#{@steve.id}"
  end
  
  it 'displays a mechanic with their attributes and the names of rides they work on' do
    within "div#show_#{@steve.id}" do
      expect(page).to have_content("Name: #{@steve.name}")
      expect(page).to have_content("Years of experience: #{@steve.years_experience}")
      expect(page).to have_content("Rides: #{@tower.name} #{@coaster.name}")
    end
  end

  it 'has a form to add a ride to the mechanic' do
    fill_in "Add ride", with: @spinner.id
    click_button "Add"

    expect(current_path).to eq("/mechanics/#{@steve.id}")
    expect(page).to have_content("#{@spinner.name}")
    expect(page).to_not have_content("#{@twirler.name}")

    fill_in "Add ride", with: @twirler.id
    click_button "Add"

    expect(page).to have_content("#{@twirler.name}")
  end
end
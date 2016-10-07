require 'rails_helper'

feature 'reviewing' do

  before { Restaurant.create name: 'KFC' }

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  context 'editing review' do
    scenario "allows reviewer to edit their own reviews" do
      sign_up
      visit '/restaurants'
      add_restaurant
      visit '/restaurants'
      add_review
      click_link 'Edit Review'
      fill_in 'Thoughts', with: "great"
      select '5', from: 'Rating'
      click_button 'Edit Review'

      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('great')
    end
  end

  context 'deleting reviews' do
    scenario 'allows reviewer to edit their own reviews' do
      sign_up
      visit '/restaurants'
      add_restaurant
      visit '/restaurants'
      add_review
      click_link 'Delete so so'

      expect(page).not_to have_content('so so')
    end
  end

end

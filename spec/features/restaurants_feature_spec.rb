require 'rails_helper'
require 'helper.rb'

feature 'restaurants' do

  context 'no restaurants have been added' do

    before { User.create email: 'test@test.com', password: 'password' }

    scenario 'should display a prompt to add a restaurant' do
      log_in_1
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do

    before { User.create email: 'test@test.com', password: 'password' }

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      log_in_1
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      fill_in 'Description', with: 'Chicken-ie'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){ Restaurant.create(name:'KFC') }

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do
    before { User.create email: 'test@test.com', password: 'password' }
    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

    scenario 'let a user edit a restaurant' do
     log_in_1
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     fill_in 'Description', with: 'Deep fried goodness'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(page).to have_content 'Deep fried goodness'
     expect(current_path).to eq '/restaurants'
    end

  end

  context 'deleting restaurants' do
    before { User.create email: 'test@test.com', password: 'password' }
    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

    scenario 'removes a restaurant when a user clicks a delete link' do
      log_in_1
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end

  context 'creating restaurants' do

    before { User.create email: 'test@test.com', password: 'password' }

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        log_in_1
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'a user is limited in actions depending on log in status' do

    scenario 'a user cannot add a restaurant without logging in' do
      visit '/restaurants'
      expect(page).not_to have_link 'Add a restaurant'
    end

    # context 'user is unable to add/delete restaurants that they have not created' do
    #
    #   before { User.create email: 'test@test.com', password: 'password' }
    #   before { User.create email: 'test2@test.com', password: 'password2' }
    #
    #   scenario 'user cannot see edit/delete links to restaurant not created' do
    #     log_in_1
    #     click_link 'Add a restaurant'
    #     fill_in 'Name', with: 'KFC'
    #     click_button 'Create Restaurant'
    #     click_link 'Sign out'
    #     log_in_2
    #     expect(page).to have_content('KFC')
    #     expect(page).not_to have_link 'Edit KFC'
    #     expect(page).not_to have_link 'Delete KFC'
    #   end
    # end
  end

end

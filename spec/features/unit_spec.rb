require 'spec_helper'

feature 'Visitor wants to look at units' do
  scenario 'is on units landing page' do
    visit units_path
    expect(page).to have_selector('h1', :text => 'Digital Collections')
    expect(page).to have_selector('a', :text => 'Library Collections')
    expect(page).to have_selector('a', :text => 'RCI')

    expect(page).to have_field('Search...')
  end

  scenario 'does a search for items' do
    visit units_path

    expect(page).to have_selector('h2', :text => 'Search')
    fill_in 'Search...', :with => "123"
    click_on('Search')

    expect(page).to have_content('Search Results')
  end

  scenario 'browses the collections' do
    visit units_path

    expect(page).to have_selector('h2', :text => 'Browse')

    expect(page).to have_selector('a', :text => 'By Topic')
    expect(page).to have_selector('a', :text => 'By Unit')
    expect(page).to have_selector('a', :text => 'By Format')
  end

  scenario 'uses the carousel' do
    visit units_path

    expect(page).to have_selector('.carousel')
  end

  scenario 'retrieve a unit record' do
    # can we find the unit record
    visit units_path
    expect(page).to have_field('Search...')
    fill_in 'Search...', :with => 'bb02020202'

    click_on('Search')

    # Check description on the page
    expect(page).to have_content("bb02020202")
  end

  scenario 'scoped search (inclusion)' do
    visit unit_path :id => 'dlp'
    expect(page).to have_selector('h2', :text => 'Library Collections')

    # search for the object in the unit and find it
	fill_in 'Search...', :with => 'sample'
    click_on('Search')
    expect(page).to have_content('Search Results')
    expect(page).to have_content('Sample Complex Object Record #1')
  end

  scenario 'scoped search (exclusion)' do
    visit unit_path :id => 'rci'
    expect(page).to have_selector('h2', :text => 'RCI')

    # search for the object in the unit and find it
	fill_in 'Search...', :with => 'sample'
    click_on('Search')
    expect(page).to have_content('Search Results')
    expect(page).to have_no_content('Sample Complex Object Record #1')
  end
end
feature 'Visitor should only see edit button when it will work' do
  scenario 'an anonymous user' do
    visit unit_path('dlp')
    expect(page).not_to have_selector('a', :text => 'Edit')
  end
  scenario 'a logged in user' do
    sign_in_developer
    visit unit_path('dlp')
    expect(page).to have_selector('a', :text => 'Edit')
  end
end

def sign_in_developer
  visit new_user_session_path
  fill_in "Name", :with => "name"
  fill_in "Email", :with => "email@email.com"
  click_on "Sign In"
end


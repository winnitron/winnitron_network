require "rails_helper"

RSpec.feature "Playlist management" do

  before :each do
    login_as FactoryBot.create(:user)
  end

  scenario "create new playlist" do
    visit "/playlists/new"

    fill_in "Title", with: "Greatest Games"
    fill_in "Description", with: "Games I really like"
    click_button "Save"

    expect(page.current_path).to eq "/playlists/greatest-games"
    expect(page).to have_text"Greatest Games"
    expect(page).to have_text "Games I really like"
  end
end

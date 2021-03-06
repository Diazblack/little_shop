require 'rails_helper'

describe 'User Register' do
  before { visit root_path }

  it 'Register fails if Email Already Exists' do
    @user_1 = create(:user, email: 'joe@joecodes.com')
    click_link "Register"
    fill_in :user_name, with: "Joe"
    fill_in :user_address, with: "123 Main Street"
    fill_in :user_city, with: "Fakeville"
    fill_in :user_state, with: "Alabama"
    fill_in :user_zip_code, with: 35622
    fill_in :user_email, with: 'joe@joecodes.com'
    fill_in :user_password, with: 'JoeIsTheCoolest'
    fill_in :user_password_confirmation, with: 'JoeIsTheCoolest';
    click_on "Create User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email address is already in use")

  end

  before(:each) do
    click_link "Register"
    fill_in :user_name, with: "Joe"
    fill_in :user_address, with: "123 Main Street"
    fill_in :user_city, with: "Fakeville"
    fill_in :user_state, with: "Alabama"
    fill_in :user_zip_code, with: 35622
    fill_in :user_email, with: 'joe@joecodes.com'
    fill_in :user_password, with: 'JoeIsTheCoolest'
    fill_in :user_password_confirmation, with: 'JoeIsTheCoolest'
  end

  context 'Sucessful Registration' do
    subject do
      click_on "Create User"; page
    end
    let(:user) { User.last }

    it { is_expected.to have_current_path(profile_path)}
    it { is_expected.to have_content("You are now registered and logged in #{user.name}")}
    it { is_expected.to have_content(user.name) }
    it { is_expected.to have_content(user.address) }
    it { is_expected.to have_content(user.city) }
    it { is_expected.to have_content(user.state) }
    it { is_expected.to have_content(user.zip_code) }
    it { is_expected.to have_content(user.email) }
    it { is_expected.to_not have_content('JoeIsTheCoolest') }
  end

  context 'PW Confirm Fails' do
    before { fill_in :user_password_confirmation, with: 'Joe' }
    subject do
      click_on "Create User"; page
    end

    it { is_expected.to have_current_path(register_path) }
    it { is_expected.to have_content("Error") }
  end

  context 'Forgotten Field Fails' do
    before { fill_in :user_name, with: '' }
    subject do
      click_on "Create User"; page
    end

    it { is_expected.to have_current_path(register_path)}
    it { is_expected.to have_content("Error") }
  end
end

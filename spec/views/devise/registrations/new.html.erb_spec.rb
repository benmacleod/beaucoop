require 'spec_helper'

describe 'devise/registrations/new.html.erb' do
  before do
    view.stub(:resource).and_return(User.new)
    view.stub(:resource_name).and_return(:user)
    view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  it 'should include inputs for #direct_email and #contact_details' do
    render
    rendered.should have_form user_registration_path, :post do
      with_email_field    'user[email]'
      with_password_field 'user[password]'
      with_password_field 'user[password_confirmation]'
      with_checkbox       'user[direct_email]'
      with_text_area      'user[contact_details]'
    end
  end
end

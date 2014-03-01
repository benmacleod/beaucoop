require 'spec_helper'

describe ContactsController do
  describe "POST 'create'" do
    let(:contact) { Fabricate.build :contact, all_params }
    let(:user) { Fabricate.build :user, id: 2 }
    let(:params) {
      {
          'book_id' => 1,
          'message' => 'Plz give me dat book',
          'contact_details' => 'Come on a my house'
      }
    }
    let(:all_params) { params.merge 'user_id' => 2 } # controller adds current user id

    before do
      controller.stub current_user: user
    end

    it 'should create a contact and respond with a JSON representation' do
      Contact.should_receive(:create).with(all_params).and_return contact
      post 'create', contact: params, format: :json
      response.should be_success
      JSON::parse(response.body).should include all_params
    end
  end
end

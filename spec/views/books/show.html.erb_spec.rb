require 'spec_helper'

describe 'books/show.html.erb', type: :view do
  let(:book) { Fabricate.build :book }
  before do
    view.stub current_user: user
    assign :book, book
  end

  context 'when the user is a guest' do
    let(:user) { nil }
    it 'should all inputs except consignee and in_shop' do
      render
      rendered.should have_form books_path, 'post' do
         with_text_field 'book[expiry_date]'
         without_text_field 'book[consignee]'
         without_checkbox 'book[in_shop]'
       end
    end
  end

  context 'when the user is a normal user' do
    let(:user) { Fabricate.build :user }
    it 'should all inputs except consignee and in_shop' do
      render
      rendered.should have_form books_path, 'post' do
        with_text_field 'book[expiry_date]'
        without_text_field 'book[consignee]'
        without_checkbox 'book[in_shop]'
      end
    end
  end

  context 'when the user is an admin' do
    let(:user) { Fabricate.build :admin }
    it 'should show all inputs' do
      render
      rendered.should have_form books_path, 'post' do
        with_text_field 'book[consignee]'
        with_checkbox 'book[in_shop]'
      end
    end
  end
end

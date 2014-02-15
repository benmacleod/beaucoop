require 'spec_helper'

describe 'books/show.html.erb', type: :view do
  let(:book) { Fabricate.build :book }
  let(:user) { Fabricate.build :user}
  before do
    view.stub current_user: user
    assign :book, book
  end

  context 'when the user is an admin' do
    let(:user) { Fabricate.build :admin }
    it 'should show the in shop input' do
      render
      rendered.should have_form books_path, 'post' do
        with_checkbox 'book[in_shop]'
      end
    end
  end

  context 'when the user is not an admin' do
    let(:user) { Fabricate.build :user }
    it 'should not show the in shop input' do
      render
      rendered.should have_form books_path, 'post' do
        without_checkbox 'book[in_shop]'
      end
    end
  end
end

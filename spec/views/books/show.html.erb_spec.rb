require 'spec_helper'

describe 'books/show.html.erb', type: :view do
  let(:book) { Fabricate.build :book, id: 123, user: owner }
  let(:owner) { Fabricate.build :user }
  let(:user) { nil }
  before do
    view.stub current_user: user
    assign :book, book
    render
  end

  context 'when the user is a guest' do
    let(:user) { nil }
    it 'should all inputs except consignee and in_shop' do
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
      rendered.should have_form books_path, 'post' do
        with_text_field 'book[consignee]'
        with_checkbox 'book[in_shop]'
      end
    end
  end

  describe 'contact seller button and dialog' do
    describe 'contact seller form' do
      let(:owner) {
        Fabricate.build :user, admin: admin, direct_email: direct_email,
            contact_details: 'Knock on my door'
      }
      let(:admin) { nil }
      let(:direct_email) { nil }
      let(:book) { Fabricate.build :book, id: 123, in_shop: in_shop, user: owner }
      let(:in_shop) { nil }

      context 'where the user is the owner of the book' do
        let(:user) { owner }
        it 'should not show the contact seller button or the dialog' do
          rendered.should_not have_tag :a, text: 'Contact Seller'
          rendered.should_not have_tag :div, with: { id: 'contact_details', class: 'modal-body' }
        end
      end

      context 'where the user is not the owner of the book' do
        let(:user) { nil }
        context 'and the book is in the shop' do
          let(:in_shop) { true }
          it 'should show to visit the shop' do
            rendered.should have_tag :div, with: { id: 'contact_details', class: 'modal-body' } do
              with_tag :p, text: 'This book is in the Book Coop shop at Level 1 in Union House. Come down and pay us a visit or call us on 9344 XXXX to reserve the book for you!'
            end
          end
        end

        context 'and the book is not in the shop' do
          let(:in_shop) { false }
          context 'and it is owned by the book coop (i.e. by admin user)' do
            let(:admin) { true }
            it 'should show a contact form mentioning that it belongs to the coop' do
              rendered.should have_tag :div, with: { id: 'contact_details', class: 'modal-body' } do
                with_tag :p, text: 'This book belongs to the Book Coop, but is not in the Book Coop shop. Use this form to get in touch with us so we can get the book to you!'
                with_tag :form, with: { action: contacts_path, 'data-remote' => true } do
                  with_hidden_field 'contact[book_id]', '123'
                  with_text_area 'contact[message]'
                  with_text_area 'contact[contact_details]'
                  with_submit 'Send Email'
                end
              end
            end
          end

          context 'and it is owned by a user' do
            let(:admin) { false }
            context 'and the user has permitted direct email from the app' do
              let(:direct_email) { true }
              it 'should show a contact form' do
                rendered.should have_tag :div, with: { id: 'contact_details', class: 'modal-body' } do
                  with_tag :p, text: 'This book belongs to one of the Book Coop\'s users. Use this form to send them an email so you can ask them about the book.'
                  with_tag :form, with: { action: contacts_path, 'data-remote' => true } do
                    with_hidden_field 'contact[book_id]', '123'
                    with_text_area 'contact[message]'
                    with_text_area 'contact[contact_details]'
                    with_submit 'Send Email'
                  end
                end
              end
            end

            context 'and the user has not permitted direct email from the app' do
              let(:direct_email) { false }
              it "should show the user's contact details" do
                rendered.should have_tag :div, with: { id: 'contact_details', class: 'modal-body' } do
                  with_tag :p, text: 'The owner of this book can be contacted using the following details:'
                  with_tag :p, text: 'Knock on my door'
                end
              end
            end
          end
        end
      end
    end
  end
end

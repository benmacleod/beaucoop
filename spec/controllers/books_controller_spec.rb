require 'spec_helper'

describe BooksController, type: :controller do

  let(:book) { mock Book }
  let(:books) { [book] }

  context 'for guests' do
    describe "GET 'index'" do
      context 'requesting expired consignments' do
        it 'should assign expired consignments and render books/index' do
          Book.should_receive(:expired_consignments).and_return books
          get 'index', expired_consignments: 1
          assigns(:books).should == books
          response.should be_success
          response.should render_template 'books/index'
        end
      end

      context 'not requesting expired consignments' do
        it 'should assign all books and render books/index' do
          Book.should_receive(:all).and_return books
          get 'index'
          assigns(:books).should == books
          response.should be_success
          response.should render_template 'books/index'
        end
      end
    end

    describe "GET 'show'" do
      it 'should find and assign the book and render books/show' do
        Book.should_receive(:find).with('123').and_return book
        get 'show', id: 123
        assigns(:book).should == book
        response.should be_success
        response.should render_template 'books/show'
      end
    end


    describe "GET 'new'" do
      it 'should fail authorization' do
        get 'new'
        response.should_not be_success
      end
    end
  end

  context 'for users' do
    login
    let(:book) { mock Book, user_id: user_id }
    let(:user_id) { controller.current_user.id }

    describe "GET 'new'" do
      it 'should render books/new' do
        get 'new'
        response.should be_success
        response.should render_template 'books/new'
      end
    end

    describe "PUT 'update'" do
      before do
        Book.should_receive(:find).with('123').and_return book
      end

      context 'for books they do not own' do
        before do
          controller.should_receive(:authorize!).with(:update, book).and_raise CanCan::AccessDenied.new
        end
        it 'should fail to authorise' do
          put 'update', id: 123, book: { these: 'params' }
          response.should_not be_success
        end
      end

      context 'for books they own' do
        before do
          controller.should_receive(:authorize!).with :update, book
          book.should_receive(:update_attributes).with('title' => 'Yo').and_return success
          put 'update', id: 123, book: { title: 'Yo' }
        end

        context 'where the update succeeds' do
          let(:success) { true }
          it 'should redirect to root and set a flash notice' do
            response.should redirect_to root_url
            flash[:notice].should == 'Book was updated successfully'
          end
        end

        context 'where the update fails' do
          let(:success) { false }
          it 'should assign book, render books/show and set a flash alert' do
            flash[:alert].should == "Sorry, book couldn't be updated"
            response.should render_template 'books/show'
            assigns(:book).should == book
          end
        end
      end
    end
  end
end

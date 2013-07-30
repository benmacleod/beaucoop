class BooksController < ApplicationController
  before_filter :get_book, only: [:show, :destroy, :update]
  decorates_assigned :book

  def index
    @books = Book.all.decorate
  end

  def show
  end

  def new
    authorize! :create, Book
  end

  def search
    if request.post?
      @books = Book.search(book_params).decorate
      if @books.present?
        render 'index'
      else
        redirect_to ({action: :search}).merge(params), notice: "Sorry, couldn't find books matching your search"
      end
    else
      @book = Book.new(params[:book] && book_params)
    end
  end

  def update
    authorize! :update, @book
    if @book.update_attributes book_params
      redirect_to root_url, notice: 'Book was updated successfully'
    else
      flash[:alert] = "Sorry, book couldn't be updated"
      render :show
    end
  end

  def create
    authorize! :create, Book
    @book = Book.new book_params
    if @book.save
      redirect_to root_url, notice: 'Book was created successfully'
    else
      flash[:alert] = "Sorry, book couldn't be created"
      render :new
    end
  end

  def destroy
    authorize! :destroy, @book
    @book.destroy
    redirect_to root_url, notice: 'Book was deleted'
  end

  private
  def get_book
    @book = Book.find params[:id]
  end

  def book_params
    params.require(:book).permit :title, :author, :publisher, :edition, :category, :subject, :isbn, :condition, :price, :consignor, :consigned_date, :in_shop
  end
end

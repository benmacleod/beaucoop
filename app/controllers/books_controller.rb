class BooksController < ApplicationController
  before_filter :get_book, only: [:edit, :show]
  def index

  end

  def show
  end

  def edit
  end

  def new
    @book = Book.new consignor: User.new
  end

  def search
    @book = Book.new
  end

  def update
  end

  def create
  end

  private
  def get_book
    @book = Book.find params[:id]
  end
end

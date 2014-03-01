require 'spec_helper'

describe 'routing for books' do
  it 'should route GET /books/warn_aged to books#warn_aged' do
    { get: '/books/warn_aged' }.should route_to(controller: 'books', action: 'warn_aged')
  end

  it 'should route GET /books/expire_aged to books#expire_aged' do
    { get: '/books/expire_aged' }.should route_to(controller: 'books', action: 'expire_aged')
  end
end

class BookDecorator < Draper::Decorator
  delegate_all

  def delete_button
    if h.can? :destroy, object
      h.link_to 'Delete Book', h.book_path(object), data: { method: 'delete', confirm: 'Are you sure?' }, class: 'btn btn-danger'
    end
  end
end

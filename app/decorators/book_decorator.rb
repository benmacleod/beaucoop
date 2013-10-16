class BookDecorator < Draper::Decorator
  delegate_all

  def delete_button
    if h.can? :destroy, object
      h.link_to 'Delete Book', h.book_path(object), data: { method: 'delete', confirm: 'Are you sure?' }, class: 'btn btn-danger'
    end
  end

  def clear_consignment_button
    if expired_consignment?
      h.link_to 'Clear Consignment', h.book_path(object, book: {consignment_date: '', consignee: ''}), data: { method: 'patch'}, class: 'btn'
    end
  end
end

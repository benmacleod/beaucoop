class ContactsController < ApplicationController
  respond_to :json
  def create
    @contact = Contact.create contact_params
    respond_with @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:book_id, :contact_details, :message).merge(user_id: current_user.andand.id)
  end
end

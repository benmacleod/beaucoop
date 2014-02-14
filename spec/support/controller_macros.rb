module ControllerMacros
  def login(type = :user)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in Fabricate(type)
    end
  end
end

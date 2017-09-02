shared_examples "requires builder" do |method, action, custom_params|
  let(:the_params) { custom_params || (defined?(params) && params) || {} }

  it "returns 403" do
    sign_in FactoryGirl.create(:user, builder: false)
    public_send(method, action, the_params)
    expect(response).to redirect_to request_builder_path
  end
end
shared_examples "disallows non-admins" do |method, action|
  let(:user) { FactoryGirl.create(:user) }
  let(:parameters) { defined?(params) ? params : {} }

  it "returns 403 for non-admin" do
    sign_in user
    public_send(method, action, parameters)
    expect(response).to have_http_status(:forbidden)
  end

  it "returns 403 for non-logged-in user" do
    public_send(method, action, parameters)
    expect(response).to have_http_status(:forbidden)
  end
end
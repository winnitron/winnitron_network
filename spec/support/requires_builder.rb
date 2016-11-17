shared_examples "requires builder" do |method, action, custom_params|
  let(:params) { custom_params || {} }

  it "returns 403" do
    sign_in FactoryGirl.create(:user, builder: false)
    public_send(method, action, params)
    expect(response).to have_http_status :forbidden
  end
end
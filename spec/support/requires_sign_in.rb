shared_examples "requires sign in" do |action, custom_params|
  let(:params) { custom_params || {} }

  it "redirects to sign-in page if signed out" do
    get action, params
    expect(response).to redirect_to new_user_session_path
  end
end
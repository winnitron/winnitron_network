shared_examples "simple GET action" do |action, custom_params|
  let(:the_parameters) { custom_params || (defined?(params) && params) || {} }

  it "renders #{action} template" do
    get action, the_parameters
    expect(response).to render_template(action)
  end

  it "responds 200 OK" do
    get action, the_parameters
    expect(response).to have_http_status :ok
  end
end
shared_examples "disallows bad API keys" do |method, action|
  let(:parameters) { defined?(params) ? params : {} }

  describe "header key" do
    it "returns 403 for blank key" do
      public_send(method, action, { params: parameters })
      expect(response).to have_http_status(:forbidden)
    end

    it "returns 403 for non-existent key" do
      request.headers["Authorization"] = "Token fakefakefake"
      public_send(method, action, { params: parameters })
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "parameter key" do
    it "returns 403 for blank key" do
      public_send(method, action, { params: parameters.except(:api_key) })
      expect(response).to have_http_status(:forbidden)
    end

    it "returns 403 for non-existent key" do
      public_send(method, action, { params: parameters.merge(api_key: "fakefake") })
      expect(response).to have_http_status(:forbidden)
    end
  end
end
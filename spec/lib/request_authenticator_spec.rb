require "rails_helper"

RSpec.describe RequestAuthenticator do
  let(:client) { FactoryBot.create(:arcade_machine) }
  let(:key) { client.api_keys.first }
  let(:params) do
    { a: "A", b: "B", c: "C" }
  end

  describe "no signature required" do
    context "auth in header" do

      it "fails with missing token" do
        req = double(headers: {}, params: {})
        expect(RequestAuthenticator.new(req)).to_not be_valid
      end

      it "fails with wrong token" do
        req = double(headers: { "Authorization" => "Token sdlkjfjksdf" }, params: {})
        expect(RequestAuthenticator.new(req)).to_not be_valid
      end

      it "succeeds with a good token" do
        req = double(headers: { "Authorization" => "Token #{key.token}" }, params: {})
        expect(RequestAuthenticator.new(req)).to be_valid
      end

      it "succeeds with a signed request" do
        right_qs = "a=A&b=B&c=C"
        right_sig = Digest::SHA256.hexdigest(right_qs + key.secret)
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{right_sig}" }, params: params)
        expect(RequestAuthenticator.new(req)).to be_valid
      end

    end

    context "auth in query string" do
      it "fails with wrong token" do
        req = double(headers: {}, params: { api_key: "slkjdf" })
        expect(RequestAuthenticator.new(req)).to_not be_valid
      end

      it "succeeds with a good token" do
        req = double(headers: {}, params: { api_key: key.token })
        expect(RequestAuthenticator.new(req)).to be_valid
      end

      it "succeeds with a signed request" do
        right_qs = "a=A&b=B&c=C"
        right_sig = Digest::SHA256.hexdigest(right_qs + key.secret)
        auth = { api_key: key.token, sig: right_sig }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req)).to be_valid
      end
    end
  end

  describe "signature required" do
    context "auth in header" do
      it "fails with missing signature" do
        req = double(headers: { "Authorization" => "Winnitron #{key.token}" }, params: {})
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid

        req = double(headers: { "Authorization" => "Winnitron #{key.token}:" }, params: {})
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with correct params, wrong signature" do
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:im_bad_at_this" }, params: params)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with missing params, otherwise-correct signature" do
        wrong_qs = "a=A&c=C"
        wrong_sig = Digest::SHA256.hexdigest(wrong_qs + key.secret)
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{wrong_sig}" }, params: params)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with misordered params, otherwise-correct signature" do
        wrong_qs = "a=A&c=C&b=B"
        wrong_sig = Digest::SHA256.hexdigest(wrong_qs + key.secret)
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{wrong_sig}" }, params: params)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with everything done right but with the wrong secret" do
        right_qs = "a=A&b=B&c=C"
        wrong_sig = Digest::SHA256.hexdigest(right_qs + "bad guess")
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{wrong_sig}" }, params: params)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "succeeds with everything Juuuust Right" do
        right_qs = "a=A&b=B&c=C"
        right_sig = Digest::SHA256.hexdigest(right_qs + key.secret)
        req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{right_sig}" }, params: params)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to be_valid
      end

      it "is case insensitive" do
        right_qs = "a=A&b=B&c=C"
        right_sig = Digest::SHA256.hexdigest(right_qs + key.secret)

        upper_req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{right_sig.upcase}" }, params: params)
        lower_req = double(headers: { "Authorization" => "Winnitron #{key.token}:#{right_sig.downcase}" }, params: params)

        expect(RequestAuthenticator.new(upper_req, requires_signature: true)).to be_valid
        expect(RequestAuthenticator.new(lower_req, requires_signature: true)).to be_valid
      end

    end

    context "auth in query string" do
      it "fails with missing signature" do
        req = double(headers: {}, params: {})
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid

        req = double(headers: {}, params: { sig: "" })
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with correct params, wrong signature" do
        auth = { api_key: key.token, sig: "ALL ANSWERS ARE WRONG" }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with missing params, otherwise-correct signature" do
        wrong_qs = "a=A&c=C"
        wrong_sig = Digest::SHA256.hexdigest(wrong_qs + key.secret)
        auth = { api_key: key.token, sig: wrong_sig }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with misordered params, otherwise-correct signature" do
        wrong_qs = "a=A&c=C&b=B"
        wrong_sig = Digest::SHA256.hexdigest(wrong_qs + key.secret)
        auth = { api_key: key.token, sig: wrong_sig }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "fails with everything done right but with the wrong secret" do
        right_qs = "a=A&b=B&c=C"
        wrong_sig = Digest::SHA256.hexdigest(right_qs + "bad guess")
        auth = { api_key: key.token, sig: wrong_sig }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to_not be_valid
      end

      it "succeeds with everything Juuuust Right" do
        right_qs = "a=A&b=B&c=C"
        right_sig = Digest::SHA256.hexdigest(right_qs + key.secret)
        auth = { api_key: key.token, sig: right_sig }
        req = double(headers: {}, params: params.merge(auth).with_indifferent_access)
        expect(RequestAuthenticator.new(req, requires_signature: true)).to be_valid
      end
    end
  end
end

class RequestAuthenticator
  attr_reader :request
  attr_reader :key, :token, :signature
  attr_reader :requires_signature

  def initialize(request, requires_signature: false)
    @request = request
    @requires_signature = requires_signature
    set_token_and_signature
    set_api_key
  end

  def valid?
    requires_signature ? valid_signed_request? : valid_token_request?
  end

  private

  def set_token_and_signature
    auth_header = request.headers["Authorization"]

    if auth_header
      keys = auth_header.split(" ").last
      @token, @signature = keys.split(":")
    else
      @token = request.params[:api_key]
      @signature = request.params[:sig]
    end
  end

  def set_api_key
    @key = ApiKey.find_by(token: token)
  end

  def correct_signature
    # sha256(alphabetized query string by key EXCEPT SIG AND API_KEY + api secret)
    sig_params = request.params.except(:api_key, :sig, :action, :format, :controller)
    alphabetized_qs = Hash[sig_params.sort_by { |k, v| k }].to_query
    Digest::SHA256.hexdigest alphabetized_qs + @key.secret
  end

  def valid_token_request?
    !!key
  end

  def valid_signed_request?
    key && signature == correct_signature
  end

end

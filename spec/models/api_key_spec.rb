require "rails_helper"

describe ApiKey do
  it "inits token and secret" do
    key = ApiKey.new
    key.valid?

    expect(key.token).to_not be_nil
    expect(key.secret).to_not be_nil
  end
end

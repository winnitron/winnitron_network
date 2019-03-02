class MetadataJsonGeneratorController < ApplicationController

  def new
  end

  def create
    @json = params[:game].as_json.with_indifferent_access
    @json.merge!({
      slug:  @json[:title].parameterize,
      local: true,
      keys:  {
        template: "default",
        bindings: KEY_MAP_TEMPLATES["default"].slice(*(1..@json[:max_players].to_i).map(&:to_s))
      }
    })
  end
end

json.array!(@arcade_machines) do |arcade_machine|
  json.extract! arcade_machine, :id
  json.url arcade_machine_url(arcade_machine, format: :json)
end

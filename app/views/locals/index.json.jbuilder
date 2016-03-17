json.array!(@locals) do |local|
  json.extract! local, :id, :name, :type, :parent_id, :abbr
  json.url local_url(local, format: :json)
end

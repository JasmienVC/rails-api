module ApiHelpers
  def json
    JSON.parse(response.body).deep_symbolize_keys
  end

  def json_array
    JSON.parse(response.body)
  end

  def json_data
    json[:data]
  end
end

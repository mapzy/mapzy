# Mapbox relevance is defined from 0 to 1, where 0 is the least relevant and 1 is the most relevant
# @see https://docs.mapbox.com/api/search/geocoding/#geocoding-response-object
RELEVANCE_LIMIT = 0.7
Geocoder::Lookup.get(:mapbox)

Geocoder::Lookup::Mapbox.class_eval do
  # @override: the original method do not implement the filter_relevant_features line
  def results(query)
    return [] unless data = fetch_data(query)

    if data["features"]
      filtered_results = filter_relevant_features(data["features"])
      sort_relevant_feature(filtered_results)
    elsif data["message"] =~ /Invalid\sToken/
      raise_error(Geocoder::InvalidApiKey, data["message"])
    else
      []
    end
  end

  # Filter results with relevance greater than RELEVANCE_LIMIT
  def filter_relevant_features(features)
    features.select { |feature| feature["relevance"] >= RELEVANCE_LIMIT }
  end
end

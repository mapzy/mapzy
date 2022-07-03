# frozen_string_literal: true

namespace :mapzy do
  namespace :migration do
    desc "Generate api key for Maps who don't have one (< schema version 20220617113632)"
    # run automatically by 20220617113632 migration code
    task add_api_key_to_maps: :environment do
      Map.find_each do |map|
        map.create_api_key unless map.api_key
      end
    end
  end
end

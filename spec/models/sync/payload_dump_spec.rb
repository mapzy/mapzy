# frozen_string_literal: true

# == Schema Information
#
# Table name: sync_payload_dumps
#
#  id                :bigint           not null, primary key
#  payload           :jsonb
#  processing_status :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  map_id            :bigint           not null
#
# Indexes
#
#  index_sync_payload_dumps_on_map_id  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
require "rails_helper"

RSpec.describe Sync::PayloadDump, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

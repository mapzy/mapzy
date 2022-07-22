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
module Sync
  class PayloadDump < ApplicationRecord
    belongs_to :map

    enum processing_status: { open: 0, processing: 1, processed: 2, error: 3 },
         _default: :open
  end
end

# frozen_string_literal: true

require "fugu"

class FuguWorker
  include Sidekiq::Worker
  include Fugu

  def perform(name, properties = {})
    Fugu.track(name, properties)
  end
end

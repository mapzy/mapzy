# frozen_string_literal: true

class FuguJob < ApplicationJob
  def perform(name, properties = {})
    Fugu.track(name, properties)
  end
end
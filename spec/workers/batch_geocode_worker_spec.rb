# frozen_string_literal: true

require "rails_helper"

RSpec.describe BatchGeocodeWorker, type: :worker do
  let(:map) { create(:map) }

  describe "perform" do
    context "with a map not found" do
      it "returns nil" do
        expect(subject.perform(999_999)).to be_nil
      end
    end

    context "when the map desn't have any pending locations" do
      it "returns nil" do
        expect(subject.perform(map.id)).to be_nil
      end
    end

    Sidekiq::Testing.inline! do
      context "when the map has pending locations" do
        let!(:pending_location) do
          create(:location, map_id: map.id, address: "Paris", skip_geocoding: true)
        end

        context "when the geocoding works" do
          before do
            Geocoder::Lookup::Test.add_stub("Paris", [{ coordinates: [1.0, 1.0] }])
          end

          it "decreases the geocoding_pending count" do
            expect { subject.perform(map.id) }.to change {
              map.locations.geocoding_pending.count
            }.by(-1)
          end

          it "increases the geocoding_success count" do
            expect { subject.perform(map.id) }.to change {
              map.locations.geocoding_success.count
            }.by(1)
          end

          it "doesn't change the geocoding_error count" do
            expect { subject.perform(map.id) }.not_to change {
              map.locations.geocoding_error.count
            }
          end
        end

        context "when the geocoding fails" do
          before do
            Geocoder::Lookup::Test.add_stub("Paris", [{ coordinates: [nil, nil] }])
          end

          it "decreases the geocoding_pending count" do
            expect { subject.perform(map.id) }.to change {
              map.locations.geocoding_pending.count
            }.by(-1)
          end

          it "doesn't chanhge the geocoding_success count" do
            expect { subject.perform(map.id) }.not_to change {
              map.locations.geocoding_success.count
            }
          end

          it "increases the geocoding_error count" do
            expect { subject.perform(map.id) }.to change {
              map.locations.geocoding_error.count
            }.by(1)
          end
        end

        context "when the geocoder could not be reached" do
          before do
            allow_any_instance_of(Location).to receive(:geocode).and_return(nil)
          end

          it "raises an error so that the worker can be retried" do
            expect { subject.perform(map.id) }.to raise_error(RuntimeError)
          end
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe TrackPageModificationsJob, type: :job do
  describe "#perform" do
    let(:host) { "test.host" }
    let(:tracker) { instance_double(PageModificationTracker) }

    before do
      allow(PageModificationTracker).to receive(:new).with(host: host).and_return(tracker)
      allow(tracker).to receive(:track_page_modifications)
    end

    it "enqueues the job in the default queue" do
      expect {
        described_class.perform_later(host:)
      }.to have_enqueued_job(described_class).on_queue("default")
    end

    it "tracks page modifications with the provided host" do
      described_class.perform_now(host: host)
      expect(tracker).to have_received(:track_page_modifications)
    end
  end
end

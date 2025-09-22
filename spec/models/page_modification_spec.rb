require 'rails_helper'

RSpec.describe PageModification, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_presence_of(:content_hash) }
  end
end

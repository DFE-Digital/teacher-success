require 'rails_helper'

RSpec.describe SupportRequest, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name).with_message("Please enter a name") }
    it { is_expected.to validate_presence_of(:email).with_message("Please enter an email") }
    it { is_expected.to validate_presence_of(:problem).with_message("Please enter the problem you are experiencing") }
    it { is_expected.to validate_presence_of(:area_of_website).with_message("Please select an area of the website") }
  end

  describe "enums" do
    subject(:support_request) { build(:support_request) }

    it "defines the expected values" do
      expect(support_request).to define_enum_for(:area_of_website)
         .with_values(whole_site: "whole_site", specific_page: "specific_page")
         .backed_by_column_of_type(:enum)
    end
  end
end

re 'spec_helper'

RSpec.describe PageNotFoundError do
  describe '#initialize' do
    let(:slug) { 'nonexistent-page' }
    subject(:error) { described_class.new(slug) }

    it 'inherits from StandardError' do
      expect(error).to be_a(StandardError)
    end

    it 'sets a custom error message with the slug' do
      expect(error.message).to eq("Page not found for slug: 'nonexistent-page'")
    end
  end
end

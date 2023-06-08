# frozen_string_literal: true

RSpec.shared_examples 'filter' do |result|
  subject(:filter) do
    defined?(filter_config) ? described_class.new(filter_config) : described_class.new
  end

  it "returns #{result}" do
    expect(filter.filter(record)).to be(result)
  end
end

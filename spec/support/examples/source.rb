# frozen_string_literal: true

RSpec.shared_examples 'source' do |result|
  subject(:source) { described_class.new(source_config) }

  let(:rows) do
    [
      { record_id: '1', first_name: 'Shredward', last_name: 'Whiskers' },
      { record_id: '2', first_name: 'Timmy', last_name: 'Tester' },
      { record_id: 'C-40', first_name: 'Bobbert', last_name: '"Bobby" Bobberson' }
    ]
  end

  it 'yields expected records' do
    expect { |probe| source.each(&probe) }.to yield_successive_args(*rows)
  end
end

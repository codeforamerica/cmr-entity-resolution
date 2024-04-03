# frozen_string_literal: true

require_relative '../../../../lib/api/parser/csv'

describe API::Parser::CSV do
  describe '.call' do
    let(:object) do
      <<~CSV
        "source","party_id","first_name","last_name","dob"
        "parties","12345","John","Doe","1980-01-01"
      CSV
    end
    let(:env) { {} }

    it 'parses the object' do
      expect(described_class.call(object, env)).to eq({
                                                        'source' => 'parties',
                                                        'party_id' => '12345',
                                                        'first_name' => 'John',
                                                        'last_name' => 'Doe',
                                                        'dob' => '1980-01-01'
                                                      })
    end
  end
end

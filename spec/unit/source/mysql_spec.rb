# frozen_string_literal: true

require_relative '../../../lib/source/mysql'

describe Source::MySQL do
  describe '#each' do
    let(:source_config) do
      {
        table: 'rspec',
        host: 'rspec.com',
        database: 'rspec',
        user: 'whiskers',
        password: 'clearmyrecrod',
        security: false
      }
    end

    it_behaves_like 'source' do
      before do
        allow(Sequel).to receive(:connect).and_return(Sequel.mock(fetch: rows))
      end
    end
  end
end

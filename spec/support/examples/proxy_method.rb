# frozen_string_literal: true

RSpec.shared_examples 'proxy method' do |method|
  context 'when object has not been created' do
    before { senzing.instance_variable_set("@#{method}", nil) }

    it 'returns a new object' do
      expect(senzing.send(method)).to eq(object)
    end

    it 'instantiates a new object' do
      senzing.send(method)
      expect(Faraday).to have_received(:new)
    end
  end

  context 'when object has been created' do
    before { senzing.instance_variable_set("@#{method}", object) }

    it 'returns the previously set object' do
      expect(senzing.send(method)).to eq(object)
    end

    it 'does not try to create a new object' do
      expect(Faraday).not_to have_received(:new)
    end
  end
end

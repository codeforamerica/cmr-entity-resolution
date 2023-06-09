# frozen_string_literal: true

RSpec.shared_examples 'proxy method' do |method, klass|
  before do
    allow(klass).to receive(:new).and_return(object)
  end

  context 'when object has not been created' do
    before { subject.instance_variable_set("@#{method}", nil) }

    it 'returns a new object' do
      expect(subject.send(method)).to eq(object)
    end

    it 'instantiates a new object' do
      subject.send(method)
      expect(klass).to have_received(:new)
    end
  end

  context 'when object has been created' do
    before { subject.instance_variable_set("@#{method}", object) }

    it 'returns the previously set object' do
      expect(subject.send(method)).to eq(object)
    end

    it 'does not try to create a new object' do
      expect(klass).not_to have_received(:new)
    end
  end
end

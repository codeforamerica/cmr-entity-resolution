# frozen_string_literal: true

FactoryBot.define do
  factory :senzing, class: 'Senzing' do
    initialize_with { new(build(:config)) }

    after(:build) do |factory|
      allow(factory).to receive(:upsert_record)
    end
  end
end

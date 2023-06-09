# frozen_string_literal: true

FactoryBot.define do
  factory :destination_csv, class: 'Destination::CSV' do
    initialize_with do
      new(field_map: {
            ENTITY_ID: 'entity_id',
            RECORD_ID: 'record_id',
            PRIMARY_NAME_FIRST: 'first_name',
            PRIMARY_NAME_LAST: 'last_name'
          })
    end

    after(:build) do |factory|
      allow(factory).to receive(:add_record)
    end
  end
end

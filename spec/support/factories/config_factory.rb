# frozen_string_literal: true

FactoryBot.define do
  factory :config, class: 'Config' do
    sources { { factory: { type: 'CSV', name: :factory } } }
    destination { { type: 'CSV' } }
    filters { [{ filter: 'NonHuman' }] }
  end
end

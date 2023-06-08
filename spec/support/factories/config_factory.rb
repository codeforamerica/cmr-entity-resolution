# frozen_string_literal: true

FactoryBot.define do
  factory :config, class: 'Config' do
    sources { [{ type: 'CSV' }] }
    destination { { type: 'CSV' } }
  end
end
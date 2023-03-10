# frozen_string_literal: true

require 'yaml'
require_relative 'base'

module Filter
  # Filters out non-human entities such as corporations.
  class NonHuman < Base
    # Apply the filter to a record to determine if it should be kept.
    #
    # @param record [CSV::ROW] The record to apply the filter to.
    # @return [Boolean] Whether or not the record should be kept.
    def filter(record)
      full_name = record['PRIMARY_NAME_FULL'] || [
        record['PRIMARY_NAME_FIRST'],
        record['PRIMARY_NAME_MIDDLE'],
        record['PRIMARY_NAME_LAST']
      ].compact.join(' ')

      !(exact?(record, full_name) || beginning?(full_name) ||
        ending?(full_name) || middle?(full_name) || anywhere?(full_name))
    end

    private

    def matchers
      @matchers ||= YAML.load_file(File.join(__dir__, 'non_human.yml'))
    end

    def anywhere?(full_name)
      matchers['anywhere'].any? { |match| full_name =~ /^.*#{match}.*$/ }
    end

    def beginning?(full_name)
      matchers['beginning'].any? { |match| full_name =~ /^#{match}\s/ }
    end

    def ending?(full_name)
      matchers['ending'].any? { |match| full_name =~ /\s#{match}$/ }
    end

    def exact?(record, full_name)
      matchers['exact'].any? do |match|
        full_name == match || record['PRIMARY_NAME_FIRST'] == match ||
          record['PRIMARY_NAME_LAST'] == match
      end
    end

    def middle?(full_name)
      matchers['middle'].any? { |match| full_name =~ /\s#{match}\s/ }
    end
  end
end

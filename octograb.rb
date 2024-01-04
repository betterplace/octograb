#!/Users/daniel/.asdf/shims/ruby

require 'tins/go'
require './lib/octograb/client'

include Tins::GO

module OctoGrab
  class Main
    def initialize
      @client = OctoGrab::Client.new(access_token: access_token, repo: 'betterplace/betterplace')
    end

    def prs
      @client.closed_pulls
    end

    def duration(pr)
      (pr.closed_at - pr.created_at) / 3600
    end

    def format_duration(pr)
      duration = (pr.closed_at - pr.created_at).to_i
      seconds = duration % 60
      minutes = (duration / 60) % 60
      hours   = (duration / 3600) % 24
      days    = duration / 3600 / 24
      "%d days %02d:%02d:%02d" % [days, hours, minutes, seconds]
    end

    def hours
      @hours ||= prs.map { |pr| duration(pr) }
    end

    def list
      @list ||= prs.map { |pr| "#{format_duration(pr)} #{pr.title}" }
    end

    def median
      le = hours.length
      case
        when le == 0
          0
        when le % 2 == 0
          (hours[(le / 2) - 1] + hours[le / 2]) / 2.0
        else
          hours[le / 2]
      end
    end

    def mean
      hours.sum / hours.length
    end

    def fast_ratio
      hours.select { |h| h < 12 }.length.to_f / hours.length.to_f
    end

    def output
      puts "Median: #{median.round}"
      puts "Mean: #{mean.round}"
      puts "Fast Ratio: #{fast_ratio * 100}%"
      puts list
    end

    def access_token
      ENV['GITHUB_TOKEN'] || (raise "Set GITHUB_TOKEN")
    end

  end
end

OPTS = go 'h'

OctoGrab::Main.new.output

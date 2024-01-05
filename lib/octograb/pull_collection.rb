module OctoGrab
  class PullCollection

    def initialize(data:)
      @pulls = data.map { |pr_data| OctoGrab::Pull.new(data: pr_data) }
    end

    def hours
      @hours ||= @pulls.map(&:hours)
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

    def format
      @pulls.map(&:format)
    end

  end
end

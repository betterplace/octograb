module OctoGrab
  class Pull
    def initialize(data:)
      @data = data
    end

    # pr duration in seconds
    def duration_in_seconds
      (@data.closed_at - @data.created_at).to_i
    end

    def hours
      duration_in_seconds / 3600
    end

    def format
      seconds = duration_in_seconds % 60
      minutes = (duration_in_seconds / 60) % 60
      hours   = (duration_in_seconds / 3600) % 24
      days    = duration_in_seconds / 3600 / 24
      "%d days %02d:%02d:%02d - #{@data.title}" % [days, hours, minutes, seconds]
    end

    def dump
      puts @data.inspect
    end
  end
end

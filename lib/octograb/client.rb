require 'octokit'

module OctoGrab
  class Client
    def initialize(repo:, access_token:)
      @octokit_client = Octokit::Client.new(access_token: access_token)
      @repo = repo
    end

    def closed_pulls
      @closed_pulls ||= @octokit_client.pulls(@repo, state: :closed)
    end

  end
end

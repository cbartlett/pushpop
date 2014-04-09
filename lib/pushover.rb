require 'logger'
require 'clockwork'
require 'pushover/job'
require 'pushover/step'

module Pushover
  class << self
    cattr_accessor :logger
    cattr_accessor :jobs

    self.jobs = []

    def add_job(name, &block)
      self.jobs.push(Job.new(name, &block))
    end

    def run
      self.jobs.map &:run
    end

    def schedule
      self.jobs.map &:schedule
    end
  end
end

# add into main
def job(name, &block)
  Pushover.add_job(name, &block)
end

Pushover.logger = lambda {
  logger = Logger.new($stdout)
  if ENV['DEBUG']
    logger.level = Logger::DEBUG
  elsif ENV['RACK_ENV'] == 'test'
    logger.level = Logger::FATAL
  else
    logger.level = Logger::INFO
  end
  logger
}.call


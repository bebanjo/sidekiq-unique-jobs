# frozen_string_literal: true

class SimpleWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed,
                  queue: :default,
                  unique_args: (lambda do |args|
                    [args.first]
                  end)

  def perform(some_args)
    Sidekiq::Logging.with_context(self.class.name) do
      SidekiqUniqueJobs.logger.debug { "#{__method__}(#{some_args})" }
    end
    sleep 1
  end
end

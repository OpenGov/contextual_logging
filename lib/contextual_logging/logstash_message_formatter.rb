module ContextualLogging
  class LogstashMessageFormatter
    def format(severity, message, extra_context)
      message = message[0..1999] if severity == 'INFO'
      msg_hash = HashWithIndifferentAccess.new('message' => message, 'log_level' => severity)
      logstash_data = extra_context.merge(msg_hash)
      logstash_event = LogStash::Event.new(logstash_data)
      logstash_event.to_json
    end
  end
end

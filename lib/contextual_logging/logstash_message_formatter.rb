module ContextualLogging
  class LogstashMessageFormatter
    MAX_MESSAGE_LENGTH = 2000

    def format(severity, message, extra_context)
      if severity == 'INFO'
        truncated_message = truncate(message)
        limited_extra_context = truncate_log_extra_context(extra_context)
      else
        truncated_message = message
        limited_extra_context = extra_context
      end

      logstash_data = HashWithIndifferentAccess.new(
        'message' => truncated_message,
        'log_level' => severity
      ).merge(limited_extra_context)

      logstash_event = LogStash::Event.new(logstash_data)
      logstash_event.to_json
    end

    private

    def truncate(message)
      message[0...MAX_MESSAGE_LENGTH]
    end

    def truncate_log_extra_context(extra_context)
      extra_context.each_with_object(HashWithIndifferentAccess.new) do |(key, value), limited_extra_context|
        if value.is_a?(Hash)
          limited_extra_context[key] = HashWithIndifferentAccess.new
          value.each do |k, v|
            if v.is_a?(String)
              limited_extra_context[key][k] = truncate(v)
            else
              limited_extra_context[key][k] = truncate(v.inspect)
            end
          end
        else
          limited_extra_context[key] = value
        end
      end
    end
  end
end

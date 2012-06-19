# These methods become class methods on a model that calls #subscribe_me_using.
# They provide config bootstrapping easy access to loaded configuration.
module CampaignMonitorSubscriber
  module Configuration
    # Load config from yaml and #subscribe_me_using arguments.
    def load_cms_configuration(email_field, options)
      options.stringify_keys!
      # Load the list_id from the yaml file. If a list is specified in #subscribe_me_using
      # then load the id under the '*given_list_name*_id' key.
      # Otherwise use the value as defined under the 'list_id' key.
      cms_config.list_id = raw_cms_config.fetch("#{options.delete('list')}_list_id", raw_cms_config['list_id'])

      # Load the API key from the yaml file.
      CreateSend.api_key raw_cms_config['api_key']

      # Extract config from the options supplied to #subscribe_me_using.
      cms_config.email_field = email_field
      cms_config.name_field = options.delete('name')
      cms_config.custom_fields = options
    end

    def cms_config
      @cms_config ||= CMSConfig.new.config     
    end

    # We namespace the AS::config in case this
    # model already uses AS's configurable. Because we care :)
    class CMSConfig
      include ActiveSupport::Configurable
    end
  end
end

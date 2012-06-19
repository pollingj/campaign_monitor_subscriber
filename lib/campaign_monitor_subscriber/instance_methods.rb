# These methosd became instance methods on a model that calls #subscribe_me_using.
# They provide easy access to parsed CMS config values.
module CampaignMonitorSubscriber 
  module InstanceMethods
    def cms_custom_fields
      cms_config.custom_fields.inject({}) { |h, (k, v)| h[k] = send(v); h }
    end

    def cms_email
      send(cms_config.email_field)
    end

    def cms_name
      cms_config.name_field ? send(cms_config.name_field) : cms_email
    end

    def cms_config
      self.class.cms_config
    end
  end
end

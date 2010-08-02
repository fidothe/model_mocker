require 'rails'
require 'model_mocker'

module UrlKeyedObject
  class Railtie < Rails::Railtie
    initializer 'model_mocker.active_record_hook', :after => :preload_frameworks do
      ::ActiveRecord::Base.extend ModelMocker::ActiveRecordHook
    end
  end
end
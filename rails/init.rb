require 'model_mocker'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ModelMocker::ActiveRecordHook
end
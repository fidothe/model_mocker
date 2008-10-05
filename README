ModelMocker
===========

This plugin gives you an easy way of generating partially mocked ActiveRecord model objects. This is a useful way of simulating some aspects of a model (like the persistence layer) but leaving the domain logic parts intact, so that you test those in isolation, without worry about database reads and writes.

It's similar to RSpec's mock_model method, but gives you a slightly more declarative way of going about things. I found myself wanting something along these lines a long time ago, and created something very simple that I've used in several projects. More recently I've found myself wanting to easily control certain kinds of behaviour in controller specs, like wanting to ensure that a model instance is valid to allow easy and declarative speccing of the controller.

The plugin adds a `mock` method to `ActiveRecord::Base` when `mock_models` is required, which behaves a lot like `AR::Base.new` or `AR::Base.create`, except that you can specify an ID too. Special behaviour is added by passing a block to `mock` and calling methods on the object it yields.

Examples
--------

To create a mocked model instance which behaves as it's been fetched from the DB:

    ModelClass.mock(:id => 1)

To create one which behaves as if it's a new record

    ModelClass.mock { |m| m.as_new_record }

One which is new and will always report that is invalid, whether or not ActiveRecord validations have been met or not.

    ModelClass.mock do |m|
      m.as_new_record
      m.invalid
    end

The [RDoc][] for the instance methods on ModelMocker gives a complete rundown of what's possible.

[RDoc]: ./rdoc/

Copyright (c) 2008 Matt Patterson, released under the MIT license

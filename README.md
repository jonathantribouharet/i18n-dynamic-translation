I18n Dynamic Translation
======================

Plugin for have translations in model.

Installation
------------

Include the gem in your Gemfile:

	gem 'i18n-dynamic-translation', :git => 'https://github.com/eviljojo22/i18n-dynamic-translation'


Usage
-----

In your model:
	
	class Article < ActiveRecord::Base
		
		dynamic_translation :name

	end

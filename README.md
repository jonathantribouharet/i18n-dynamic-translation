I18n Dynamic Translation
======================

Plugin for have translations in model.
Save the translations in database with gem 'i18n-active_record'.
Very usefull for multilingual site.

Installation
------------

Include the gem in your Gemfile:

	gem 'i18n-active_record',
	     :git => 'git://github.com/jonathantribouharet/i18n-active_record.git',
	     :branch => 'rails-3.2',
	     :require => 'i18n/active_record'
	gem 'i18n-dynamic-translation', :git => 'https://github.com/jonathantribouharet/i18n-dynamic-translation'


Usage
-----

In your model:
	
	class Article < ActiveRecord::Base
		
		dynamic_translation :name

	end

In your form:

	<%= form_for @article fo |f| %>
		<% for locale in I18n.available_locales %>
			<%= f.text_field "name_#{locale}_raw"
		<% end %>

		<%= f.submit %>
	<% end %>

In your html:

	I18n.locale : <%= @article.name %>
	EN : <%= @article.name_en %>
	FR : <%= @article.name_fr %>

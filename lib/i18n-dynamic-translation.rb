module ActiveRecord; module Acts; end; end
module ActiveRecord::Acts::I18nDynamicTranslation
  
	def self.included(klass)
		klass.class_eval do
			extend(ClassMethods)
		end
	end

	module ClassMethods

		def dynamic_translation(attribute_name, options = [])

			after_save do
				for locale in I18n.available_locales
					new_value = instance_variable_get("@#{attribute_name}_#{locale}_raw")
					tr = ::Translation.where(:locale => locale).where(:key => "activerecord.models.#{self.class.model_name.i18n_key}.id_#{self.id}.#{attribute_name}").first
					if !tr
						tr = ::Translation.new(:locale => locale, :key => "activerecord.models.#{self.class.model_name.i18n_key}.id_#{self.id}.#{attribute_name}")
					end
					if !tr.new_record? || (new_value && tr.value != new_value)
						tr.value = new_value
						tr.save!
						I18n.reload!
					end
				end
			end

			define_method(attribute_name) do
				send("#{attribute_name}_#{I18n.locale}")
			end

			for locale in I18n.available_locales

				attr_accessor "#{attribute_name}_#{locale}_raw".to_sym

				define_method("#{attribute_name}_#{locale}") do
					my_locale = __method__.to_s.split('_').last
					new_options = {}
					# for key in options
						# new_options[key] = self.send(key)
					# end
					new_options[:locale] = my_locale
					I18n.t("activerecord.models.#{self.class.model_name.i18n_key}.id_#{self.id}.#{attribute_name}", new_options)
				end

				define_method("#{attribute_name}_#{locale}_raw") do
					my_locale = __method__.to_s.split('_')[-2]
					value = instance_variable_get("@#{attribute_name}_#{my_locale}_raw")

					if !value && !self.new_record?
						tr = ::Translation.where(:locale => my_locale).where(:key => "activerecord.models.#{self.class.model_name.i18n_key}.id_#{self.id}.#{attribute_name}").first
						if tr
							value = tr.value
							instance_variable_set("@#{attribute_name}_#{my_locale}_raw", value)
						end
					end

					value
				end

			end

		end	
	end

end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::I18nDynamicTranslation)

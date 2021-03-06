class ActiveRecord::Base
  # ---------------------------------------------------------------------------
  # options[:except_list]: list of symbols that we will exclude form this copy
  # options[:dont_overwrite]: if true, all attributes in from_model that aren't #blank? will be preserved
  def self.copy_attributes_between_models(from_model, to_model, options = {})
  	return unless from_model && to_model
  	except_list = options[:except_list] || []
  	except_list << :id
  	to_model.attributes.each do |attr, val|
  		to_model[attr] = from_model[attr] unless except_list.index(attr.to_sym) || (options[:dont_overwrite] && !to_model[attr].blank?)
  	end
  	to_model.save
  	to_model
  end
  
  def self.excluded_on_export(*args)
    @@exportable = (self.attributes.keys - args.map(&:to_sym))
  end
  
  def self.grid_date(date)
    date.strftime("%m/%d %I:%M%p").gsub(/(AM|PM)$/){ |match| match.downcase }
  end
end
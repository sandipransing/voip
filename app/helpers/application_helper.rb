# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def content_for?(var)
    content_var_name="@content_for_#{var}"    
    !instance_variable_get(content_var_name).nil?
  end
end

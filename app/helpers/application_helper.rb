# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def delete_link(object, destroy_multiple = true, title = nil)
    owner_id = object.respond_to?("user_id") && object.user_id
    if admin? || (current_user && owner_id == current_user.id)
      dl = "<p>#{title}<br />"
      if object.deleted_at
        dl += "Deleted by #{User.find(object.deleted_by).username} at #{object.deleted_at} | "
        dl += link_to("Undelete", object, :method => :put, :confirm => "Are you sure you wish to undelete this #{object.class}?")
    		if app_admin? && destroy_multiple
    			dl += " | " + check_box_tag("#{object.class.to_s.downcase}_ids[]", 
    			  object.id, true, :id => "destroy_#{object.id}")
    			dl += label_tag "destroy_#{object.id}", "Destroy"
    		end
    	else
    	  dl += link_to "Delete", object, :method => :delete,
    	    :confirm => "Are you sure you wish to delete this #{object.class.to_s}?"
    	end
    	dl + "</p>"
    end
  end
  
  def sort_link(title, column, sorting = true)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_if sorting, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
  
  FLASH_NOTICE_KEYS = [:error, :notice, :warning]

  def flash_messages
    return unless messages = flash.keys.select{|k| FLASH_NOTICE_KEYS.include?(k)}
    formatted_messages = messages.map do |type|      
      content_tag :div, :id => "flash_#{type.to_s}" do
        type.to_s.humanize + ": " + message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end
    formatted_messages.join
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
      message % link_to(*item)
    else
      message % item
    end
  end
end

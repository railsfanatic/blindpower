# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def delete_link(object, destroy_multiple = true)
    owner_id = object.respond_to?("user_id") && object.user_id
    if admin? || (current_user && owner_id == current_user.id)
      if object.deleted_at
        dl = "Deleted by #{User.find(object.deleted_by).username} | "
        dl += link_to("Undelete", object, :method => :put)
    		if app_admin? && destroy_multiple
    			dl += " | " + check_box_tag("#{object.class.to_s.downcase}_ids[]", 
    			  object.id, true, :id => "destroy_#{object.id}")
    			dl += label_tag "destroy_#{object.id}", "Destroy"
    		end
    	else
    	  dl = link_to "Delete", object, :method => :delete,
    	    :confirm => "Are you sure you wish to delete this #{object.class.to_s}?"
    	end
    	dl
    end
  end
  
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
end

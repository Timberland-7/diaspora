#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module AspectGlobalHelper
  def aspects_with_post(aspects, post)
    aspects.select do |aspect|
      AspectVisibility.exists?(:aspect_id => aspect.id, :post_id => post.id)
    end
  end

  def link_for_aspect(aspect, opts={})
    opts[:params] ||= {}
    params ||= {}
    opts[:params] = opts[:params].merge("a_ids[]" => aspect.id, :created_at => params[:created_at])
    opts[:class] ||= ""
    opts[:class] << " hard_aspect_link"
    opts['data-guid'] = aspect.id

    link_to aspect.name, aspects_path( opts[:params] ), opts
  end

  def aspect_listing_link_opts aspect
    if controller.instance_of?(ContactsController)
      {:href => contacts_path(:a_id => aspect.id)}
    else
      {:href => aspects_path("a_ids[]" => aspect.id), :class => "aspect_selector name hard_aspect_link", 'data-guid' => aspect.id}
    end
  end

  def aspect_or_all_path(aspect)
    if @aspect.is_a? Aspect
      aspect_path @aspect
    else
      aspects_path
    end
  end

  def aspect_dropdown_list_item(aspect, contact, person)
    checked = (contact.persisted? && contact.aspect_memberships.detect{ |am| am.aspect_id == aspect.id})
    klass = checked ? "selected" : ""
    hidden = !checked ? "hidden" : ""

    str = <<LISTITEM
<li data-aspect_id=#{aspect.id} class='#{klass}'>
  <img src='/images/icons/check_yes_ok.png' width=18 height=18 class='check #{hidden}'/>
  <img src='/images/icons/check_yes_ok_white.png' width=18 height=18 class='checkWhite'/>
  #{aspect.name}
  <div class=\"hidden\">
    #{aspect_membership_button(aspect, contact, person)}
  </div>
</li>
LISTITEM
    str.html_safe
  end
end

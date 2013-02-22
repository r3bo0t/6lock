module ApplicationHelper

  def set_head(title, description = "")
    content_for :head do
      content_tag(:title, "6LOCK - #{title}") + "<meta name='description' content='#{description}'>".html_safe
    end
  end

end

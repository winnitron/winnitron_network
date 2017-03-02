module ApplicationHelper
  def set_title(title)
    content_for :title, strip_tags(title)
  end

  def page_heading(tag, heading)
    set_title heading
    content_tag tag, heading.html_safe
  end
end

module ApplicationHelper

  def escape_privacy_data text
    if text
      text = text.gsub(/([\._a-zA-Z0-9-]+@[\._a-zA-Z0-9-]+)/, ' ')
      text = text.gsub(/([9|6])+([0-9\s*]{8,})/, ' ')
      text
    end
  end

  def get_location_options(woeid)
    # receives a woeid, returns a list of names like it
    WoeidHelper.search_by_name(woeid.to_s)
  end

  def cache_key_for(key, current_user)
    key += current_user ? "user_" + current_user.admin?.to_s : "user_nil"
    Digest::MD5.hexdigest(key)
  end

  #Text to markdown
  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, fenced_code_blocks: true, tables: true, highlight: true)
    @markdown.render(content)
  end

  #Active class on menus
  def menu_class(tab)
    return 'active' if tab == @current_tab
    ' '
  end

  #Active class on submenus
  def submenu_class(tab)
    return 'active' if tab == @current_submenu
    ' '
  end

  def text_for(code)
    if text = Text.where(code: code).first
      markdown(text.body).html_safe
    end
  end

end

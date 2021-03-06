module ApplicationHelper
  def flash_messages
    message_divs = []
    [:error, :notice].each do |key|
      next unless massage = flash[key]
      message_p = content_tag(:p, massage, :class => key)
      message_divs << content_tag(:div, message_p, :class=>"message")
    end
    flash.clear # Защита для того, чтобы не вывести flash дважды
    content_tag :div, message_divs.join(''), {:id => "flash_messages"}, false
  end

  def home_path
    "http://#{account_domain}/admin/home"
  end

  def account_domain
    session[:shop] || @account.insales_subdomain
  end

  def app_name
    'MrJones приложение'
  end

  def show_product_url(product)
    "<div class='outer'>
      <div><b>#{product["product_id"]}: #{product["product_title"]}</b></div>
      <div>Требует обновления: #{product["need_update"]}</div>
      #{product["product_links"]}
    </div>"
  end

  def show_product_url2(product_arr)
    product = product_arr[0]
    cnt = product_arr.count
    "<div class='outer'>
      <div><b>#{product["product_id"]}: #{product["product_title"]}</b></div>
      <div>Количество ссылок, будет обновлено: #{cnt}</d
    </div>"
  end

end

module ApplicationHelper

  def hold_it(width, height, text = "")
    text = text.gsub(/\s/, '+')
    url = placehold_it(width, height, text)
    image_tag url, size: "#{width}x#{height}"
  end

  def placehold_it(width, height, text = "")
    "http://placehold.it/#{width}x#{height}&text=#{text}+(#{width}x#{height})"
  end
end

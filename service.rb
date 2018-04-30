require 'csv'
require "open-uri"
require "nokogiri"
require "pry-byebug"
require_relative "recipe"
BASESEARCH = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt="
BASEIMPORT = "http://www.letscookfrench.com"

class Service

    def search_online(keyword)
    path = BASESEARCH + keyword
    html_file = open(path).read
    html_doc = Nokogiri::HTML(html_file)
    result = []
    html_doc.search(".m_contenu_resultat a").each_with_index do |element,index|
      if index < 5
        result << {title: element["title"], url: element["href"]}
      end
    end
    # byebug
    return result
  end

  def import_online(search_result)
    path = BASEIMPORT + search_result[:url]
    html_file = open(path).read
    html_doc = Nokogiri::HTML(html_file)
    cooktime = html_doc.search(".cooktime").text
    description = html_doc.search(".m_content_recette_todo").text.strip
    title = search_result[:title]
    [title, description, cooktime]
  end

end

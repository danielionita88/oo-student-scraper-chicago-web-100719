require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []
    page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}
    social_links = page.css(".social-icon-container").children.css('a').map{|tag| tag.attribute('href').value}
    social_links.each do |link|
      if link.include?('linkedin')
        student[:linkedin] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("github")
        student[:github]=link
      else
        student[:blog] = link
      end
    end
    if page.css(".profile-quote")
      student[:profile_quote]=page.css(".profile-quote").text
    end
    if page.css("div.description-holder p").text
      student[:bio] = page.css("div.description-holder p").text
    end
    student
  end
  
end

Scraper.scrape_index_page("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")


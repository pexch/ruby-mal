require 'nokogiri'
require 'open-uri'
require 'stringex'

require_relative 'anime_episode'

class Anime
    attr_accessor :id, :page_url, :mal_params, :title, :image, :synopsis, :score, :episodes

    def initialize(page_url)
        @page_url = page_url
        @episodes = [] # Initialise episodes
        crawl_info()
    end
    
    def crawl_info()
        @mal_params = @page_url.match(/anime\/(.*)/)[1].split('/')

        html = URI.open(@page_url)
        content = Nokogiri::HTML(html)

        container = content.css("div[id=contentWrapper] table")

        anime_title = content.css("div[id=contentWrapper] h1.title-name")[0].content.strip

        left_side = container.css(".leftside")
        right_side = container.css(".rightside")

        anime_synopsis = right_side.css("p[itemprop=description]")[0].content.strip
        anime_score = right_side.css(".score-label")[0].content.strip
        anime_image_url = left_side.css("img")[0]["data-src"]

        @id = anime_title.downcase.to_url
        @title = anime_title
        @image = anime_image_url
        @synopsis = anime_synopsis
        @score = anime_score

        crawl_episodes()
    end

    def crawl_episodes()
        html = URI.open("https://myanimelist.net/anime/#{@mal_params[0]}/#{@mal_params[1]}/video")
        content = Nokogiri::HTML(html)

        content.css('.episode-video .js-video-list-content .video-list-outer').each do |episode|
            episode_no = episode.css('.info-container .title')[0].content.strip.delete("^0-9")
            episode_title = episode.css('.info-container .episode-title')
            episode_title = episode_title.length > 0 ? episode_title[0].content.strip : "Episode #{episode_no}"
            episode_image = episode.css('img')[0]['data-src']

            @episodes.push(AnimeEpisode.new(episode_no, episode_title, episode_image))
        end
    end
end
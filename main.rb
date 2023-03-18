require 'open-uri'
require 'nokogiri'
require 'json'

require_relative 'cls/anime'

puts "Enter a MAL URL: "
page_url = gets.chomp()

anime = Anime.new(page_url)

puts "Successfully crawled the information."
available_args = "title, image, synopsis, score, episodes, json, stop"

started = true
while started
    puts "Choose an arg (#{available_args}): \n"
    option = gets.chomp()
    puts "\n"
    
    case option
        when "title"
            puts "Anime Title: #{anime.title}"
        when "image"
            puts "Anime Image: #{anime.image}"
        when "synopsis"
            puts "Anime Synopsis: #{anime.synopsis}"
        when "score"
            puts "Anime Score: #{anime.score}"
        when "episodes"
            anime.episodes.length > 0 ? 
                (anime.episodes.each do |episode|
                    puts "======"
                    puts "Episode Title: #{episode.title}"
                    puts "Episode No: #{episode.no}"
                    puts "Episode Image: #{episode.image}"
                    puts "======"
                end)
            : (puts "No episodes available.")
        when "json"
            params = {
                :id => anime.id,
                :title => anime.title,
                :image => anime.image,
                :synopsis => anime.synopsis,
                :score => anime.score
            }

            episodes = []

            anime.episodes.length > 0 && 
                (anime.episodes.each do |episode|
                    episodes.push({
                        :id => episode.id,
                        :no => episode.no,
                        :title => episode.title,
                        :image => episode.image
                    })
                end)
            
            params['episodes'] = episodes

            File.open("data.json","w+") do |f|
                f.write(JSON.pretty_generate(params))
                f.close
            end

            puts "Dumped data into `data.json`"
        when "stop"
            started = false
            puts "Bye."
        else
            "Invalid args, choose from the following: #{available_args}"
    end

    puts "\n"
end
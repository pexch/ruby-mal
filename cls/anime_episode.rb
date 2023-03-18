require 'stringex'

class AnimeEpisode
    attr_accessor :id, :no, :title, :image

    def initialize(no, title, image)
        @id = "episode-#{no}"
        @no = no
        @title = title
        @image = image
    end
end
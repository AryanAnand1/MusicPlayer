require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
BACKGROUND, PLAYER, UI = *0..2
end

module Genre
POP, CLASSIC, RB, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'R & B', 'Rock', 'Jazz']

class ArtWork
   attr_accessor :bmp
   def initialize (file)
       @bmp = Gosu::Image.new(file)
   end
end

class Track
attr_accessor :tra_key, :name, :location
def initialize (tra_key, name, location)
@tra_key = tra_key
@name = name
@location = location
end
end
  
class Album
attr_accessor :pri_key, :title, :artist,:artwork, :genre, :tracks
def initialize (pri_key, title, artist,artwork, genre, tracks)
@pri_key = pri_key
@title = title
       @artist = artist
       @artwork = artwork
@genre = genre
@tracks = tracks
end
end

class Song
   attr_accessor :song
   def initialize (file)
       @song = Gosu::Song.new(file)
   end
end

class MusicPlayerMain < Gosu::Window

   def initialize
   super 600, 800
           self.caption = "Music Player"
           @locs = [60,60]
           @font = Gosu::Font.new(self, "Century Gothic", 30)
           @a = 0
           @t = 0
   end

   def load_album()
           def read_track (music_file, i)
               track_key = i
               track_name = music_file.gets
               track_location = music_file.gets.chomp
               track = Track.new(track_key, track_name, track_location)
               return track
           end

           def read_tracks music_file
               count = music_file.gets.to_i
               tracks = Array.new()
               i = 0
               while i < count
                   track = read_track(music_file, i+1)
                   tracks << track
                   i = i + 1
               end
               tracks
           end

           def read_album(music_file, i)
               album_pri_key = i
               album_title = music_file.gets.chomp
               album_artist = music_file.gets
               album_artwork = music_file.gets.chomp
               album_genre = music_file.gets.to_i
               album_tracks = read_tracks(music_file)
               album = Album.new(album_pri_key, album_title, album_artist,album_artwork, album_genre, album_tracks)
               return album
           end

           def read_albums(music_file)
               count = music_file.gets.to_i
               albums = Array.new()
               i = 0
                   while i < count
                       album = read_album(music_file, i+1)
                       albums << album
                      
                       i = i + 1
                   end
               return albums
           end

           music_file = File.new("sounds.txt", "r")
           albums = read_albums(music_file)
           return albums
       end

  
   def needs_cursor?; true; end

  

   def draw_albums(albums)
           @bmp = Gosu::Image.new(albums[0].artwork)
           @bmp.draw(50, 50 , z = ZOrder::PLAYER, scale_x = 0.85, scale_y = 0.85)

           @bmp = Gosu::Image.new(albums[1].artwork)
           @bmp.draw(305, 50, z = ZOrder::PLAYER, scale_x = 0.85, scale_y = 0.85)

   end

   def draw_button()
       @bmp = Gosu::Image.new("images/play.png")
       @bmp.draw(110, 600, z = ZOrder::UI, scale_x = 0.20, scale_y = 0.20)

       @bmp = Gosu::Image.new("images/pause.png")
       @bmp.draw(210, 600, z = ZOrder::UI, scale_x = 0.20, scale_y = 0.20)

       @bmp = Gosu::Image.new("images/stop.png")
       @bmp.draw(310, 600, z = ZOrder::UI, scale_x = 0.20, scale_y = 0.20)

       @bmp = Gosu::Image.new("images/next.png")
       @bmp.draw(410, 600, z = ZOrder::UI, scale_x = 0.20, scale_y = 0.20)

       
      

    end

    def draw_background()
        Gosu.draw_rect(0, 0, 600, 800, Gosu::Color::BLACK, ZOrder::BACKGROUND, mode=:default)
    end

   def draw_text(a)
       albums = load_album()
      
    end

   def draw
       albums = load_album()
       i = 0
       x = 40
       y = 350
       @font.draw("MUSIC PLAYER", 230, 15, ZOrder::UI, 0.8, 0.8, Gosu::Color::WHITE)

       draw_albums(albums)
       draw_button()
       draw_background()
       if ((mouse_x > 45 and mouse_x < 260) and (mouse_y > 50 and mouse_y < 260))
        @bmp = Gosu::Image.new(albums[0].artwork)
           @bmp.draw(50, 50 , z = ZOrder::PLAYER, scale_x = 0.90, scale_y = 0.90)
            @font.draw("Album:  #{albums[0].title.to_s}", 45, 290, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
            @font.draw("Artist:  #{albums[0].artist.to_s}", 45, 310, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
            @font.draw("Genre:  #{GENRE_NAMES[albums[0].genre]}", 45, 330, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
            @font.draw("Tracks: ", 45, 350, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
            @font.draw("Track Location: ", 330, 350, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
            pad_y = 370
            while i < albums[0].tracks.length
                @font.draw("#{albums[0].tracks[i].name}", 45, pad_y , ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
                @font.draw("#{albums[0].tracks[i].location}", 330 , pad_y, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
                pad_y += 20
                i+=1
            end
        end

        if ((mouse_x > 305 and mouse_x < 520) and (mouse_y > 50 and mouse_y < 260))
            @bmp = Gosu::Image.new(albums[1].artwork)
            @bmp.draw(305, 50 , z = ZOrder::PLAYER, scale_x = 0.90, scale_y = 0.90)
             @font.draw("Album:  #{albums[1].title.to_s}", 45, 290, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
             @font.draw("Artist:  #{albums[1].artist.to_s}", 45, 310, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
             @font.draw("Genre:  #{GENRE_NAMES[albums[1].genre]}", 45, 330, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
             @font.draw("Tracks: ", 45, 350, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
             @font.draw("Track Location: ", 330, 350, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
             pad_y = 370
             while i < albums[1].tracks.length
                 @font.draw("#{albums[1].tracks[i].name}", 45, pad_y , ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
                 @font.draw("#{albums[1].tracks[i].location}", 330 , pad_y, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
                 pad_y += 20
                 i+=1
             end
        end

       if (!@song)
           while i < albums.length
               @font.draw("#{albums[i].title}", x += 150 , y, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
               i+=1
           end
       else
           while i < albums[@a-1].tracks.length
               @font.draw("#{albums[@a-1].tracks[i].name}", 45 , y+=20, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
               if (albums[@a-1].tracks[i].tra_key == @t)
                   @font.draw("<- Now Playing", x+200 , y, ZOrder::UI, 0.6, 0.6, Gosu::Color::WHITE)
               end
               i+=1
           end
       end
   end

   def playTrack(t, a)
       albums = load_album()
       i = 0
       while i < albums.length
           if (albums[i].pri_key == a)
               tracks = albums[i].tracks
               j = 0
                       while j < tracks.length
                               if (tracks[j].tra_key == t)
                                   @song = Gosu::Song.new(tracks[j].location)
                                   @song.play(false)
                               end
                               j+=1
                       end
           end
           i+=1
       end

    end

    def update()
        if (@song)
            if (!@song.playing?)
                @t+=1
            end
        end
    end


   def area_clicked(mouse_x, mouse_y)
       if ((mouse_x >50 && mouse_x < 260)&& (mouse_y > 50 && mouse_y < 280 ))# x album
           @a = 1
           @t = 1
           playTrack(@t, @a)
       end
       if ((mouse_x > 305 && mouse_x < 520) && (mouse_y > 50 && mouse_y < 280))# starboy album
           @a = 2
           @t = 1
           playTrack(@t, @a)
       end
       
       if ((mouse_x >110 && mouse_x < 140)&& (mouse_y > 600 && mouse_y < 640 ))#play
           @song.play
       end
       if ((mouse_x >210 && mouse_x < 240)&& (mouse_y > 600 && mouse_y < 640 ))#pause
           @song.pause
       end  
       if ((mouse_x >310 && mouse_x < 340)&& (mouse_y > 600 && mouse_y < 640 ))#stop
           @song.stop
       end  
       if ((mouse_x >410 && mouse_x < 460)&& (mouse_y > 600 && mouse_y < 640 ))#next
           if (@t == nil)
               @t = 1
           end
           @t += 1  
           playTrack(@t, @a)
       end  
    end

   def button_down(id)
       case id
           when Gosu::MsLeft
               @locs = [mouse_x, mouse_y]
               area_clicked(mouse_x, mouse_y)
       # What should happen here?
        end
   end

end
MusicPlayerMain.new.show if __FILE__ == $0
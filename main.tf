# https://learn.hashicorp.com/tutorials/terraform/spotify-playlist
# 1. export SPOTIFY_CLIENT_REDIRECT_URI=http://localhost:27228/spotify_callback
# 2. docker run --rm -it -p 27228:27228 --env-file ./.env ghcr.io/conradludgate/spotify-auth-proxy
# 3. click `auth` link in console
# 4. update terraform.tfvars with API key

terraform {
  required_providers {
    spotify = {
      version = "~> 0.1.7"
      source  = "conradludgate/spotify"
    }
  }
}

variable "spotify_api_key" {
  type = string
}

provider "spotify" {
  api_key = var.spotify_api_key
}

resource "spotify_playlist" "playlist" {
  name        = "Terraform Karl Playlist"
  description = "For Karl"
  public      = true

  tracks = [
    for track in data.spotify_search_track.this.tracks :
    track.id
  ]
}

data "spotify_search_track" "this" {
  artists  = ["Chanel West Coast"]
  album    = "Now You Know"
  name     = "Karl"
  explicit = true
  limit    = 20
}

# output "tracks" {
#   value = data.spotify_search_track.this.tracks
# }

# output "tracks_count" {
#   value = length(data.spotify_search_track.this.tracks)
# }

output "playlist_url" {
  value       = "https://open.spotify.com/playlist/${spotify_playlist.playlist.id}"
  description = "Visit this URL in your browser to listen to the playlist"
}
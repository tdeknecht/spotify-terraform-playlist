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
  name        = "Terraform Playlist"
  description = "Jamming to some Terraform code."
  public      = true

  tracks = [
    data.spotify_track.terraform.id,
    data.spotify_track.spotify.id,
    data.spotify_track.provider.id,
  ]
}
output "tracks" { value = spotify_playlist.playlist.tracks }
output "playlist_url" { value = "https://open.spotify.com/playlist/${spotify_playlist.playlist.id}" }

data "spotify_track" "terraform" {
  url = "https://open.spotify.com/track/5shiLLxKQ4U7XLELZeXzxy"
}

data "spotify_track" "spotify" {
  url = "https://open.spotify.com/track/2C2ZwSAx3qqawTmgklsfyo"
}

data "spotify_track" "provider" {
  url = "https://open.spotify.com/track/6R6ihJhRbgu7JxJKIbW57w"
}

#!/bin/bash
# GitHub webhook handler - forwards to Telegram via OpenClaw
# Listens on port 3000

PORT=3000
TELEGRAM_CHAT_ID="8274533218"

echo "Starting GitHub webhook handler on port $PORT..."

while true; do
  # Simple HTTP server using nc
  {
    while IFS= read -r line; do
      # Read HTTP request
      if [[ "$line" =~ ^POST ]]; then
        # Read headers
        headers=""
        body=""
        content_length=0
        
        while IFS= read -r header; do
          headers="$headers$header\n"
          if [[ "$header" =~ Content-Length: ]]; then
            content_length=$(echo "$header" | grep -o '[0-9]+')
          fi
          if [[ -z "$header" || "$header" == $'\r' ]]; then
            break
          fi
        done
        
        # Read body
        if [[ $content_length -gt 0 ]]; then
          body=$(dd bs=$content_length count=1 2>/dev/null)
        fi
        
        # Parse GitHub event
        event_type=$(echo "$headers" | grep -i "X-GitHub-Event:" | head -1)
        
        if [[ "$event_type" =~ push ]]; then
          # Extract push details from JSON body
          repo=$(echo "$body" | jq -r '.repository.full_name' 2>/dev/null)
          branch=$(echo "$body" | jq -r '.ref' 2>/dev/null | sed 's/refs\/heads\//')
          author=$(echo "$body" | jq -r '.pusher.name' 2>/dev/null)
          commits=$(echo "$body" | jq -r '.commits | length' 2>/dev/null)
          
          # Send to Telegram
          message="🦞 GitHub Push

Repo: $repo
Branch: $branch
Author: $author
Commits: $commits

https://github.com/$repo"
          
          openclaw message send --channel telegram --target "$TELEGRAM_CHAT_ID" --message "$message" 2>/dev/null
          
          echo "Forwarded push notification to Telegram: $repo/$branch"
        fi
        
        # Send HTTP response
        echo "HTTP/1.1 200 OK\r"
        echo "Content-Type: text/plain\r"
        echo "\r"
        echo "OK\r"
      fi
    done
  } | nc -l -p $PORT 2>/dev/null
done
#!/bin/sh

focus_next_window () {
  local current_space_index=$(
    yabai -m query --spaces \
    | jq '
      map(select(."has-focus" == true))
      | first|.index'
  )

  local next_window_id=$(
    yabai -m query --windows \
    | jq --arg space $current_space_index '
      map(select(.space == ($space|tonumber)))
      | sort_by(.id)
      | until(.[0]."has-focus" == true; .[1:])
      | map(.id)
      | nth(1)'
  )

  if [ $next_window_id = "null" ]; then
    next_window_id=$(
      yabai -m query --spaces \
      | jq '
        map(select(."has-focus" == true))
        | first|.windows
        | sort|first'
    )
  fi

  yabai -m window --focus $next_window_id
}

focus_next_window

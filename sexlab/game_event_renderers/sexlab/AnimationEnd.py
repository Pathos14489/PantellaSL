from src.logging import logging
def render(line_type, game_event_title, args_dict, line):
    """Render the line based on the line type."""
    logging.info(f"Rendering line: {line_type} - {game_event_title} - {line}", args_dict)
    return f"{args_dict['actors'][0]} and {args_dict['actors'][1]} have stopped having sex. The sex act they were doing was called {args_dict['animation_name']}."